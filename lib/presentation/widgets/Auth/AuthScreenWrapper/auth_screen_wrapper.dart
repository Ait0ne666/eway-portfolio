import 'dart:math';

import 'package:flutter/material.dart';

class AuthScreenWrapper extends StatelessWidget {
  final Widget child;

  const AuthScreenWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              'assets/auth-bg.png',
              height: max(MediaQuery.of(context).size.height * 0.36, 250),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: max(
                700,
                MediaQuery.of(context).size.height,
              ),
              maxHeight: max(
                700,
                MediaQuery.of(context).size.height,
              )
              ),
              child: Container(
                padding: EdgeInsets.only(
                    top: max(MediaQuery.of(context).size.height * 0.30, 220)),
                child: Container(
                  padding: const EdgeInsets.only(top: 54, bottom: 30),
                  decoration: const BoxDecoration(
                      color: Color(0xffF7F7FA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  child: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: child,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
