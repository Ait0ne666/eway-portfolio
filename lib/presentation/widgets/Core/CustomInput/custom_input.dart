import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validators/validators.dart' as Validators;

enum CustomInputTypes { EMAIL, TEXT, PHONE }

class CustomInput extends StatefulWidget {
  final CustomInputTypes type;
  final String? label;
  final TextEditingController controller;
  final MaskTextInputFormatter? maskFormatter;
  final bool? required;
  final String? error;
  final Function? resetError;
  final Key? key;
  final bool? autofocus;
  final Widget? postfix;
  final String? placeholder;
  final bool? password;
  final bool? isCentered;

  const CustomInput(
      {this.label,
      required this.type,
      required this.controller,
      this.maskFormatter,
      this.required,
      this.error,
      this.key,
      this.autofocus,
      this.postfix,
      this.placeholder,
      this.resetError,
      this.password,
      this.isCentered})
      : super(key: key);

  @override
  CustomInputState createState() => CustomInputState();
}

class CustomInputState extends State<CustomInput> {
  String? error;
  final Key fadeInKey = UniqueKey();
  final Key fadeOutKey = UniqueKey();
  FocusNode focusNode = FocusNode();
  String filledString = '+7';
  String unfilledString = ' (000) 000-00-00';
  late String? mask;

  String? validator(String? text) {
    List<String? Function(String?)> validators = [];

    if (widget.required == true) {
      if (text == null || text.trim().isEmpty) {
        return 'Обязательное поле';
      }
    }

    if (widget.type == CustomInputTypes.EMAIL) {
      if (text == null ||
          (text.trim().isEmpty &&
              (widget.required == null || widget.required == false))) {
        return null;
      }
      if (!Validators.isEmail(text)) {
        return 'Введите корректный email';
      }
    }

    if (widget.type == CustomInputTypes.PHONE) {
      if (text == null ||
          (text.trim().isEmpty &&
              (widget.required == null || widget.required == false))) {
        return null;
      }
      if (text.length != 18) {
        return 'Введите корректный номер телефона';
      }
    }

    return null;
  }

  String? handleValidation() {
    String? newError = validator(widget.controller.text);
    if (newError != null) {
      setState(() {
        error = newError;
      });
    }
    return error;
  }

  void validateOnChange(String? text) {
    String? newError = validator(widget.controller.text);
    if (newError != null && newError != error) {
      setState(() {
        error = newError;
      });
    } else {
      if (newError == null && error != null) {
        setState(() {
          error = null;
        });
      }
    }
  }

  String getFilledString() {
    var mask = '+7 (000) 000-00-00';

    var currrentTextLength = widget.controller.value.text.length;

    return mask.substring(0, currrentTextLength);
  }

  String getUnFilledString() {
    var mask = '+7 (000) 000-00-00';

    var currrentTextLength = widget.controller.value.text.length;

    return mask.substring(currrentTextLength, mask.length);
  }

  @override
  void initState() {
    setState(() {
      error = widget.error;
    });
    super.initState();
    if (widget.type == CustomInputTypes.PHONE) {
      widget.controller.addListener(() {
        var filled = getFilledString();
        var unfilled = getUnFilledString();
        setState(() {
          filledString = filled;
          unfilledString = unfilled;
        });
      });
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error != oldWidget.error) {
      setState(() {
        error = widget.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.isCentered == true
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? Text(
                widget.label!,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              )
            : const SizedBox(),
        widget.label != null
            ? SizedBox(height: widget.isCentered == true ? 22 : 6)
            : const SizedBox(),
        Container(
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: Color(0xffE0E0EB),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Neumorphic(
            style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
                depth: -1,
                shadowDarkColorEmboss: Colors.white.withOpacity(0.6),
                shadowLightColorEmboss: Colors.white.withOpacity(0.6)),
            child: Container(
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xffEAEAF2),
                borderRadius: BorderRadius.circular(100),
              ),
              padding: widget.type == CustomInputTypes.EMAIL ?  const EdgeInsets.only(left:5, right: 20)  : const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  widget.type == CustomInputTypes.PHONE ? Container(
                    padding: EdgeInsets.only(left: 42),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: filledString,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFeatures: [
                                    FontFeature.tabularFigures()
                                  ],
                                  
                                  color: Colors.transparent,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'URWGeometricExt',
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: unfilledString,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xffB6B8C2),
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'URWGeometricExt',
                                  
                                  fontFeatures: [
                                    FontFeature.tabularFigures()
                                  ],
                                  decoration: TextDecoration.none,
                                ),
                              )
                            ]))),
                      ],
                    ),
                  ) : const SizedBox(),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        widget.type == CustomInputTypes.PHONE
                            ? Image.asset('assets/flag.png', width: 26)
                            : const SizedBox(),
                                                    widget.type == CustomInputTypes.EMAIL
                            ? Image.asset('assets/email.png', width: 57)
                            : const SizedBox(),
                        SizedBox(
                          width: widget.type == CustomInputTypes.PHONE ? 15 : 0,
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: focusNode,
                            onChanged: (String? text) {
                              if (widget.resetError != null) {
                                widget.resetError!();
                              }
                              if (error != null) {
                                validateOnChange(text);
                              }
                            },
                            keyboardType: widget.type == CustomInputTypes.PHONE ? TextInputType.number: null,
                            autofocus: widget.autofocus ?? false,
                            autocorrect: false,
                            controller: widget.controller,
                            inputFormatters: widget.maskFormatter != null
                                ? [widget.maskFormatter!]
                                : [],
                            textAlign: widget.isCentered == true
                                ? TextAlign.center
                                : TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                color: const Color(0xff1A1D21),
                                fontWeight: FontWeight.normal,
                                fontFamily: 'URWGeometricExt',
                                decoration: TextDecoration.none,
                                fontFeatures:
                                    widget.type == CustomInputTypes.PHONE
                                        ? [FontFeature.tabularFigures()]
                                        : []),
                            maxLines: 1,
                            obscureText:
                                widget.password != null && widget.password!
                                    ? true
                                    : false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.type == CustomInputTypes.PHONE
                                  ? ''
                                  : widget.placeholder,
                              hintStyle: Theme.of(context).textTheme.headline6,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),

                            cursorColor: const Color(0xff1A1D21),
                          ),
                        ),
                        widget.postfix ?? const SizedBox()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: error != null
                ? Column(
                    key: fadeInKey,
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        error!,
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    key: fadeOutKey,
                  ),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            }),
      ],
    );
  }
}
