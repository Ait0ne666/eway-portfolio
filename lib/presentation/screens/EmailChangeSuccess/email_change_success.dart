import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';

class EmailChangeSuccessScreen extends StatelessWidget {
  const EmailChangeSuccessScreen({ Key? key }) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const  Color(0xffF0F1F6),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20 , vertical: MediaQuery.of(context).viewPadding.top + 30),
          child: Column(
            children:  [
              const CustomProfileBar(title: 'E-mail подтвержден', isCentered: true,),
              const SizedBox(height: 53,),
              Image.asset('assets/green-check.png', width: 152, height: 152,),
              Container(
                width: 236,
                child: Text('Ваша почта успешно привязана!', style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 20), textAlign: TextAlign.center, ))
            ],
          ),
        ),
      ),
    );
  }
}