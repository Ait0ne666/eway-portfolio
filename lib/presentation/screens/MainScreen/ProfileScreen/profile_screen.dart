import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';
import 'package:lseway/presentation/widgets/Profile/profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const  Color(0xffF0F1F6),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20 , vertical: MediaQuery.of(context).viewPadding.top + 30),
          child: Column(
            children: const [
              CustomProfileBar(title: 'Профиль', isCentered: true,),
              SizedBox(height: 44,),
              Profile()
            ],
          ),
        ),
      ),
    );
  }
}