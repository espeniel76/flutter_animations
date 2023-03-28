import 'package:animation_test1/morph.dart';
import 'package:animation_test1/morph_path.dart';
import 'package:animation_test1/morph_svg.dart';
import 'package:animation_test1/rotate.dart';
import 'package:animation_test1/svg_test.dart';
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
      // theme: ThemeData(primarySwatch: Colors.blue),
      // home: const DemoCreature(),
      // home: const MorphTest(),
      // home: const MorphSvgTest(),
      // home: SvgTest()
      home: MorphPathTest(),
      // home: RotateAnimation(),
    );
  }
}
