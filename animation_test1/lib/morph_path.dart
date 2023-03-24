import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:path_morph/path_morph.dart';

class MorphPathTest extends StatefulWidget {
  const MorphPathTest({Key key}) : super(key: key);

  @override
  State<MorphPathTest> createState() => _MorphPathTestState();
}

class _MorphPathTestState extends State<MorphPathTest> with SingleTickerProviderStateMixin {
  SampledPathData data1;
  SampledPathData data2;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    int radius = 100; // 반지름
    int curve = 1; // 곡면
    int cntRnd = 0; // 랜덤 생성 비율
    int rndHeight = 20; // 랜덤 높이

    // 해당 원 크기에 따른 좌표 정보 셋팅
    // List<Offset> offsets = initRound(radius, curve);

    // Path path1 = createRandomPath(radius, offsets, curve, cntRnd, rndHeight);
    // Path path2 = createRandomPath(radius, offsets, curve, cntRnd, rndHeight);
    Path path1 = initRound(radius);
    Path path2 = initRound(radius);
    data1 = PathMorph.samplePaths(path1, path2);

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      animationBehavior: AnimationBehavior.preserve,
    );

    PathMorph.generateAnimations(controller, data1, func);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  void func(int i, Offset z) {
    setState(() {
      data1.shiftedPoints[i] = z;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('타이틀'),
      ),
      backgroundColor: Colors.black,
      body: Stack(children: [
        Positioned.fill(
          child: CustomPaint(
            painter: MyPainter(
              PathMorph.generatePath(data1),
            ),
          ),
        ),
      ]),
    );
  }
}

class MyPainter extends CustomPainter {
  Path path;
  var myPaint;
  double halfWidth = 0;
  double halfHeight = 0;

  MyPainter(this.path) {
    myPaint = Paint()
      ..blendMode = BlendMode.lighten
      ..color = Colors.yellow.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 10);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (halfWidth == 0) {
      halfWidth = size.width / 2;
      halfHeight = size.height / 2;
    }
    canvas.translate(halfWidth, halfHeight);
    // path.moveTo(100, 0);
    // path.relativeCubicTo(0, 0, 0, 0, -100, 100);

    canvas.drawPath(path, myPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Path createRandomPath(int radius, List<Offset> offsetsRef, int curve, int cntRnd, int height) {
  List<Offset> offsets = List.of(offsetsRef);
  double x = 0;
  double y = 0;

  for (num i = 0; i < cntRnd; i++) {
    int rndNum = Math.Random().nextInt(offsets.length - 1);
    // int rndNum = 20;
    int rndPoint = rndNum * curve;
    x = getCos(radius + height, rndPoint);
    y = getSin(radius + height, rndPoint);
    offsets[rndNum + 1] = Offset(x, y);
  }

  // 랜덤 포인트 주위 값들 보정..v

  Path path = Path();
  path.moveTo(offsets[0].dx, 0);
  for (num i = 1; i < offsets.length; i++) {
    path.lineTo(offsets[i].dx, offsets[i].dy);
  }
  return path;
}

Path initRound(int radius) {
  Path path = Path();
  path.moveTo(0, -100);

  double length = radius.toDouble();

  int min = 15;
  int max = 40;
  int rndNum = min + Math.Random().nextInt(max - min);
  double rndNum4 = 5;
  double x1 = ((length / 5) * 5) + rndNum;
  double y1 = 0;
  double x2 = length;
  double y2 = ((length / 5) * 5) + rndNum;
  double x3 = length;
  double y3 = length;
  path.relativeCubicTo(x1, y1, x2, y2, x3, y3);

  rndNum = min + Math.Random().nextInt(max - min);
  x1 = 0;
  y1 = ((length / 5) * 5) + rndNum;
  x2 = -((length / 5) * 5) + rndNum;
  y2 = length;
  x3 = -length;
  y3 = length;
  path.relativeCubicTo(x1, y1, x2, y2, x3, y3);

  rndNum = min + Math.Random().nextInt(max - min);
  x1 = -((length / 5) * 5) + rndNum;
  y1 = 0;
  x2 = -length;
  y2 = -((length / 5) * 5) + rndNum;
  x3 = -length;
  y3 = -length;
  path.relativeCubicTo(x1, y1, x2, y2, x3, y3);

  rndNum = min + Math.Random().nextInt(max - min);
  x1 = 0;
  y1 = -((length / 5) * 5) + rndNum;
  x2 = (length / 5) * 5 + rndNum;
  y2 = -length;
  x3 = length;
  y3 = -length;
  path.relativeCubicTo(x1, y1, x2, y2, x3, y3);
  path.close();

  return path;
}

// List<Offset> initRound(int radius, int curve) {
//   double x = 0;
//   double y = 0;
//   var offsets = <Offset>[];
//   offsets.add(Offset(radius.toDouble(), y));
//   for (num i = 0; i <= 360; i += curve) {
//     x = getCos(radius, i);
//     y = getSin(radius, i);
//     offsets.add(Offset(x, y));
//   }
//   return offsets;
// }

double getSin(int radius, int arcDegree) {
  return double.parse(((radius) * Math.sin(toRadians(arcDegree))).toStringAsFixed(3));
}

double getCos(int radius, int arcDegree) {
  return double.parse(((radius) * Math.cos(toRadians(arcDegree))).toStringAsFixed(3));
}

double toRadians(num degrees) {
  return degrees * (Math.pi / 180);
}
