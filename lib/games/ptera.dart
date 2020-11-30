import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../sprites/sprite.dart';
import 'game_engine.dart';

List<Sprite> pteras = [
  Sprite(
    imagePath: "assets/images/ptera/ptera_1.png",
    imageHeight: 80,
    imageWidth: 92,
  ),
  Sprite(
      imagePath: "assets/images/ptera/ptera_2.png",
      imageHeight: 80,
      imageWidth: 92)
];

class Ptera extends GameEngine {
  // this is a logical location which is translated to pixel coordinates
  final Offset worldLocation;
  int frame = 0;

  Ptera({this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * WORLD_TO_PIXEL_RATIO,
      4 / 7 * screenSize.height - pteras[frame].imageHeight - worldLocation.dy,
      pteras[frame].imageWidth,
      pteras[frame].imageHeight,
    );
  }

  @override
  Widget render() {
    return Image.asset(
      pteras[frame].imagePath,
      gaplessPlayback: true,
    );
  }

  @override
  void update(Duration lastUpdate, Duration elapsedTime) {
    frame = (elapsedTime.inMilliseconds / 200).floor() % 2;
  }
}
