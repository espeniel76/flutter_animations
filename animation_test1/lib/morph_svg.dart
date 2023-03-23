import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter_path_morph/flutter_path_morph.dart';

class MorphSvgTest extends StatefulWidget {
  const MorphSvgTest({Key key}) : super(key: key);

  @override
  State<MorphSvgTest> createState() => _MorphSvgTestState();
}

class _MorphSvgTestState extends State<MorphSvgTest> with TickerProviderStateMixin {
  AnimationController _controller;
  Path _homePath;
  Matrix4 _appleScaleMatrix4;
  Path _applePath;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _homePath = parseSvgPathData('m48.75 95.97-25.91-25.74 14.32-14.57 40.39 40.31z');
    _appleScaleMatrix4 = Matrix4.identity()..scale(0.2, 0.2);
    _applePath = parseSvgPathData('m.29 47.85 14.58 14.57 62.2-62.2h-29.02z').transform(_appleScaleMatrix4.storage);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: MorphWidget(
          controller: _controller,
          path1: _homePath,
          path2: _applePath,
        ),
      ),
    );
  }
}
