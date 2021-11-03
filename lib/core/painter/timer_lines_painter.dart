import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class TimerLinesPainter extends CustomPainter {



  @override
  void paint(Canvas canvas, Size size) {


    var lineNumber = 50;

    Paint paint  = Paint()
    ..color = Color.fromRGBO(236, 237, 241, 0.8)
    ..style  = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;


    Path path = Path();
    var segmentAngle = 2*pi / lineNumber; 
    for (var i = 0; i<lineNumber; i++) {
      path.moveTo(size.width/2, size.height/2);
      var dx = sin(segmentAngle*i)*size.height/2;
      var dy = cos(segmentAngle*i)*size.height/2;
      
      path.relativeLineTo(dx, dy);
    }
    
    Path circlePath = Path();
    circlePath.addOval(Rect.fromCenter(center: Offset(size.width/2, size.height/2), width: size.width-24, height: size.height-22));

    canvas.drawPath(path, paint);
    canvas.drawPath(circlePath, Paint()..color = Colors.white);
    
  }


  @override
  bool shouldRepaint(TimerLinesPainter oldDelegate) => false;

}