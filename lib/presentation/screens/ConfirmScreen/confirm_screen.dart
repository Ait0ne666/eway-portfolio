import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Auth/AuthScreenWrapper/auth_screen_wrapper.dart';
import 'package:lseway/presentation/widgets/Auth/Confirmation/confirmation.dart';



class ConfirmScreen extends StatefulWidget {
  final String phone;


  const ConfirmScreen({ Key? key, required this.phone }) : super(key: key);

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(child: Confirmation(phone: widget.phone));
  }
}


