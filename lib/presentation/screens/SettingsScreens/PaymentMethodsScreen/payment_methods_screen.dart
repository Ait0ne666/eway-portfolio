import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';
import 'package:lseway/presentation/widgets/Settings/PaymentMethods/payment_methods.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xffF0F1F6),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Container(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).viewPadding.top + 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CustomProfileBar(
                title: 'Способы оплаты',
                isCentered: true,
              ),
              SizedBox(
                height: 67,
              ),
              PaymentMethods()
            ],
          ),
        ),
      ),
    );
  }
}
