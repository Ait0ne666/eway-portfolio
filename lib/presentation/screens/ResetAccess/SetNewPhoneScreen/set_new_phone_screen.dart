import 'package:flutter/material.dart';

import 'package:lseway/presentation/widgets/Auth/AuthScreenWrapper/auth_screen_wrapper.dart';
import 'package:lseway/presentation/widgets/Auth/ResetAccess/SetNewPhone/set_new_phone.dart';

class SetNewPhoneScreen extends StatelessWidget {
  final String email;
  const SetNewPhoneScreen({ Key? key, required this.email }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(child: SetNewPhone(email: email));
  }
}