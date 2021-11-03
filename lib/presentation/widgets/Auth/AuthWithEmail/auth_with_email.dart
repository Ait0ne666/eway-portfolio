import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Auth/AuthWithEmail/AuthWithEmailForm/auth_with_email_form.dart';


class AuthWithEmail extends StatelessWidget {
  const AuthWithEmail({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const AuthWithEmailForm(),
    );
  }
}