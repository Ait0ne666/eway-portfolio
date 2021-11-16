import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/snackbarBuilder/snackbarBuilder.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Core/CustomInput/custom_input.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AuthWithPhoneForm extends StatefulWidget {
  const AuthWithPhoneForm({Key? key}) : super(key: key);

  @override
  _AuthWithPhoneFormState createState() => _AuthWithPhoneFormState();
}

class _AuthWithPhoneFormState extends State<AuthWithPhoneForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final formatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  final GlobalKey<CustomInputState> _phoneKey = GlobalKey<CustomInputState>();

  @override
  void initState() {
    super.initState();
    _phoneController.value = const TextEditingValue(text: '+7');

    _phoneController.addListener(() {
      if (_phoneController.value.text.length < 2) {
        _phoneController.value = const TextEditingValue(text: '+7');
        _phoneController.selection = TextSelection.collapsed(offset: 2);
      }
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  void dispose() {
    _phoneController.dispose();

    super.dispose();
  }

  void onSubmit() {
    var phoneError = _phoneKey.currentState?.handleValidation();
    if (phoneError == null) {
      var phone = '7' + formatter.getUnmaskedText();

      BlocProvider.of<UserBloc>(context)
          .add(RequestPhoneConfirmation(phone: phone));
    }
  }

  void authListener(BuildContext context, UserState state) {
    print(state);
    var dialog = DialogBuilder();
    var isVisible = TickerMode.of(context);

    if (state is UserLoadingState) {
      if (ModalRoute.of(context) != null &&
          ModalRoute.of(context)!.isCurrent &&
          isVisible) {
        dialog.showLoadingDialog(context);
      }
    } else if (state is UserConfirmationCodeSentErrorState) {
      if (ModalRoute.of(context) != null &&
          ModalRoute.of(context)!.isActive &&
          isVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        SnackBar snackBar = SnackbarBuilder.errorSnackBar(
            text: state.message, context: context);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else if (state is UserConfirmationCodeSentState) {
      if (ModalRoute.of(context) != null &&
          ModalRoute.of(context)!.isActive &&
          isVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        MainRouter.router.navigateTo(context, '/confirm',
            routeSettings: RouteSettings(
                arguments: ConfirmationParams(phone: state.phone)),
            transition: TransitionType.cupertino);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocListener<UserBloc, UserState>(
            listener: authListener,
            child: const SizedBox(),
          ),
          Container(
              child: Column(
            children: [
              CustomInput(
                type: CustomInputTypes.PHONE,
                placeholder: 'Телефон',
                controller: _phoneController,
                required: true,
                key: _phoneKey,
                maskFormatter: formatter,
                label: 'Ваш телефон',
              ),
              const SizedBox(height: 40),
              CustomButton(text: 'Войти', onPress: onSubmit)
            ],
          ))
        ],
      ),
    );
  }
}
