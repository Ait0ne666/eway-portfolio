import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class TimerPainter extends CustomPainter {
  final Animation<double> currentPercent;
  final double? stroke;
  final double? innerStroke;

  TimerPainter({required this.currentPercent, this.stroke, this.innerStroke}):super(repaint: currentPercent);


  @override
  void paint(Canvas canvas, Size size) {

    double strokeWidth = stroke ?? 20;
    final Rect rect = Offset.zero & size;
    final Rect innerRect = Offset(strokeWidth*0.05, strokeWidth*0.05) & Size(size.width-strokeWidth*0.2, size.height-strokeWidth*0.2);
    final shadowRect = Offset(0,12) & size;

    const LinearGradient gradient = LinearGradient(colors: [Color(0xff6BD15A), Color(0xff41C696)], begin: Alignment.topLeft, end: Alignment.bottomRight);

    var shader = Paint()..shader = gradient.createShader(rect);
    shader..maskFilter = MaskFilter.blur(BlurStyle.inner, 3);
    shader..style = PaintingStyle.stroke;
    shader.strokeWidth = strokeWidth;
    shader.strokeCap = StrokeCap.round;
    


    var shadowShader =    Paint()..color = Color.fromRGBO(83, 193, 81, 0.4)..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);
    shadowShader..style = PaintingStyle.stroke;
    shadowShader.strokeWidth = strokeWidth;
    shadowShader.strokeCap = StrokeCap.round;

    Path path = Path();
    Path pathInner = Path();
    Path shadowPath = Path();

    Paint innerPaint = Paint()..color = Color(0xffECEDF1)..style = PaintingStyle.stroke..strokeWidth = innerStroke ?? strokeWidth*0.7;


    path.addArc(rect, 0, 2*pi*currentPercent.value);
    shadowPath.addArc(shadowRect, 0, 2*pi*currentPercent.value);
    
    pathInner.addOval(rect);




    canvas.drawPath(pathInner, innerPaint);
    canvas.drawPath(shadowPath, shadowShader);
    canvas.drawPath(path, shader);
    // canvas.drawPath(shadowPath, shadowShader);
  }


  @override
  bool shouldRepaint(TimerPainter oldDelegate) => true;

}