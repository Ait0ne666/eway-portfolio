import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Core/SuccessModal/success_modal.dart';
import 'package:lseway/presentation/widgets/global.dart';

void onGoogleSuccess() async {
  var globalContext = NavigationService.navigatorKey.currentContext;
  if (globalContext != null) {
    showSuccessModal(
        globalContext,
        Container(
            constraints: const BoxConstraints(maxWidth: 272),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/google.png',
                      width: 60,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Google Pay',
                      textAlign: TextAlign.center,
                      style: Theme.of(globalContext)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 28),
                    )
                  ],
                ),
                Text(
                  'успешно привязан',
                  textAlign: TextAlign.center,
                  style: Theme.of(globalContext)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 28),
                )
              ],
            )));
  }
}
