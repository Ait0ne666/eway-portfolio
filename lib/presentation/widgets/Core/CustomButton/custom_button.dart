import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lseway/core/painter/inner_shadow.dart';

enum ButtonTypes { PRIMARY, SECONDARY, DARK }

class CustomButton extends StatelessWidget {
  final String text;
  final ButtonTypes type;
  final double? height;
  final double? width;
  final double? maxW;
  final Color? bgColor;
  final Widget? icon;
  final void Function() onPress;
  final bool? sharpAngle;
  final Widget? postfix;

  const CustomButton(
      {Key? key,
      required this.text,
      this.height,
      this.width,
      required this.onPress,
      this.type = ButtonTypes.PRIMARY,
      this.maxW,
      this.bgColor,
      this.icon,
      this.sharpAngle,
      this.postfix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      // borderRadius: BorderRadius.circular(100),
      borderRadius: sharpAngle == true
          ? BorderRadius.only(
              topLeft: Radius.circular(200),
              topRight: Radius.circular(100),
              bottomRight: Radius.circular(100))
          : BorderRadius.circular(100),
      child: Ink(
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(100),
            borderRadius: sharpAngle == true
                ? BorderRadius.only(
                    topLeft: Radius.circular(200),
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100))
                : BorderRadius.circular(100),
            gradient: type == ButtonTypes.PRIMARY
                ? const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xffE01E1D), Color(0xffF41D25)])
                : type == ButtonTypes.DARK
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xff2B2727), Color(0xff443F3F)],
                        stops: [0.7, 1])
                    : null,
            color: type == ButtonTypes.SECONDARY
                ? bgColor ?? const Color(0xffEDEDF3)
                : null,
            boxShadow: [
              BoxShadow(
                  color: type == ButtonTypes.PRIMARY
                      ? const Color.fromRGBO(226, 25, 32, 0.3)
                      : type == ButtonTypes.DARK
                          ? const Color.fromRGBO(70, 70, 70, 0.3)
                          : const Color.fromRGBO(247, 247, 247, 0.3),
                  blurRadius: 26,
                  offset: Offset(0, 8))
            ]),
        child: Neumorphic(
          style: NeumorphicStyle(
              depth: -5,
              shadowDarkColorEmboss: Colors.white.withOpacity(0.6),
              shadowLightColorEmboss: Colors.white.withOpacity(0.6),
              color: Colors.transparent,
              boxShape: NeumorphicBoxShape.roundRect(sharpAngle == true
                  ? BorderRadius.only(
                      topLeft: Radius.circular(200),
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(100))
                  : BorderRadius.circular(100))),
          child: Container(
            width: width != null ? width : double.infinity,
            height: height != null ? height : 58,
            constraints: maxW != null ? BoxConstraints(maxWidth: maxW!) : null,
            padding:
                postfix != null ? EdgeInsets.only(left: 30, right: 14) : null,
            child: Center(
                child: postfix != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            text,
                            style: type == ButtonTypes.PRIMARY ||
                                    type == ButtonTypes.DARK
                                ? Theme.of(context).textTheme.button
                                : Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(
                                        fontFamily: 'URWGeometricExt',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                          ),
                          postfix!
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          icon ?? const SizedBox(),
                          SizedBox(width: icon != null ? 8 : 0),
                          Text(
                            text,
                            style: type == ButtonTypes.PRIMARY ||
                                    type == ButtonTypes.DARK
                                ? Theme.of(context).textTheme.button
                                : Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(
                                        fontFamily: 'URWGeometricExt',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                          ),
                        ],
                      )),
          ),
        ),
      ),
    );
  }
}
