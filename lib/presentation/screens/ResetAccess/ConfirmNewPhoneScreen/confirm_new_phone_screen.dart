import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Auth/AuthScreenWrapper/auth_screen_wrapper.dart';
import 'package:lseway/presentation/widgets/Auth/ResetAccess/ConfirmNewPhone/confirm_new_phone.dart';

class ConfirmNewPhoneScreen extends StatelessWidget {
  final String email;
  final String phone;
  const ConfirmNewPhoneScreen({ Key? key, required this.email, required this.phone }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(child: ConfirmNewPhone(email: email, phone: phone));
  }
}