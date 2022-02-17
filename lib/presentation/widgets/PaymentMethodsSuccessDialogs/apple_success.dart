import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lseway/presentation/widgets/Core/SuccessModal/success_modal.dart';
import 'package:lseway/presentation/widgets/global.dart';

void onAppleSuccess() async {
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
                    SvgPicture.asset(
                      'assets/apple.svg',
                      width: 60,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Apple Pay',
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
