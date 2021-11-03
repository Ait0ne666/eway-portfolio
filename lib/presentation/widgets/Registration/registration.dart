import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Registration/RegistrationForm/registration_form.dart';

class Registration extends StatelessWidget {
  const Registration({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return Container(
      child: RegistrationForm(),
    );
  }
}