import 'dart:math';
import 'package:flutter/material.dart';

class Animation10 extends StatefulWidget {
  const Animation10({Key key}) : super(key: key);

  @override
  _Animation10State createState() => _Animation10State();
}

class _Animation10State extends State<Animation10> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation 10"),
      ),
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: 250,
          height: 250,
          color: Colors.lightGreen,
          child: CustomPaint(
            painter: _painter(animationValue: _animationController.value),
          ),
        );
      },
    );
  }
}

class _painter extends CustomPainter {
  final animationValue;

  _painter({this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    double heightParameter = 30;
    double periodParameter = 0.5;

    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path = Path();
    // TODO: do operations here

    for (double i = 0; i < 250; i++) {
      path.lineTo(i, 125 + heightParameter * sin(animationValue * pi * 2 + periodParameter * i * (pi / 180)));
      path.moveTo(i, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
