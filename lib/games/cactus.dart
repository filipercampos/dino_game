import 'dart:math';
import 'dart:ui';

import 'package:dinogame/sprites/sprite.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import 'game_engine.dart';

const prefix = 'assets/images/cacti';

List<Sprite> cactus = [
  Sprite(
      imagePath: "$prefix/cacti_group.png", imageWidth: 104, imageHeight: 100),
  Sprite(
      imagePath: "$prefix/cacti_large_1.png", imageWidth: 50, imageHeight: 100),
  Sprite(
      imagePath: "$prefix/cacti_large_2.png", imageWidth: 98, imageHeight: 100),
  Sprite(
      imagePath: "$prefix/cacti_small_1.png", imageWidth: 34, imageHeight: 70),
  Sprite(
      imagePath: "$prefix/cacti_small_2.png", imageWidth: 68, imageHeight: 70),
  Sprite(
      imagePath: "$prefix/cacti_small_3.png", imageWidth: 107, imageHeight: 70)
];

class Cactus extends GameEngine {
  final Sprite sprite;
  final Offset worldLocation;

  Cactus({this.worldLocation}) : sprite = cactus[Random().nextInt(cactus.length)];

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * WORLD_TO_PIXEL_RATIO,
      screenSize.height / 1.4 - sprite.imageHeight,
      sprite.imageWidth,
      sprite.imageHeight,
    );
  }

  @override
  Widget render() {
    return Image.asset(sprite.imagePath);
  }
}
