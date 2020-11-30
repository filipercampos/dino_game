import 'package:flutter/widgets.dart';

abstract class GameEngine {
  Widget render();
  Rect getRect(Size screenSize, double runDistance);
  void update(Duration lastUpdate, Duration elapsedTime) {}
}
