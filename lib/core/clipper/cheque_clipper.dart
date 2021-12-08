import 'package:flutter/material.dart';

class ChequeClipper extends CustomClipper<Path> {



  ChequeClipper();



  @override
  Path getClip(Size size) {
    

    double upperHalf = 187;

    Path subtractPath = Path();
    subtractPath
    ..addOval(Rect.fromCircle(center: Offset(0, upperHalf), radius: 18))
    ..addOval(Rect.fromCircle(center: Offset(size.width, upperHalf), radius: 18));



    return Path.combine(PathOperation.difference, Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)), subtractPath);
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}