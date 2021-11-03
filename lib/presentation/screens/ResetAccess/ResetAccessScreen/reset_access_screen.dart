import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Auth/AuthScreenWrapper/auth_screen_wrapper.dart';
import 'package:lseway/presentation/widgets/Auth/ResetAccess/ResetAccess/reset_access.dart';

class ResetAccessScreen extends StatelessWidget {
  const ResetAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AuthScreenWrapper(child: ResetAccess());
  }
}
