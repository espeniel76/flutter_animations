import 'package:flutter/material.dart';
import 'package:flutter_path_morph/flutter_path_morph.dart';

class MorphTest extends StatefulWidget {
  const MorphTest({Key key}) : super(key: key);

  @override
  _MorphTestState createState() => _MorphTestState();
}

class _MorphTestState extends State<MorphTest> with TickerProviderStateMixin {
  Path _path1 = Path()
    ..moveTo(60, 200)
    ..lineTo(60, 150)
    ..lineTo(200, 150)
    ..lineTo(200, 200);
  Path _path2 = Path()
    ..moveTo(60, 200)
    ..lineTo(90, 150)
    ..lineTo(150, 100)
    ..lineTo(180, 150)
    ..lineTo(250, 190)
    ..lineTo(250, 250);

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
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
  void dispose() {
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MorphWidget(
        controller: _controller,
        path1: _path1,
        path2: _path2,
      ),
    );
  }
}
