import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({Key? key}) : super(key: key);

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: MediaQuery.of(context).size.height * 7 / 9 + MediaQuery.of(context).viewInsets.bottom,
      padding: EdgeInsets.only(bottom: 22 + MediaQuery.of(context).viewInsets.bottom, top: 22),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffECEDF2)),
            width: 34,
            height: 4,
          ),
          const SizedBox(height: 46),
          Text(
            'Добавить карту',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            height: 45,
          ),
          const CardForm()
        ],
      ),
    );
  }
}

class CardForm extends StatefulWidget {
  const CardForm({Key? key}) : super(key: key);

  @override
  _CardFormState createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  FocusNode cardFocusNode = FocusNode();
  FocusNode monthFocusNode = FocusNode();
  FocusNode yearFocusNode = FocusNode();
  FocusNode codeFocusNode = FocusNode();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String filledCard = '';
  String unfilledCard = 'XXXX - XXXX - XXXX - XXXX';

  final MaskTextInputFormatter _cardFormatter = MaskTextInputFormatter(
      mask: '#### - #### - #### - ####', filter: {"#": RegExp(r'[0-9]')});

  final TextInputFormatter _monthFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  bool cardError = false;
  bool dateError = false;
  bool codeError = false;

  @override
  void initState() {
    _cardController.addListener(() {
      var filled = getFilledString();
      var unfilled = getUnFilledString();
      setState(() {
        filledCard = filled;
        unfilledCard = unfilled;
      });
      if (_cardController.value.text.length == 25 && _cardController.selection.end == 25) {
        print(_cardController.selection.end);
        monthFocusNode.requestFocus();
      }
    });

    _monthController.addListener(() {
      if (_monthController.value.text.length == 2 && _monthController.selection.end == 2) {
        yearFocusNode.requestFocus();
      }
    });

    _yearController.addListener(() {
      if (_yearController.value.text.length == 2 && _yearController.selection.end == 2) {
        codeFocusNode.requestFocus();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _cardController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String getFilledString() {
    var mask = 'XXXX - XXXX - XXXX - XXXX';

    var currrentTextLength = _cardController.value.text.length;

    return mask.substring(0, currrentTextLength);
  }

  String getUnFilledString() {
    var mask = 'XXXX - XXXX - XXXX - XXXX';

    var currrentTextLength = _cardController.value.text.length;

    return mask.substring(currrentTextLength, mask.length);
  }

  bool validateForm() {
    var month = _monthController.value.text;
    var year = _yearController.value.text;
    var code = _codeController.value.text;
    var card = _cardFormatter.getUnmaskedText();

    var dateErr = validateMonth(month) || validateYear(year);

    var codeErr = validateCode(code);

    var cardErr = validateCard(card);

    setState(() {
      cardError = cardErr;
      codeError = codeErr;
      dateError = dateErr;
    });

    return dateErr || codeErr || cardErr;
  }

  bool validateMonth(String month) {
    if (month.length < 2) {
      return true;
    }
    var firstSymbol = int.parse(month[0]);
    var secondSymbol = int.parse(month[0]);

    if (firstSymbol > 2) {
      return true;
    }

    if (firstSymbol == 1 && secondSymbol > 2) {
      return true;
    }
    return false;
  }

  bool validateYear(String year) {
    if (year.length < 2) {
      return true;
    }

    return false;
  }

  bool validateCode(String code) {
    if (code.length < 3) {
      return true;
    }

    return false;
  }

  bool validateCard(String card) {
    if (card.length < 16) {
      return true;
    }

    return false;
  }

  void submit() {
    
    if (!validateForm()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Номер карты',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: cardError ?  Theme.of(context).colorScheme.error  : Color(0xffEAEAF2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Container(
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffEAEAF2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.only(right: 23),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 72,
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text.rich(TextSpan(children: [
                                      TextSpan(
                                        text: filledCard,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontFeatures: [
                                            FontFeature.tabularFigures()
                                          ],
                                          letterSpacing: 0.75,
                                          color: Colors.transparent,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Circe',
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      TextSpan(
                                        text: unfilledCard,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Color(0xffB6B8C2),
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Circe',
                                          letterSpacing: 0.75,
                                          fontFeatures: [
                                            FontFeature.tabularFigures()
                                          ],
                                          decoration: TextDecoration.none,
                                        ),
                                      )
                                    ]))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/circles.png',
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: TextFormField(
                                    focusNode: cardFocusNode,
                                    // keyboardType: widget.type == NeumorphInputTypes.PHONE ? TextInputType.number: null,
                                    autofocus: false,
                                    autocorrect: false,
                                    controller: _cardController,
                                    inputFormatters: [_cardFormatter],
                                    maxLength: 25,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff1A1D21),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Circe',
                                        decoration: TextDecoration.none,
                                        fontFeatures: [
                                          FontFeature.tabularFigures()
                                        ],
                                        height: 1),
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '',
                                      hintStyle:
                                          Theme.of(context).textTheme.headline6,
                                      counterText: '',
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.number,
                                    cursorColor: const Color(0xff1A1D21),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 28,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Срок действия',
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: dateError ?  Theme.of(context).colorScheme.error : Color(0xffEAEAF2),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Container(
                              height: 58,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xffEAEAF2),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              // padding: const EdgeInsets.symmetric(vertical: 13, ),
                              child: Container(
                                alignment: Alignment.center,
                                // color: Colors.red,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        focusNode: monthFocusNode,
                                        // keyboardType: widget.type == NeumorphInputTypes.PHONE ? TextInputType.number: null,
                                        autofocus: false,
                                        autocorrect: false,
                                        controller: _monthController,
                                        textAlign: TextAlign.center,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        inputFormatters: [_monthFormatter],
                                        maxLength: 2,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff1A1D21),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Circe',
                                            decoration: TextDecoration.none,
                                            fontFeatures: [
                                              FontFeature.tabularFigures()
                                            ],
                                            height: 1),
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                          counterText: '',
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.number,
                                        cursorColor: const Color(0xff1A1D21),
                                      ),
                                    ),
                                    Container(
                                      width: 1.5,
                                      color: Color(0xffD2D4DD),
                                      height: 32,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        focusNode: yearFocusNode,
                                        // keyboardType: widget.type == NeumorphInputTypes.PHONE ? TextInputType.number: null,
                                        autofocus: false,
                                        autocorrect: false,
                                        controller: _yearController,
                                        textAlign: TextAlign.center,
                                        inputFormatters: [_monthFormatter],
                                        maxLength: 2,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff1A1D21),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Circe',
                                            decoration: TextDecoration.none,
                                            fontFeatures: [
                                              FontFeature.tabularFigures()
                                            ],
                                            height: 1),
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                          counterText: '',
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.number,
                                        cursorColor: const Color(0xff1A1D21),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CCV-код',
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: codeError ?  Theme.of(context).colorScheme.error : Color(0xffEAEAF2),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Container(
                              height: 58,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xffEAEAF2),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              // padding: const EdgeInsets.symmetric(vertical: 13, ),
                              child: Container(
                                alignment: Alignment.center,
                                // color: Colors.red,
                                child: TextFormField(
                                  focusNode: codeFocusNode,
                                  // keyboardType: widget.type == NeumorphInputTypes.PHONE ? TextInputType.number: null,
                                  autofocus: false,
                                  autocorrect: false,
                                  controller: _codeController,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  inputFormatters: [_monthFormatter],
                                  maxLength: 3,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff1A1D21),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Circe',
                                      decoration: TextDecoration.none,
                                      fontFeatures: [
                                        FontFeature.tabularFigures()
                                      ],
                                      height: 1),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '',
                                    hintStyle:
                                        Theme.of(context).textTheme.headline6,
                                    counterText: '',
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.number,
                                  cursorColor: const Color(0xff1A1D21),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              CustomButton(
                text: 'Привязать карту',
                onPress: submit,
                icon: Image.asset(
                  'assets/card.png',
                  width: 40,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
