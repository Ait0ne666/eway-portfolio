import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

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
            CustomButton(
              text: 'Чат с поддержкой',
              onPress: () {},
              icon: Image.asset(
                'assets/chat.png',
                width: 39,
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            CustomButton(
              text: 'Позвонить в поддержку',
              onPress: () {},
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
