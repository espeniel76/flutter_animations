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

    int radius = 120;

    List<Offset> offsets = initRound(radius);
    Path path1 = createRandomPath(radius, offsets, 1);
    Path path2 = createRandomPath(radius, offsets, 1);
    data1 = PathMorph.samplePaths(path1, path2);

    path1 = createRandomPath(radius, offsets, 2);
    path2 = createRandomPath(radius, offsets, 2);
    data2 = PathMorph.samplePaths(path1, path2);

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      animationBehavior: AnimationBehavior.preserve,
    );

    PathMorph.generateAnimations(controller, data1, func);
    PathMorph.generateAnimations(controller, data2, func);

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
      data2.shiftedPoints[i] = z;
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
        Positioned.fill(
          child: CustomPaint(
            painter: MyPainter(
              PathMorph.generatePath(data2),
            ),
          ),
        )
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
      ..color = Colors.white.withAlpha(150)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 7);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (halfWidth == 0) {
      halfWidth = size.width / 2;
      halfHeight = size.height / 2;
    }
    canvas.translate(halfWidth, halfHeight);
    canvas.drawPath(path, myPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Path createRandomPath(int radius, List<Offset> offsetsRef, int cntRnd) {
  // 이렇게 하면 call by value 가 된다
  List<Offset> offsets = List.of(offsetsRef);
  List<int> rndPoints = [];

  // 정해진 개수만큼
  for (num i = 0; i < cntRnd; i++) {
    // 랜덤 포인트를 선정한다.
    int rndPoint = Math.Random().nextInt(offsets.length - 1);
    // int rndPoint = 100;
    // 해당포인트의 x, y 좌표를 다시 구한다.
    double x = double.parse(((radius + 10) * Math.cos(toRadians(rndPoint))).toStringAsFixed(3));
    double y = double.parse(((radius + 10) * Math.sin(toRadians(rndPoint))).toStringAsFixed(3));
    // 구한 좌표를 재 할당한다.
    offsets[rndPoint] = Offset(x, y);
    rndPoints.add(rndPoint);
  }

  // 랜덤 포인트 주위 값들 보정..
  for (int i = 0; i < rndPoints.length; i++) {
    int rndNow = rndPoints[i];

    // 앞으로 20칸
    int add = 0;
    int nForward = 10;
    for (int k = rndNow + 1; k <= rndNow + nForward; k++) {
      add++;
      double x = double.parse(((radius + (nForward - add)) * Math.cos(toRadians(k))).toStringAsFixed(3));
      double y = double.parse(((radius + (nForward - add)) * Math.sin(toRadians(k))).toStringAsFixed(3));
      offsets[k] = Offset(x, y);
    }
    // 뒤로 20칸
    add = 0;
    int nReward = 10;
    for (int k = rndNow - 1; k > rndNow - nReward; k--) {
      add--;
      double x = double.parse(((radius + (nReward + add)) * Math.cos(toRadians(k))).toStringAsFixed(3));
      double y = double.parse(((radius + (nReward + add)) * Math.sin(toRadians(k))).toStringAsFixed(3));
      offsets[k] = Offset(x, y);
    }

    // // 앞으로 20칸 뒤에도 값이 있으면
    // if (rndNow + 20 < rndPoints.length) {
    //   // 뒤로 20칸 뒤에도
    // } else {
    //
    // }
  }

  // 최종값을 할당한다.
  Path path = Path();
  path.moveTo(offsets[0].dx, 0);
  for (num i = 1; i < offsets.length; i++) {
    path.lineTo(offsets[i].dx, offsets[i].dy);
  }

  return path;
  // for (num i = 1; i <= 360; i++) {
  //   // int rndWaveHeight = Math.Random().nextInt(10);
  //   x = double.parse((radius * Math.cos(toRadians(i))).toStringAsFixed(3));
  //   y = double.parse((radius * Math.sin(toRadians(i))).toStringAsFixed(3));
  //   // var offset = Offset(x, y);
  //   path.lineTo(x, y);
  // }
  // return path;
}

double toRadians(num degrees) {
  return degrees * (Math.pi / 180);
}

List<Offset> initRound(int radius) {
  double x = 0;
  double y = 0;
  var offsets = <Offset>[];
  offsets.add(Offset(radius.toDouble(), y));
  for (num i = 1; i <= 360; i++) {
    x = double.parse((radius * Math.cos(toRadians(i))).toStringAsFixed(3));
    y = double.parse((radius * Math.sin(toRadians(i))).toStringAsFixed(3));
    offsets.add(Offset(x, y));
  }
  return offsets;
}

Path createPath1() {
  return Path()
    ..moveTo(108.0, 0.0)
    ..lineTo(100.62, 8.8)
    ..lineTo(99.47, 17.54)
    ..lineTo(101.42, 27.18)
    ..lineTo(102.43, 37.28)
    ..lineTo(95.16, 44.37)
    ..lineTo(90.93, 52.5)
    ..lineTo(83.55, 58.5)
    ..lineTo(81.2, 68.14)
    ..lineTo(72.12, 72.12)
    ..lineTo(69.42, 82.73)
    ..lineTo(57.36, 81.92)
    ..lineTo(54.0, 93.53)
    ..lineTo(46.07, 98.79)
    ..lineTo(35.23, 96.79)
    ..lineTo(26.66, 99.49)
    ..lineTo(17.89, 101.44)
    ..lineTo(9.5, 108.59)
    ..lineTo(0.0, 102.0)
    ..lineTo(-8.8, 100.62)
    ..lineTo(-18.93, 107.34)
    ..lineTo(-26.66, 99.49)
    ..lineTo(-34.89, 95.85)
    ..lineTo(-43.11, 92.44)
    ..lineTo(-54.0, 93.53)
    ..lineTo(-59.08, 84.37)
    ..lineTo(-65.56, 78.14)
    ..lineTo(-74.25, 74.25)
    ..lineTo(-78.14, 65.56)
    ..lineTo(-82.73, 57.93)
    ..lineTo(-94.4, 54.5)
    ..lineTo(-94.26, 43.95)
    ..lineTo(-98.67, 35.91)
    ..lineTo(-102.39, 27.43)
    ..lineTo(-98.48, 17.36)
    ..lineTo(-100.62, 8.8)
    ..lineTo(-107.0, 0.0)
    ..lineTo(-101.61, -8.89)
    ..lineTo(-103.4, -18.23)
    ..lineTo(-102.39, -27.43)
    ..lineTo(-102.43, -37.28)
    ..lineTo(-98.79, -46.07)
    ..lineTo(-91.8, -53.0)
    ..lineTo(-84.37, -59.08)
    ..lineTo(-79.67, -66.85)
    ..lineTo(-73.54, -73.54)
    ..lineTo(-64.28, -76.6)
    ..lineTo(-62.52, -89.29)
    ..lineTo(-52.0, -90.07)
    ..lineTo(-46.07, -98.79)
    ..lineTo(-34.54, -94.91)
    ..lineTo(-26.92, -100.46)
    ..lineTo(-18.75, -106.36)
    ..lineTo(-9.06, -103.6)
    ..lineTo(-0.0, -101.0)
    ..lineTo(9.33, -106.59)
    ..lineTo(18.06, -102.42)
    ..lineTo(26.4, -98.52)
    ..lineTo(37.28, -102.43)
    ..lineTo(46.07, -98.79)
    ..lineTo(53.0, -91.8)
    ..lineTo(59.08, -84.37)
    ..lineTo(65.56, -78.14)
    ..lineTo(77.07, -77.07)
    ..lineTo(78.9, -66.21)
    ..lineTo(83.55, -58.5)
    ..lineTo(86.6, -50.0)
    ..lineTo(95.16, -44.37)
    ..lineTo(97.73, -35.57)
    ..lineTo(104.32, -27.95)
    ..lineTo(105.37, -18.58)
    ..lineTo(99.62, -8.72)
    ..lineTo(103.0, -0.0);
}

Path createPath2() {
  return Path()
    ..moveTo(102.0, 0.0)
    ..lineTo(104.6, 9.15)
    ..lineTo(98.48, 17.36)
    ..lineTo(100.46, 26.92)
    ..lineTo(94.91, 34.54)
    ..lineTo(92.44, 43.11)
    ..lineTo(87.47, 50.5)
    ..lineTo(87.65, 61.37)
    ..lineTo(81.2, 68.14)
    ..lineTo(73.54, 73.54)
    ..lineTo(64.28, 76.6)
    ..lineTo(60.8, 86.83)
    ..lineTo(53.5, 92.66)
    ..lineTo(43.95, 94.26)
    ..lineTo(35.57, 97.73)
    ..lineTo(25.88, 96.59)
    ..lineTo(17.71, 100.45)
    ..lineTo(9.06, 103.6)
    ..lineTo(0.0, 105.0)
    ..lineTo(-9.06, 103.6)
    ..lineTo(-17.36, 98.48)
    ..lineTo(-26.4, 98.52)
    ..lineTo(-35.23, 96.79)
    ..lineTo(-45.22, 96.97)
    ..lineTo(-50.5, 87.47)
    ..lineTo(-60.23, 86.01)
    ..lineTo(-64.92, 77.37)
    ..lineTo(-75.66, 75.66)
    ..lineTo(-79.67, 66.85)
    ..lineTo(-83.55, 58.5)
    ..lineTo(-90.93, 52.5)
    ..lineTo(-90.63, 42.26)
    ..lineTo(-98.67, 35.91)
    ..lineTo(-97.56, 26.14)
    ..lineTo(-104.39, 18.41)
    ..lineTo(-101.61, 8.89)
    ..lineTo(-109.0, 0.0)
    ..lineTo(-108.59, -9.5)
    ..lineTo(-99.47, -17.54)
    ..lineTo(-101.42, -27.18)
    ..lineTo(-102.43, -37.28)
    ..lineTo(-96.07, -44.8)
    ..lineTo(-91.8, -53.0)
    ..lineTo(-81.92, -57.36)
    ..lineTo(-79.67, -66.85)
    ..lineTo(-71.42, -71.42)
    ..lineTo(-66.21, -78.9)
    ..lineTo(-59.65, -85.19)
    ..lineTo(-53.0, -91.8)
    ..lineTo(-42.68, -91.54)
    ..lineTo(-34.54, -94.91)
    ..lineTo(-26.14, -97.56)
    ..lineTo(-18.23, -103.4)
    ..lineTo(-9.24, -105.6)
    ..lineTo(-0.0, -102.0)
    ..lineTo(8.72, -99.62)
    ..lineTo(17.89, -101.44)
    ..lineTo(27.95, -104.32)
    ..lineTo(36.25, -99.61)
    ..lineTo(42.26, -90.63)
    ..lineTo(51.5, -89.2)
    ..lineTo(57.93, -82.73)
    ..lineTo(68.14, -81.2)
    ..lineTo(76.37, -76.37)
    ..lineTo(79.67, -66.85)
    ..lineTo(82.73, -57.93)
    ..lineTo(90.93, -52.5)
    ..lineTo(97.88, -45.64)
    ..lineTo(93.97, -34.2)
    ..lineTo(97.56, -26.14)
    ..lineTo(100.45, -17.71)
    ..lineTo(100.62, -8.8)
    ..lineTo(100.0, -0.0);
}
