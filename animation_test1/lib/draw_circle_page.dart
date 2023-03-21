import 'dart:math' as Math;

import 'package:flutter/material.dart';

import 'common.dart';

class DrawCirclePage extends StatefulWidget {
  const DrawCirclePage({
    Key key,
  }) : super(key: key);

  @override
  _DrawCirclePageState createState() => _DrawCirclePageState();
}

class _DrawCirclePageState extends State<DrawCirclePage> with TickerProviderStateMixin {
  static const colors = <Color>[
    Color(0xFFFF2964),
    Color(0xFF32FF3A),
    Color(0xFF4255FF),
  ];
  AnimationController controller;
  AnimationController addPointController;
  Animation<double> addPointAnimation;
  int _counter = 1;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      upperBound: 2,
      duration: const Duration(seconds: 10),
    )..repeat();
    addPointController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    addPointAnimation = addPointController.drive(CurveTween(curve: Curves.easeInOutCubicEmphasized));
  }

  @override
  void dispose() {
    controller.dispose();
    addPointController.dispose();
    super.dispose();
  }

  // 증가 클릭
  void _incrementCounter() {
    setState(() {
      _counter++;
      addPointController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creature')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 100),
              curve: Curves.bounceIn,
              builder: (_, double opacity, __) {
                return CustomPaint(
                  painter: CreaturePainter(controller),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CreaturePainter extends CustomPainter {
  // final offsets = <Offset>[];
  final Animation<double> animation;
  final int index = 0;
  final Color color = Colors.white;
  final int count = 1;
  static const twoPi = Math.pi * 2;

  double x = 0;
  double y = 0;
  double halfWidth = 0;
  double halfHeight = 0;
  int cnt = 0;
  var radius = 120; //반지름

  CreaturePainter(this.animation) : super(repaint: animation) {}

  @override
  void paint(Canvas canvas, Size size) {
    if (halfWidth == 0) {
      halfWidth = size.width / 2;
      halfHeight = size.height / 2;
    }
    canvas.translate(halfWidth, halfHeight);

    final offsets = <Offset>[];
    for (num i = 0; i <= 360; i += 1) {
      x = radius * Math.cos(toRadians(i));
      y = radius * Math.sin(toRadians(i));
      offsets.add(Offset(x, y));
    }
    if (cnt < offsets.length) {
      offsets[cnt] = Offset(0, offsets[cnt].dy);
      cnt++;
    } else {
      cnt = 0;
    }
    // print(offsets.length);

    final path = Path()..addPolygon(offsets, false);
    canvas.drawPath(
      path,
      Paint()
        ..blendMode = BlendMode.lighten
        ..color = Colors.yellow
        ..strokeWidth = 10
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10),
    );
  }

  double toRadians(num degrees) {
    return degrees * (Math.pi / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
