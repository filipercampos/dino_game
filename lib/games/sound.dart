import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class Sound {
  Sound._internal();

  void loadSounds() async {
    await audioCache.loadAll([
      'jump_sound.mp3',
      'score_sound.mp3',
      'died_sound.mp3',
    ]);
    debugPrint('Sounds load');
  }

  static Sound _instance = Sound._internal();
  factory Sound() => _instance;
  final AudioCache audioCache = AudioCache(
    prefix: 'assets/sounds/',
    fixedPlayer: AudioPlayer(),
  );

  String sound;
  String path;
  void jump() async {
    await audioCache.play("jump_sound.mp3");
  }

  void score() async {
    await audioCache.play("score_sound.mp3");
  }

  void died() async {
    await audioCache.play("died_sound.mp3");
  }
}
