import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.state.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
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
    if (isValid != null && isValid) {
      var id = _controller.value.text;

      BlocProvider.of<PointInfoBloc>(context)
          .add(CheckIfPointExist(pointId: int.parse(id)));
    }
  }

  void pointInfoListener(BuildContext context, PointInfoState state) {
    var dialog = DialogBuilder();
    var isVisible = TickerMode.of(context);

    if (state is PointInfoExistLoadingState && isVisible) {
      dialog.showLoadingDialog(
        context,
      );
    } else if (state is PointInfoExistErrorState && isVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      Toast.showToast(context, 'Неверный код');
    } else if (state is PointInfoExistState && isVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context, rootNavigator: true).popUntil((route) {
        print(route.settings.name);

        return route.settings.name == '/main';
      });
      BlocProvider.of<PointInfoBloc>(context)
          .add(ShowPoint(pointId: state.pointId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BlocListener<PointInfoBloc, PointInfoState>(
            listener: pointInfoListener,
            child: const SizedBox(),
          ),
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
            child: SingleChildScrollView(
              child: Container(
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
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
                              color: Color(0xff1A1D21),
                              letterSpacing: 5
                            ),
                            textAlign: TextAlign.center,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'Обязательное поле'),
                              FormBuilderValidators.numeric(context,
                                  errorText: 'Код содержит только цифры')
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
          ),
        ],
      ),
    );
  }
}
