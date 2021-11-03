import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/snackbarBuilder/snackbarBuilder.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/widgets/Core/CustomInput/custom_input.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formatter = MaskTextInputFormatter(
      mask: '+# (###)###-##-##', filter: {"#": RegExp(r'[0-9]')});
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<CustomInputState> _nameKey = GlobalKey<CustomInputState>();
  final GlobalKey<CustomInputState> _passwordKey =
      GlobalKey<CustomInputState>();
  final GlobalKey<CustomInputState> _emailKey = GlobalKey<CustomInputState>();
  final GlobalKey<CustomInputState> _surnameKey = GlobalKey<CustomInputState>();
  final GlobalKey<CustomInputState> _phoneKey = GlobalKey<CustomInputState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _surnameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  void onSubmit() {
    var nameError = _nameKey.currentState?.handleValidation();
    var emailError = _emailKey.currentState?.handleValidation();
    var surnameError = _surnameKey.currentState?.handleValidation();
    var passwordError = _passwordKey.currentState?.handleValidation();
    var phoneError = _phoneKey.currentState?.handleValidation();
    if (nameError == null &&
        emailError == null &&
        surnameError == null &&
        phoneError == null &&
        passwordError == null) {
      var name = _nameController.value.text;
      var email = _emailController.value.text;
      var surname = _surnameController.value.text;
      var password = _passwordController.value.text;
      var phone = formatter.getUnmaskedText();

      BlocProvider.of<UserBloc>(context).add(RegisterUser(
          name: name,
          email: email,
          surname: surname,
          password: password,
          phone: phone));
    }
  }

  void authListener(BuildContext context, UserState state) {
    print(state);
    var dialog = DialogBuilder();

    if (state is UserLoadingState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isCurrent) {
        dialog.showLoadingDialog(context);
      }
    } else if (state is UserRegisterErrorState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isActive) {
        Navigator.of(context, rootNavigator: true).pop();
        SnackBar snackBar = SnackbarBuilder.errorSnackBar(
            text: state.message, context: context);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else if (state is UserRegisterSuccess) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isActive) {
        Navigator.of(context, rootNavigator: true).pop();
        SnackBar snackBar =
            SnackbarBuilder.successSnackBar(text: 'Success', context: context);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              const Text(
                'Введите номер',
              ),
              const SizedBox(height: 7),
              FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.fitWidth,
                  child: Text('На него будет отправлен код подтверждения',
                      style: Theme.of(context).textTheme.bodyText1)),
            ],
          )),
          const SizedBox(height: 39),
          Form(
              key: _key,
              child: Column(
                children: [
                  CustomInput(
                    type: CustomInputTypes.TEXT,
                    placeholder: 'Имя',
                    controller: _nameController,
                    required: true,
                    key: _nameKey,
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    type: CustomInputTypes.TEXT,
                    placeholder: 'Фамилия',
                    controller: _surnameController,
                    required: true,
                    key: _surnameKey,
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                      type: CustomInputTypes.EMAIL,
                      placeholder: 'Email',
                      controller: _emailController,
                      // required: true,
                      key: _emailKey),
                  const SizedBox(height: 20),
                  CustomInput(
                      type: CustomInputTypes.PHONE,
                      placeholder: 'Телефон',
                      controller: _phoneController,
                      // required: true,
                      maskFormatter: formatter,
                      key: _phoneKey),
                  const SizedBox(height: 20),
                  CustomInput(
                    type: CustomInputTypes.TEXT,
                    placeholder: 'Пароль',
                    controller: _passwordController,
                    // required: true,
                    key: _passwordKey,
                    password: true,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    child: const Text('enter'),
                    onPressed: () {
                      onSubmit();
                    },
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
