import 'sprite.dart';

class DinoSprite extends Sprite {
  DinoSprite({
    String imagePath,
    int imageWidth,
    int imageHeight,
  }) : super(
    imagePath: imagePath,
    imageWidth: imageWidth ?? 88,
    imageHeight: imageHeight ?? 94,
  );
}
