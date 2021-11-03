import 'package:flutter/material.dart';

class InvertedClipper extends CustomClipper<Path> {

  Size? clipSize;
  Offset? clipOffset;

  InvertedClipper({this.clipSize , this.clipOffset});



  @override
  Path getClip(Size size) {
    var curSize =  clipSize ?? const Size(0,0);
    var curOffset = clipOffset ?? const Offset(0, 0);
    return Path()
    ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
    ..addRRect(RRect.fromLTRBR(clipOffset!.dx, clipOffset!.dy,  clipOffset!.dx + clipSize!.width, clipOffset!.dy + clipSize!.height, Radius.circular(30)))
    ..fillType = PathFillType.evenOdd;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}