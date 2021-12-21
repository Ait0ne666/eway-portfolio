import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class TimerLinesPainter extends CustomPainter {
  final int currentHighlight;


  TimerLinesPainter({required this.currentHighlight});

  @override
  void paint(Canvas canvas, Size size) {
    var lineNumber = 50;

    Paint paint = Paint()
      ..color = Color.fromRGBO(236, 237, 241, 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    Paint paint2 = Paint()
      ..color = Color(0xff4fc985)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    Path path2 = Path();
    var segmentAngle = 2 * pi / lineNumber;
    for (var i = 0; i < lineNumber; i++) {
      if (i == currentHighlight) {
        path2.moveTo(size.width / 2, size.height / 2);
        var dx = sin(segmentAngle * i) * (size.height / 2)*1.03;
        var dy = cos(segmentAngle * i) * (size.height / 2)*1.03;

        path2.relativeLineTo(dx, dy);
      }
      path.moveTo(size.width / 2, size.height / 2);
      var dx = sin(segmentAngle * i) * size.height / 2;
      var dy = cos(segmentAngle * i) * size.height / 2;

      path.relativeLineTo(dx, dy);
    }

    Path circlePath = Path();
    circlePath.addOval(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width - 24,
        height: size.height - 22));

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(circlePath, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(TimerLinesPainter oldDelegate) {
    return oldDelegate.currentHighlight != currentHighlight;
  }
}
