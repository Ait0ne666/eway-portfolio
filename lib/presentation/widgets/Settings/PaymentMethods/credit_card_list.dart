import 'package:cloudpayments/cloudpayments_apple_pay.dart';
import 'package:cloudpayments/cloudpayments_google_pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/widgets/Core/SuccessModal/success_modal.dart';
import 'package:lseway/presentation/widgets/global.dart';

void handleGooglePay(BuildContext context) async {
  final googlePay = CloudpaymentsGooglePay(GooglePayEnvironment.production);

  final isGooglePayAvailable = await googlePay.isGooglePayAvailable();

  if (!isGooglePayAvailable) {
    Toast.showToast(context, "Google Pay не доступен на Вашем устройстве");
    return;
  }

  try {
    final result = await googlePay.requestGooglePayPayment(
      price: '1',
      currencyCode: 'RUB',
      countryCode: 'RU',
      merchantName: 'cloudpayments',
      publicId: Config.CLOUD_PAYMENTS_ID,
    );

    if (result != null) {
      if (result.isSuccess) {
        final paymentToken = result.token;

        BlocProvider.of<PaymentBloc>(context).add(
            AddWalletPayment(cryptoToken: paymentToken!, type: 'Google Pay'));
        // onGoogleSuccess();
      }
    }
  } catch (err) {
    Toast.showToast(context, "Google Pay не доступен на Вашем устройстве");
  }
}


void handleApplePay(BuildContext context) async {
  final applePay = CloudpaymentsApplePay();

  final isApplePayAvailable = await applePay.isApplePayAvailable();

  if (!isApplePayAvailable) {
    Toast.showToast(context, "Apple Pay не доступен на Вашем устройстве");
    return;
  }

  try {
    final result = await applePay.requestApplePayPayment(
    merchantId: 'merchant.ru.eway',
    currencyCode: 'RUB',
    countryCode: 'RU',
    products: [
        {"name": "Тестовый платеж", "price": "10"},
    ],
);


    if (result != null) {
      if (result.isSuccess) {
        final paymentToken = result.token;

        // BlocProvider.of<PaymentBloc>(context).add(
        //     AddWalletPayment(cryptoToken: paymentToken!, type: 'Apple Pay'));
        // onGoogleSuccess();
      }
    }
  } catch (err) {
    Toast.showToast(context, "Apple Pay не доступен на Вашем устройстве");
  }
}

class CreditCardList extends StatefulWidget {
  final List<CreditCard> cards;

  const CreditCardList({Key? key, required this.cards}) : super(key: key);

  @override
  _CreditCardListState createState() => _CreditCardListState();
}

class _CreditCardListState extends State<CreditCardList> {
  // CreditCard? selectedCard;

  List<Widget> _buildCreditCardList() {
    List<Widget> result = [];

    widget.cards.asMap().forEach((index, card) {
      if (card.type == PaymentTypes.GOOGLE_PAY) {
        result.add(InkWell(
          onTap: () {
            if (card.id != '') {
              BlocProvider.of<PaymentBloc>(context)
                  .add(ChangeActiveCard(id: card.id));
            } else {
              handleGooglePay(context);
            }
          },
          child: SizedBox(
            height: 55,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/google.png',
                  width: 60,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Google Pay',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontSize: 22, height: 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 53,
                  height: 53,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: Colors.white,
                  ),
                  child: AnimatedSwitcher(
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: card.isActive
                        ? Image.asset('assets/check-large.png', width: 23)
                        : const SizedBox(),
                    duration: const Duration(milliseconds: 300),
                  ),
                )
              ],
            ),
          ),
        ));
      } else if (card.type == PaymentTypes.APPLE_PAY) {
        result.add(InkWell(
          onTap: () {
            if (card.id != '') {
              BlocProvider.of<PaymentBloc>(context)
                  .add(ChangeActiveCard(id: card.id));
            } else {
              handleApplePay(context);
            }
          },
          child: SizedBox(
            height: 55,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset('assets/apple.svg', width: 60),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Apple Pay',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontSize: 22, height: 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 53,
                  height: 53,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: Colors.white,
                  ),
                  child: AnimatedSwitcher(
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: card.isActive
                        ? Image.asset('assets/check-large.png', width: 23)
                        : const SizedBox(),
                    duration: const Duration(milliseconds: 300),
                  ),
                )
              ],
            ),
          ),
        ));
      } else {
        result.add(InkWell(
          onTap: () {
            BlocProvider.of<PaymentBloc>(context)
                .add(ChangeActiveCard(id: card.id));
          },
          child: SizedBox(
            height: 55,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/card-grey.png',
                  width: 28,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        card.mask,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontSize: 22, height: 1),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        card.month.padLeft(2, "0") +
                            '/' +
                            (card.year.length == 4
                                ? card.year.substring(2, 4)
                                : card.year),
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontSize: 16,
                            color: const Color(0xffADAFBB),
                            height: 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 53,
                  height: 53,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: Colors.white,
                  ),
                  child: AnimatedSwitcher(
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: card.isActive
                        ? Image.asset('assets/check-large.png', width: 23)
                        : const SizedBox(),
                    duration: const Duration(milliseconds: 300),
                  ),
                )
              ],
            ),
          ),
        ));
      }

      if (index < widget.cards.length - 1) {
        result.add(const Divider(
          height: 60,
          thickness: 1.6,
          color: Color(0xffE0E0EB),
        ));
      }
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.length == 0) {
      return Text(
        'У вас не привязан ни один способ оплаты',
        style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 17),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      children: _buildCreditCardList(),
    );
  }
}
