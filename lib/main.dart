import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'games/cactus.dart';
import 'games/cloud.dart';
import 'games/dino.dart';
import 'games/game.dart';
import 'games/game_engine.dart';
import 'games/ground.dart';

void main() => runApp(AppGame());

class AppGame extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: GamePlay()),
    );
  }
}
