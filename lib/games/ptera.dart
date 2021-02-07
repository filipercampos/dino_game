import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../sprites/sprite.dart';
import 'game_engine.dart';

class Ptera extends GameEngine {
  Ptera({this.worldLocation});
  // this is a logical location which is translated to pixel coordinates
  final Offset worldLocation;
  double _distance = 0;
  double get distance => _distance;

  int frame = 0;
  final pteras = <Sprite>[
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
  @override
  Rect getRect(Size screenSize, double runDistance) {
    if (distance < 300) {
      _distance = _distance += 0.25;
    } else {
      _distance = 0;
    }
    double l = (worldLocation.dx - distance) * WORLD_TO_PIXEL_RATIO;
    double t = 6.5 / 7 * screenSize.height -
        pteras[frame].imageHeight -
        worldLocation.dy;
    double w = pteras[frame].imageWidth;
    double h = pteras[frame].imageHeight;

    return Rect.fromLTWH(l - 30, t, w - 40, h - 25);
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
    if (elapsedTime == null) {
      elapsedTime = Duration(milliseconds: 0);
    }
    frame = (elapsedTime.inMilliseconds / 200).floor() % 2;
  }
}
