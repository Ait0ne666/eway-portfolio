import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'dart:math' as math;

class QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    paint.color = Color(0xff91dd8f);

    Paint gradientPaint = Paint()
      ..shader = ui.Gradient.radial(Offset(0, 0), size.height*0.2,
          [Colors.white, Colors.white.withOpacity(0)])
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(0, size.height * 0.20)
      ..lineTo(0, size.height * 0.10)
      ..arcToPoint(Offset(size.height * 0.10, 0), radius: Radius.circular(35))
      ..lineTo(size.height * 0.2, 0)
      ..moveTo(size.width - size.height*0.2, 0)
      ..lineTo(size.width - size.height*0.1, 0)
      ..arcToPoint(Offset(size.width, size.height*0.1), radius: Radius.circular(35))
      ..lineTo(size.width, size.height*0.2)
            ..moveTo(size.width, size.height*0.8)
      ..lineTo(size.width, size.height*0.9)
      ..arcToPoint(Offset(size.width - size.height*0.1, size.height), radius: Radius.circular(35))
      ..lineTo(size.width -size.height*0.2, size.height)
            ..moveTo(size.height*0.2, size.height)
      ..lineTo(size.height*0.1, size.height)
      ..arcToPoint(Offset(0, size.height*0.9), radius: Radius.circular(35))
      ..lineTo(0, size.height*0.8);

    canvas.drawPath(path, paint);
    // canvas.drawPath(path, gradientPaint);
  }

  @override
  bool shouldRepaint(QrPainter oldDelegate) => false;
}
