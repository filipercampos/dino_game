import 'sprite.dart';

class GroundSprite extends Sprite {
  GroundSprite({
    String imagePath,
    int imageWidth,
    int imageHeight,
  }) : super(
    imagePath: imagePath,
    imageWidth: imageWidth ?? 2399,
    imageHeight: imageHeight ?? 24,
  );
}
