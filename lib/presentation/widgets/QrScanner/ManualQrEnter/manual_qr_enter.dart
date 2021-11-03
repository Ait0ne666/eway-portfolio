import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/IconButton/icon_button.dart';

class ManualQrEnter extends StatefulWidget {
  const ManualQrEnter({Key? key}) : super(key: key);

  @override
  _ManualQrEnterState createState() => _ManualQrEnterState();
}

class _ManualQrEnterState extends State<ManualQrEnter> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void submit() {
    var isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: Stack(
          children: [
            Image.asset(
              'assets/qrbg.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: const Color.fromRGBO(34, 35, 40, 0.7),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30 + MediaQuery.of(context).viewPadding.top),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomIconButton(
                                icon: SvgPicture.asset('assets/arrow.svg'),
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 75,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Введите код, который указан на зарядной станции',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _controller,
                            autofocus: false,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'URWGeometricExt',
                              fontSize: 22,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'Обязательное поле'),
                            ]),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffEAEAF2),
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        CustomButton(text: 'Готово', onPress: submit)
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
