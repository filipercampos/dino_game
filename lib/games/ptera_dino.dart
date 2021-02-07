import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../sprites/sprite.dart';
import 'dino.dart';
import 'game_engine.dart';

final prefix = 'assets/images/ptera_right';

final List<Sprite> ptera = [
  Sprite(imagePath: '$prefix/ptera_1.png', imageHeight: 80, imageWidth: 92),
  Sprite(imagePath: '$prefix/ptera_2.png', imageHeight: 80, imageWidth: 92),
];

class PteraDino extends GameEngine {
  Sprite currentSprite = ptera[0];
  double dispY = 0;
  double velY = 0;
  DinoState state = DinoState.running;
  bool get isDead => state == DinoState.dead;
  @override
  Widget render() {
    return Image.asset(currentSprite.imagePath,);
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 1.4 - currentSprite.imageHeight - dispY,
      currentSprite.imageWidth,
      currentSprite.imageHeight,
    );
  }

  @override
  void update(Duration lastTime, Duration currentTime) {
    if (currentTime == null) {
      currentTime = Duration(milliseconds: 0);
    }

    currentSprite = ptera[(currentTime.inMilliseconds / 100).floor() % 2];

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
      velY = 800;
    }
  }

  void die() {
    currentSprite = ptera[0];
    state = DinoState.dead;
  }

  void revive() {
    currentSprite = ptera[0];
    state = DinoState.running;
  }
}
