import 'dart:ui';

import 'package:dinogame/sprites/sprite.dart';
import 'package:flutter/widgets.dart';
import '../constants.dart';
import 'game_engine.dart';

Sprite cloudSprite = Sprite(
  imagePath: "assets/images/cloud.png",
  imageWidth: 92,
  imageHeight: 27,
);

class Cloud extends GameEngine {
  final Offset worldLocation;

  Cloud({this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * WORLD_TO_PIXEL_RATIO / 5,
      screenSize.height / 5 - cloudSprite.imageHeight - worldLocation.dy,
      cloudSprite.imageWidth,
      cloudSprite.imageHeight,
    );
  }

  @override
  Widget render() {
    return Image.asset(cloudSprite.imagePath);
  }
}
