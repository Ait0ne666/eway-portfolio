import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';
import 'package:lseway/presentation/widgets/Settings/OrderHistory/order_history.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({ Key? key }) : super(key: key);

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
            const CustomProfileBar(title: 'История заказов', isCentered: true,),
            const SizedBox(
              height: 52,
            ),
            OrderHistory()
          ],
        ),
      ),
    );
  }
}