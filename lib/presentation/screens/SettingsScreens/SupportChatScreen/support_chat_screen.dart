import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';
import 'package:lseway/presentation/widgets/Settings/Support/Chat/chat.dart';

class SupportChatScreen extends StatelessWidget {
  const SupportChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF0F1F6),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).viewPadding.top + 30),
          child: Column(
            children: const [
              CustomProfileBar(
                title: 'Чат поддержки',
                isCentered: true,
              ),
              SizedBox(
                height: 18,
              ),
              ChatWidget()
            ],
          ),
        ),
      ),
    );
  }
}
