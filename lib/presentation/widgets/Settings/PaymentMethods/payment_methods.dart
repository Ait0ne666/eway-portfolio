
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.state.dart';
import 'package:lseway/presentation/widgets/Settings/PaymentMethods/credit_card_form.dart';
import 'package:lseway/presentation/widgets/Settings/PaymentMethods/credit_card_list.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}



var googleCard = CreditCard(mask: '', month: '', year: '', id: '', isActive: false, type: PaymentTypes.GOOGLE_PAY); 
var appleCard = CreditCard(mask: '', month: '', year: '', id: '', isActive: false, type: PaymentTypes.APPLE_PAY); 

class _PaymentMethodsState extends State<PaymentMethods> {

  @override
  void initState() {
    BlocProvider.of<PaymentBloc>(context).add(FetchCards());
    super.initState();
  }


  void showCreditCardForm() {
    showMaterialModalBottomSheet(
        context: context,
        barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
        backgroundColor: Colors.transparent,
        isDismissible: true,
        
        builder: (dialogContext) {
          return CreditCardForm(onSuccess: (){
            Navigator.of(context).pop();
          },);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<PaymentBloc, PaymentState>(builder: (context, state) {
              
              var currentType = Platform.isIOS ? PaymentTypes.APPLE_PAY : PaymentTypes.GOOGLE_PAY;

              var paymentSystemActivated = state.cards.where((card) => card.type == currentType).isNotEmpty;

              var cards = [...state.cards];

              if (!paymentSystemActivated) {
                // cards = [Platform.isAndroid ? googleCard : appleCard, ...cards];
                // cards.add(Platform.isAndroid ? googleCard : appleCard);
              }


              return CreditCardList(cards: cards,);
            }),
            const SizedBox(height: 77,),
            InkWell(
              onTap: showCreditCardForm,
              child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Color(0xff1A1D21),
                    width: 1.5,
                  ))),
                  child: Text(
                    'Добавить еще карту',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 16),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
