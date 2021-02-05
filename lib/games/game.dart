import 'dart:async';
import 'dart:math';

import 'package:dinogame/games/sound.dart';
import 'package:flutter/material.dart';

import 'cactus.dart';
import 'cloud.dart';
import 'dino.dart';
import 'game_engine.dart';
import 'ground.dart';

class GamePlay extends StatefulWidget {
  @override
  _GamePlayState createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay>
    with SingleTickerProviderStateMixin {
  Dino dino = Dino();
  double runDistance = 0;
  double runVelocity = 30;
  AnimationController worldController;
  Duration lastUpdateCall;

  List<Cactus> cacti;

  List<Ground> grounds;

  List<Cloud> clouds;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    Sound().loadSounds();
    _initGame();
    _startTimerVelocity();
    worldController =
        AnimationController(vsync: this, duration: Duration(days: 99));
    worldController.addListener(_update);
    worldController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _initGame() {
    runDistance = 0;
    runVelocity = 30;

    lastUpdateCall = Duration();

    cacti = [Cactus(worldLocation: Offset(200, 0))];

    grounds = [
      Ground(worldLocation: Offset(0, 0)),
      Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
    ];

    clouds = [
      Cloud(worldLocation: Offset(100, 20)),
      Cloud(worldLocation: Offset(200, 10)),
      Cloud(worldLocation: Offset(350, -10)),
    ];
  }

  void _restart() {
    dino.revive();
    _initGame();
    worldController.forward();
  }

  void _die() {
    setState(() {
      Sound().died();
      worldController.stop();
      dino.die();
    });
  }

  _update() {
    dino.update(lastUpdateCall, worldController.lastElapsedDuration);

    double elapsedTimeSeconds =
        (worldController.lastElapsedDuration - lastUpdateCall).inMilliseconds /
            1000;

    runDistance += runVelocity * elapsedTimeSeconds;

    Size screenSize = MediaQuery.of(context).size;
    var screenCalc = Size(screenSize.width - 70, screenSize.height - 70);

    Rect dinoRect = dino.getRect(screenCalc, runDistance);
    for (Cactus cactus in cacti) {
      Rect obstacleRect = cactus.getRect(screenSize, runDistance);
      if (dinoRect.overlaps(obstacleRect)) {
        _die();
      }

      if (obstacleRect.right < 0) {
        setState(() {
          cacti.remove(cactus);
          cacti.add(
            Cactus(
              worldLocation:
                  Offset(runDistance + Random().nextInt(100) + 50, 0),
            ),
          );
        });
      }
    }

    for (Ground groundlet in grounds) {
      if (groundlet.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          grounds.remove(groundlet);
          grounds.add(
            Ground(
              worldLocation: Offset(
                  grounds.last.worldLocation.dx + groundSprite.imageWidth / 10,
                  0),
            ),
          );
        });
      }
    }

    for (Cloud cloud in clouds) {
      if (cloud.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          clouds.remove(cloud);
          clouds.add(Cloud(
              worldLocation: Offset(
                  clouds.last.worldLocation.dx + Random().nextInt(100) + 50,
                  Random().nextInt(40) - 20.0)));
        });
      }
    }

    lastUpdateCall = worldController.lastElapsedDuration;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];
    for (GameEngine object in [...clouds, ...grounds, ...cacti, dino]) {
      children.add(AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height +
                  (screenSize.height / 2.5), //abaixo do centro
              child: object.render(),
            );
          }));
    }

    children.add(Align(
      alignment: Alignment.topRight,
      child: Container(
        child: Text(
          "Score:",
          style: TextStyle(color: Colors.black),
        ),
      ),
    ));

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: dino.isDead
            ? () {
                setState(() {
                  _restart();
                });
              }
            : null,
        onTap: () {
          if (!dino.isDead) {
            Sound().jump();
          }
          dino.jump();
        },
        child: Stack(
          alignment: Alignment.center,
          children: children,
        ),
      ),
    );
  }

  void _startTimerVelocity() {
    _timer = Timer.periodic(
      Duration(seconds: 3),
      (Timer timer) {
        if (runVelocity == 200) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            runVelocity += 1;
          });
        }
      },
    );
  }
}
