import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Auth/AuthScreenWrapper/auth_screen_wrapper.dart';
import 'package:lseway/presentation/widgets/Auth/AuthWithPhone/auth_with_phone.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AuthScreenWrapper(
      child: AuthWithPhone(),
    );
  }
}
