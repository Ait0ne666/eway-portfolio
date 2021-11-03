import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Registration/registration.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          child: const Center(
            child: Center(
              child: Registration()
            ),
          ),
        ),
      );
  }
}