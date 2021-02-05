import 'dart:ui';

import 'package:dinogame/sprites/dino_sprite.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../sprites/sprite.dart';
import 'game_engine.dart';

final prefix = 'assets/images/dino';

final List<Sprite> dino = [
  DinoSprite(imagePath: '$prefix/dino_1.png'),
  DinoSprite(imagePath: '$prefix/dino_2.png'),
  DinoSprite(imagePath: '$prefix/dino_3.png'),
  DinoSprite(imagePath: '$prefix/dino_4.png'),
  DinoSprite(imagePath: '$prefix/dino_5.png'),
  DinoSprite(imagePath: '$prefix/dino_6.png'),
];

enum DinoState {
  jumping,
  running,
  dead,
}

class Dino extends GameEngine {
  Sprite currentSprite = dino[0];
  double dispY = 0;
  double velY = 0;
  DinoState state = DinoState.running;
  bool get isDead => state == DinoState.dead;
  @override
  Widget render() {
    return Image.asset(currentSprite.imagePath);
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 2 - currentSprite.imageHeight - dispY,
      currentSprite.imageWidth,
      currentSprite.imageHeight,
    );
  }

  @override
  void update(Duration lastTime, Duration currentTime) {
    if (currentTime == null) {
      currentTime = Duration(milliseconds: 0);
    }
    currentSprite = dino[(currentTime.inMilliseconds / 100).floor() % 2 + 2];

    double elapsedTimeSeconds = (currentTime - lastTime).inMilliseconds / 1000;

    dispY += velY * elapsedTimeSeconds;
    if (dispY <= 0) {
      dispY = 0;
      velY = 0;
      state = DinoState.running;
    } else {
      velY -= GRAVITY_PPSS * elapsedTimeSeconds;
    }
  }

  void jump() {
    if (state != DinoState.jumping) {
      state = DinoState.jumping;
      velY = 750;
    }
  }

  void die() {
    currentSprite = dino[5];
    state = DinoState.dead;
  }

  void revive() {
    currentSprite = dino[0];
    state = DinoState.running;
  }
}
