import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  runApp(AppGame());
}
