import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/snackbarBuilder/snackbarBuilder.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/widgets/Core/CustomInput/custom_input.dart';

class AuthWithEmailForm extends StatefulWidget {
  const AuthWithEmailForm({Key? key}) : super(key: key);



  @override
  _AuthWithEmailFormState createState() => _AuthWithEmailFormState();
}

class _AuthWithEmailFormState extends State<AuthWithEmailForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<CustomInputState> _passwordKey =
      GlobalKey<CustomInputState>();
  final GlobalKey<CustomInputState> _emailKey = GlobalKey<CustomInputState>();

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  void onSubmit() {
    var emailError = _emailKey.currentState?.handleValidation();

    var passwordError = _passwordKey.currentState?.handleValidation();
    if (emailError == null && passwordError == null) {
      var email = _emailController.value.text;

      var password = _passwordController.value.text;

      BlocProvider.of<UserBloc>(context)
          .add(LoginUserWithEmail(email: email, password: password));
    }
  }

  void authListener(BuildContext context, UserState state) {
    
    var dialog = DialogBuilder();

    if (state is UserLoadingState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isCurrent) {
        dialog.showLoadingDialog(context);
      }
    } else if (state is UserLoginWithEmailErrorState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isActive) {
        Navigator.of(context, rootNavigator: true).pop();
        SnackBar snackBar = SnackbarBuilder.errorSnackBar(
            text: state.message, context: context);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else if (state is UserAuthorizedState) {
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isActive) {
        Navigator.of(context, rootNavigator: true).pop();
        MainRouter.router.navigateTo(context, '/main', clearStack: true, transition: TransitionType.cupertino);
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
                  type: CustomInputTypes.EMAIL,
                  placeholder: 'Email',
                  controller: _emailController,
                  required: true,
                  key: _emailKey),
              const SizedBox(height: 20),
              CustomInput(
                type: CustomInputTypes.TEXT,
                placeholder: 'Пароль',
                controller: _passwordController,
                required: true,
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
