import 'package:animation_test1/draw_circle_page.dart';
import 'package:animation_test1/circle_wave_animation.dart';
import 'package:flutter/material.dart';

import 'demo_creature.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: const DemoCreature(),
      // home: Animation10(),
      home: DrawCirclePage(),
    );
  }
}