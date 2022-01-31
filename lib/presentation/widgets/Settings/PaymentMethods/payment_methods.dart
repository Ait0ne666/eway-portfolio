import 'dart:io';

import 'package:cloudpayments/cloudpayments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/domain/entitites/payment/threeDs.entity.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.state.dart';
import 'package:lseway/presentation/widgets/Core/SuccessModal/success_modal.dart';
import 'package:lseway/presentation/widgets/PaymentMethodsSuccessDialogs/google_success.dart';
import 'package:lseway/presentation/widgets/Settings/PaymentMethods/credit_card_form.dart';
import 'package:lseway/presentation/widgets/Settings/PaymentMethods/credit_card_list.dart';
import 'package:lseway/presentation/widgets/global.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';



  void handle3DS(BuildContext context, ThreeDS threeDs) async {
    try {
      var result = await Cloudpayments.show3ds(
          acsUrl: threeDs.acsUrl,
          transactionId: threeDs.transactionId,
          paReq: threeDs.paReq);
      if (result?.md != null && result?.paRes != null) {
        BlocProvider.of<PaymentBloc>(context)
            .add(ConfirmWallet3DS(md: result!.md!, paRes: result.paRes!));
      } else {
        Toast.showToast(context, 'Не удалось привязать карту');
      }
    } catch (err) {
      Toast.showToast(context, 'Не удалось привязать карту');
    }
  }




class PaymentMethods extends StatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

var googleCard = CreditCard(
    mask: '',
    month: '',
    year: '',
    id: '',
    isActive: false,
    type: PaymentTypes.GOOGLE_PAY);
var appleCard = CreditCard(
    mask: '',
    month: '',
    year: '',
    id: '',
    isActive: false,
    type: PaymentTypes.APPLE_PAY);

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
          return CreditCardForm(
            onSuccess: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  void paymentListener(BuildContext context, PaymentState state) {
    var dialog = DialogBuilder();
    var isVisible = TickerMode.of(context);
    if (isVisible) {
      if (state is WalletPaymentAddingState) {
        dialog.showLoadingDialog(
          context,
        );
      } else if (state is WalletPaymentAddErrorState) {
        Navigator.of(context, rootNavigator: true).pop();
        Toast.showToast(context, state.message);
      } else if (state is WalletPaymentAddedState) {
        Navigator.of(context, rootNavigator: true).pop();
        if (Platform.isIOS) {
        } else {
          onGoogleSuccess();
        }
      } else if (state is WalletPayment3DSState) {
        Navigator.of(context, rootNavigator: true).pop();
        handle3DS(context, state.threeDs);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer<PaymentBloc, PaymentState>(
                listener: paymentListener,
                builder: (context, state) {
                  var currentType = Platform.isIOS
                      ? PaymentTypes.APPLE_PAY
                      : PaymentTypes.GOOGLE_PAY;

                  var paymentSystemActivated = state.cards
                      .where((card) => card.type == currentType)
                      .isNotEmpty;

                  var cards = [...state.cards];

                  if (!paymentSystemActivated) {
                    cards = [
                      Platform.isAndroid ? googleCard : appleCard,
                      ...cards
                    ];
                  }

                  return CreditCardList(
                    cards: cards,
                  );
                }),
            const SizedBox(
              height: 77,
            ),
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
