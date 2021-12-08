import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/widgets/Auth/AuthWithPhone/AuthWithPhoneForm/auth_with_phone_form.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthWithPhone extends StatelessWidget {
  const AuthWithPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            Text(
              'Вход',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(
              height: 46,
            ),
            const AuthWithPhoneForm(),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
            ),
            // InkWell(
            //   onTap: () {
            //     MainRouter.router.navigateTo(context, '/reset', transition: TransitionType.cupertino);
            //   },
            //   child: Container(
            //       padding: const EdgeInsets.only(bottom: 4),
            //       decoration: const BoxDecoration(
            //           border: Border(
            //               bottom:
            //                   BorderSide(width: 1, color: Color(0xff1A1D21)))),
            //       child: Text(
            //         'Восстановить доступ',
            //         style: Theme.of(context).textTheme.bodyText2?.copyWith(
            //               fontSize: 16,
            //             ),
            //       )),
            // ),
            // const SizedBox(
            //   height: 70,
            // ),
            Text.rich(
              TextSpan(children: [
                const TextSpan(
                  text: 'Регистрируясь, вы соглашаетесь с ',
                  style: TextStyle(
                      color: Color(0xffB1B3BD),
                      fontSize: 16,
                      fontFamily: 'Circe'),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      String link = Config.RULES_URL;
                      if (await canLaunch(link)) {
                        launch(link);
                      }
                    },
                  text: 'условиями',
                  style: const TextStyle(
                      color: Color(0xffB1B3BD),
                      fontSize: 16,
                      fontFamily: 'Circe',
                      decoration: TextDecoration.underline),
                ),
                const TextSpan(
                  text: ' использования и передачей данных',
                  style: TextStyle(
                    color: Color(0xffB1B3BD),
                    fontSize: 16,
                    fontFamily: 'Circe',
                  ),
                ),
              ]),
              textAlign: TextAlign.center,
            )
          ],
        )
      ]),
    );
  }
}
