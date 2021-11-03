import 'dart:ui';

import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final void Function() onTap;
  final double? diameter;
  final Widget icon;

  const CustomIconButton(
      {Key? key,
      required this.icon,
      required this.onTap,
      this.diameter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            width: diameter ?? 66,
            height: diameter ?? 66,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(33),
                color: const Color.fromRGBO(73, 73, 73, 0.05)),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffFDFDFD),
                  borderRadius: BorderRadius.circular(26)),
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}
