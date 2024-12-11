import 'package:flutter/material.dart';
import 'dart:math';

void main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => CustomPaint(
                painter: HousePainter(timeOfDayAnimation: _controller),
                willChange: true,
                child: Container(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HousePainter extends CustomPainter{
  static const _houseHeight = 275.0;
  static const _houseWidth = 250.0;
  static const _houseOnGroundOffset = 20.0;
  static const _groundHeight = 100.0;
  static const _doorHeight = _houseHeight * 0.5;
  static const _doorWidth = _houseWidth * 0.3;
  static const _doorHandleHeight = 5.0;
  static const _doorHandleWidth = 15.0;
  static const _windowRadius = 40.0;
  static const _windowRoofThickness = 10.0;
  static const _houseRoofHeight = 75.0;
  static const _houseRoofHorizontalOffset = 25.0;
  static const _houseRoofVerticalOffset = 10.0;

  static final ColorTween _skyTween = ColorTween(
    end: Colors.blue.shade300,
    begin: Colors.grey.shade700,
  );
  static final _windowTween = ColorTween(
    end: Colors.white,
    begin: Colors.yellow.shade600,
  ).chain(CurveTween(curve: Curves.easeInOutQuint));

  final Animation<double> timeOfDayAnimation;

  const HousePainter({
    required this.timeOfDayAnimation,
  }) : super(repaint: timeOfDayAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    _drawSky(canvas);
    _drawGround(canvas, size);
    _drawWalls(canvas, size);
    _drawDoor(canvas, size);
    _drawDoorHandle(canvas, size);
    _drawWindow(canvas, size);
    _drawWindowRoof(canvas, size);
    _drawHouseRoof(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void _drawSky(Canvas canvas) {
    canvas.drawPaint(Paint()
      ..color = _skyTween.evaluate(timeOfDayAnimation) ?? Colors.transparent);
  }

  void _drawGround(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = Colors.green.shade300
      ..strokeWidth = _groundHeight;

    final dY = size.height - painter.strokeWidth / 2;
    final startPoint = Offset(0, dY);
    final endPoint = Offset(size.width, dY);

    canvas.drawLine(
      startPoint,
      endPoint,
      painter,
    );
  }
  void _drawWalls(Canvas canvas, Size size) {
    final painter = Paint()

    ..color = Colors.brown;

    final horizontalCenter = size.width / 2;

    const halfOfHouseWidth = _houseWidth / 2;

    final housePositionOnGround = size.height - _groundHeight + _houseOnGroundOffset;

    final leftBottomCornerPoint = Offset(
      horizontalCenter - halfOfHouseWidth,
      housePositionOnGround,
    );

    final rightTopCornerPoint = Offset(
      horizontalCenter + halfOfHouseWidth,
      housePositionOnGround - _houseHeight,
    );

    final rect = Rect.fromPoints(
      leftBottomCornerPoint,
      rightTopCornerPoint,
    );

    canvas.drawRect(rect, painter);
  }

  void _drawDoor(Canvas canvas, Size size) {
    final painter = Paint()

         ..color = Colors.yellow;

    const radius = Radius.circular(16);

    final horizontalCenter = size.width / 2;
    const halfOfHouseWidth = _houseWidth / 2;

    final housePositionOnGround =
        size.height - _groundHeight + _houseOnGroundOffset;

    final doorBottomY = housePositionOnGround - 10;

    final doorLeftX = horizontalCenter - halfOfHouseWidth + 20;

    final leftBottomCornerPoint = Offset(
      doorLeftX,
      doorBottomY,
    );
    final rightTopCornerPoint = Offset(
      doorLeftX + _doorWidth,
      doorBottomY - _doorHeight,
    );
    final rect = Rect.fromPoints(
      leftBottomCornerPoint,
      rightTopCornerPoint,
    );

    final rrect = RRect.fromRectAndRadius(
      rect,
      radius,
    );
    canvas.drawRRect(rrect, painter);
  }

  void _drawDoorHandle(Canvas canvas, Size size) {
    final painter = Paint()

      ..color = Colors.black;

    final horizontalCenter = size.width / 2;

    const halfOfHouseWidth = _houseWidth / 2;

    final housePositionOnGround =
        size.height - _groundHeight + _houseOnGroundOffset;

    final doorBottomY = housePositionOnGround - 10;

    final doorLeftX = horizontalCenter - halfOfHouseWidth + 20;

    final leftBottomCornerPoint = Offset(
      doorLeftX,
      doorBottomY,
    );

    final rightTopCornerPoint = Offset(
      doorLeftX + _doorWidth,
      doorBottomY - _doorHeight,
    );

    final doorRect = Rect.fromPoints(
      leftBottomCornerPoint,
      rightTopCornerPoint,
    );

    final doorHandleCenter = doorRect.centerRight.translate(-15, 0);
    final doorHandleRect = Rect.fromCenter(
      center: doorHandleCenter,
      width: _doorHandleWidth,
      height: _doorHandleHeight,
    );

    canvas.drawOval(doorHandleRect, painter);
  }

  void _drawWindow(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = _windowTween.evaluate(timeOfDayAnimation) ?? Colors.transparent;

    final horizontalCenter = size.width / 2;

    const halfOfHouseWidth = _houseWidth / 2;

    final housePositionOnGround =
        size.height - _groundHeight + _houseOnGroundOffset;

    final windowCenterY = housePositionOnGround - _doorHeight * 0.7;

    final windowCenterX =
        horizontalCenter + halfOfHouseWidth - _windowRadius - 40;

    final windowCenter = Offset(windowCenterX, windowCenterY);

    canvas.drawCircle(
      windowCenter,
      _windowRadius,
      painter,
    );
  }

  void _drawWindowRoof(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = _windowRoofThickness;

    final horizontalCenter = size.width / 2;
    const halfOfHouseWidth = _houseWidth / 2;

    final housePositionOnGround =
        size.height - _groundHeight + _houseOnGroundOffset;

    final windowCenterY = housePositionOnGround - _doorHeight * 0.7;
    final windowCenterX =
        horizontalCenter + halfOfHouseWidth - _windowRadius - 40;

    final windowCenter = Offset(windowCenterX, windowCenterY);

    const rectSize = _windowRadius * 2 + _windowRoofThickness / 2;

    final rect = Rect.fromCenter(
      center: windowCenter,
      width: rectSize,
      height: rectSize,
    );

    canvas.drawArc(
      rect,
      pi * 7 / 6,
      pi * 4 / 6,
      false,
      painter,
    );
  }

  void _drawHouseRoof(Canvas canvas, Size size) {
    final painter = Paint()..color = Colors.red;
    final horizontalCenter = size.width / 2;
    const halfOfRoofWidth = _houseWidth / 2 + _houseRoofHorizontalOffset;

    final housePositionOnGround =
        size.height - _groundHeight + _houseOnGroundOffset;
    final roofBottomY =
        housePositionOnGround - _houseHeight + _houseRoofVerticalOffset;

    final roofLeftX = horizontalCenter - halfOfRoofWidth;
    final roofRightX = horizontalCenter + halfOfRoofWidth;
    final path = Path()

      ..moveTo(roofLeftX, roofBottomY)
      ..lineTo(
        horizontalCenter,
        housePositionOnGround - _houseHeight - _houseRoofHeight,
      )
      ..lineTo(roofRightX, roofBottomY)
      ..close();

    canvas.drawPath(path, painter);
  }
}
