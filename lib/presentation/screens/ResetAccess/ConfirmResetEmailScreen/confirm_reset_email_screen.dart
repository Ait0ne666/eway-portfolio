import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Auth/AuthScreenWrapper/auth_screen_wrapper.dart';
import 'package:lseway/presentation/widgets/Auth/ResetAccess/ConfirmReset/confirm_reset.dart';

class ConfirmResetEmailScreen extends StatelessWidget {
  final String email;
  const ConfirmResetEmailScreen({ Key? key, required this.email }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(child: ConfirmReset(email: email));
  }
}