import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:path_morph/path_morph.dart';

class MorphPathTest extends StatefulWidget {
  const MorphPathTest({Key key}) : super(key: key);

  @override
  State<MorphPathTest> createState() => _MorphPathTestState();
}

class _MorphPathTestState extends State<MorphPathTest> with TickerProviderStateMixin {
  SampledPathData _data;

  AnimationController controller;
  AnimationController controllerRotate;

  int radius = 110; // 반지름
  int rndMax = 30;
  double rndRotate = (Math.Random().nextInt(330)).toDouble();

  @override
  void initState() {
    super.initState();

    // 로테이션 애니메이션
    controllerRotate = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
      animationBehavior: AnimationBehavior.normal,
    );
    controllerRotate.forward();
    controllerRotate.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerRotate.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controllerRotate.forward();
      }
    });

    // 원 굴곡 애니메이션
    Path path1 = initRound(radius, 1, rndMax);
    Path path2 = initRound(radius, 1, rndMax);
    _data = PathMorph.samplePaths(path1, path2);
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      animationBehavior: AnimationBehavior.normal,
    );
    PathMorph.generateAnimations(controller, _data, (int i, Offset z) {
      setState(() {
        _data.shiftedPoints[i] = z;
      });
    });
    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    controllerRotate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage('assets/night-sky-g7048d4583_1920.jpg')
        )
      ),
      child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.6),
          appBar: AppBar(
            title: const Text('Round Wave'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Path path1 = initRound(radius, 0, 10);
                  Path path2 = initRound(radius, 0, 10);
                  setState(() {
                    _data = PathMorph.samplePaths(path1, path2);
                    PathMorph.generateAnimations(controller, _data, (int i, Offset z) {
                      setState(() {
                        _data.shiftedPoints[i] = z;
                      });
                    });
                  });
                  controller.addStatusListener((status) {
                    if (status == AnimationStatus.completed) {
                      controller.reverse();
                    } else if (status == AnimationStatus.dismissed) {
                      controller.forward();
                    }
                  });
                  controller.forward();
                },
                child: Text('1'),
                style: _btnStyle(),
              ),
              ElevatedButton(
                onPressed: () {
                  Path path1 = initRound(radius, 0, 30);
                  Path path2 = initRound(radius, 0, 30);
                  setState(() {
                    _data = PathMorph.samplePaths(path1, path2);
                    PathMorph.generateAnimations(controller, _data, (int i, Offset z) {
                      setState(() {
                        _data.shiftedPoints[i] = z;
                      });
                    });
                  });
                  controller.addStatusListener((status) {
                    if (status == AnimationStatus.completed) {
                      controller.reverse();
                    } else if (status == AnimationStatus.dismissed) {
                      controller.forward();
                    }
                  });
                  controller.forward();
                },
                child: Text('2'),
                style: _btnStyle(),
              ),
              ElevatedButton(
                onPressed: () {
                  Path path1 = initRound(radius, 0, 60);
                  Path path2 = initRound(radius, 0, 60);
                  setState(() {
                    _data = PathMorph.samplePaths(path1, path2);
                    PathMorph.generateAnimations(controller, _data, (int i, Offset z) {
                      setState(() {
                        _data.shiftedPoints[i] = z;
                      });
                    });
                  });
                  controller.addStatusListener((status) {
                    if (status == AnimationStatus.completed) {
                      controller.reverse();
                    } else if (status == AnimationStatus.dismissed) {
                      controller.forward();
                    }
                  });
                  controller.forward();
                },
                child: Text('3'),
                style: _btnStyle(),
              ),
            ],
          ),
          body: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(controllerRotate),
            child: Stack(children: [
              Positioned.fill(
                  child: CustomPaint(painter: MyPainter(PathMorph.generatePath(_data), radius, 0, Colors.white, 150, 2))),
              Positioned.fill(
                  child:
                      CustomPaint(painter: MyPainter(PathMorph.generatePath(_data), radius, 20, Colors.white, 120, 1))),
              Positioned.fill(
                  child: CustomPaint(painter: MyPainter(PathMorph.generatePath(_data), radius, 40, Colors.white, 90, 1))),
              // Positioned.fill(
              //     child: CustomPaint(painter: MyPainter(PathMorph.generatePath(_data), radius, 80, Colors.white, 60, 2))),
            ]),
          )),
    );
  }
}

class MyPainter extends CustomPainter {
  Path path;
  int radius;
  double rndRotate;
  Color color;
  int alpha;
  double strokeWidth;

  var myPaint;
  double halfWidth = 0;
  double halfHeight = 0;

  MyPainter(this.path, this.radius, this.rndRotate, this.color, this.alpha, this.strokeWidth) {
    myPaint = Paint()
      ..blendMode = BlendMode.lighten
      ..color = color.withAlpha(alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 10);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (halfWidth == 0) {
      halfWidth = size.width / 2;
      halfHeight = (size.height / 2) - radius / 2;
    }
    canvas.translate(halfWidth, halfHeight + (radius / 2));
    canvas.rotate(rndRotate);
    canvas.drawPath(path, myPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Path initRound(int radius, int min, int max) {
  Path path = Path();
  path.moveTo(0, -(radius.toDouble()));

  double length = radius.toDouble();

  int rndNum = min + Math.Random().nextInt(max - min);
  double x1 = length + rndNum;
  double y1 = 0;
  double x2 = length;
  double y2 = length - rndNum;
  double x3 = length;
  double y3 = length;
  path.relativeCubicTo(x1, y1, x2, y2, x3, y3);

  rndNum = min + Math.Random().nextInt(max - min);
  x1 = 0;
  y1 = length + rndNum;
  x2 = -length + rndNum;
  y2 = length;
  x3 = -length;
  y3 = length;
  path.relativeCubicTo(x1, y1, x2, y2, x3, y3);

  rndNum = min + Math.Random().nextInt(max - min);
  x1 = -length - (rndNum);
  y1 = 0;
  x2 = -length;
  y2 = -length + rndNum;
  x3 = -length;
  y3 = -length;
  path.relativeCubicTo(x1, y1, x2, y2, x3, y3);

  rndNum = min + Math.Random().nextInt(max - min);
  x1 = 0;
  y1 = -length - rndNum;
  x2 = length - rndNum;
  y2 = -length;
  x3 = length;
  y3 = -length;
  path.relativeCubicTo(x1, y1, x2, y2, x3, y3);
  path.close();

  return path;
}

ButtonStyle _btnStyle() {
  return ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.red),
      ),
    ),
  );
}
