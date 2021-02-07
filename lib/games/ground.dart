import 'dart:ui';

import 'package:dinogame/sprites/ground_sprite.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import 'game_engine.dart';

GroundSprite groundSprite = GroundSprite(imagePath: "assets/images/ground.png");

class Ground extends GameEngine {
  final Offset worldLocation;

  Ground({this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * WORLD_TO_PIXEL_RATIO,
      screenSize.height / 1.4 - groundSprite.imageHeight,
      groundSprite.imageWidth.toDouble(),
      groundSprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(groundSprite.imagePath);
  }
}
