import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  void callSupport() async {
    String link = 'tel:' + Config.SUPPORT_PHONE;
    if (await canLaunch(link)) {
      launch(link);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF0F1F6),
      body: Container(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).viewPadding.top + 30),
        child: Column(
          children: [
            const CustomProfileBar(
              title: 'Служба поддержки',
              isCentered: true,
            ),
            const SizedBox(
              height: 77,
            ),
            // CustomButton(
            //   text: 'Чат с поддержкой',
            //   onPress: () {
            //     AppRouter.router.navigateTo(context, '/support/chat',
            //         transition: TransitionType.inFromLeft);
            //   },
            //   icon: Image.asset(
            //     'assets/chat.png',
            //     width: 39,
            //   ),
            // ),
            // const SizedBox(
            //   height: 23,
            // ),
            CustomButton(
              text: 'Позвонить в поддержку',
              onPress: callSupport,
              icon: Image.asset(
                'assets/phone.png',
                width: 39,
              ),
              type: ButtonTypes.DARK,
            )
          ],
        ),
      ),
    );
  }
}
