import 'dart:async';
import 'dart:math';

import 'package:dinogame/games/ptera.dart';
import 'package:dinogame/games/dino.dart';
import 'package:dinogame/games/ptera_dino.dart';
import 'package:dinogame/games/sound.dart';
import 'package:flutter/material.dart';

import 'cactus.dart';
import 'cloud.dart';
import 'game_engine.dart';
import 'ground.dart';

class GamePlay extends StatefulWidget {
  @override
  _GamePlayState createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay>
    with SingleTickerProviderStateMixin {
  dynamic dino = Dino();
  DinoCharacter character = DinoCharacter.dino;

  Ptera ptera = Ptera(worldLocation: Offset(300, 80));
  double runDistance = 0;
  double runVelocity = 30;
  AnimationController worldController;
  bool stop = false;
  Duration lastUpdateCall;

  List<Cactus> cacti;
  List<Ground> grounds;
  List<Cloud> clouds;
  int _score = 0;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    Sound().loadSounds();
    _initGame();
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
    _score = 0;
    lastUpdateCall = Duration();
    ptera = Ptera(worldLocation: Offset(300, 80));
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
    _startTimerVelocity();
  }

  void _restart() {
    if (character == DinoCharacter.dino) {
      dino = Dino();
    } else {
      dino = PteraDino();
    }
    dino.revive();
    _initGame();
    worldController.forward();
  }

  void _die() {
    setState(() {
      Sound().died();
      worldController.stop();
      stop = true;
      dino.die();
    });
  }

  _update() {
    dino.update(lastUpdateCall, worldController.lastElapsedDuration);

    double elapsedTimeSeconds =
        (worldController.lastElapsedDuration - lastUpdateCall).inMilliseconds /
            1000;

    runDistance += runVelocity * elapsedTimeSeconds;

    _buildCactus();
    _buildGrounds();
    _buildClouds();
    _buildPtera();

    lastUpdateCall = worldController.lastElapsedDuration;
  }

  _buildGrounds() {
    Size screenSize = MediaQuery.of(context).size;

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
  }

  _buildCactus() {
    Size screenSize = MediaQuery.of(context).size;
    var screenCalc = Size(screenSize.width - 70, screenSize.height - 70);
    Rect dinoRect = dino.getRect(screenCalc, runDistance);
    for (Cactus cactus in cacti) {
      Rect obstacleRect = cactus.getRect(screenSize, runDistance);
      if (dinoRect.overlaps(obstacleRect)) {
        //_die();
      }

      if (obstacleRect.right < 0) {
        setState(() {
          cacti.remove(cactus);
          cacti.add(Cactus(
            worldLocation: Offset(runDistance + Random().nextInt(100) + 50, 0),
          ));
          _score += 2;
        });
      }
    }
  }

  _buildPtera() {
    Size screenSize = MediaQuery.of(context).size;
    Rect dinoRect = dino.getRect(screenSize, runDistance);
    Rect obstacleRect = ptera.getRect(screenSize, runDistance);
    if (dinoRect.overlaps(obstacleRect)) {
      //  _die();
    }
    setState(() {
      if (ptera.distance > 230 && ptera.distance < 290) {
        cacti.clear();
      } else if (cacti.isEmpty) {
        cacti = [
          Cactus(
            worldLocation: Offset(runDistance + Random().nextInt(100) + 200, 0),
          )
        ];
      }

      ptera.update(lastUpdateCall, worldController.lastElapsedDuration);
    });
  }

  _buildClouds() {
    Size screenSize = MediaQuery.of(context).size;
    for (Cloud cloud in clouds) {
      if (cloud.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          clouds.remove(cloud);
          clouds.add(
            Cloud(
              worldLocation: Offset(
                  clouds.last.worldLocation.dx + Random().nextInt(100) + 50,
                  Random().nextInt(40) - 20.0),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];

    for (GameEngine object in [...clouds, ...grounds, ...cacti, dino, ptera]) {
      children.add(
        AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          },
        ),
      );
    }

    children.add(Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 20.0, top: 8.0),
        child: Text(
          "Score: $_score",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ));

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: _selectCharacter,
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
        if (worldController.isAnimating) {
          if (runVelocity > 50 || dino.isDead) {
            //pare o incremento de velocidade
            setState(() {
              timer.cancel();
            });
          } else {
            setState(() {
              runVelocity++;
            });
          }
        }
        debugPrint('Speed $runVelocity');
      },
    );
  }

  void _selectCharacter() async {
    setState(() {
      stop = true;
    });
    worldController.stop();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text('Personagens')),
        content: Text('Selecione o personagem'),
        actions: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          character = DinoCharacter.dino;
                        });
                        Navigator.of(context).pop();
                        _restart();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset('assets/images/dino/dino_1.png'),
                          ),
                          Text('T-Rex'),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          character = DinoCharacter.ptera;
                        });
                        Navigator.of(context).pop();
                        _restart();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'assets/images/ptera_right/ptera_1.png',
                            ),
                          ),
                          Text(
                            'Ptera',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
    worldController.forward();
  }
}

enum DinoCharacter {
  dino,
  ptera,
}
