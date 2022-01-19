import 'package:cloudpayments/cloudpayments_google_pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/widgets/Core/SuccessModal/success_modal.dart';
import 'package:lseway/presentation/widgets/global.dart';

class CreditCardList extends StatefulWidget {
  final List<CreditCard> cards;

  const CreditCardList({Key? key, required this.cards}) : super(key: key);

  @override
  _CreditCardListState createState() => _CreditCardListState();
}

class _CreditCardListState extends State<CreditCardList> {
  // CreditCard? selectedCard;

  void handleGooglePay() async {
    final googlePay = CloudpaymentsGooglePay(GooglePayEnvironment.test);

    final result = await googlePay.requestGooglePayPayment(
      price: '1',
      currencyCode: 'RUB',
      countryCode: 'RU',
      merchantName: 'Cloudpayments',
      publicId: Config.CLOUD_PAYMENTS_ID,
    );

    if (result != null) {
      if (result.isSuccess) {
        final paymentToken = result.token;
        onGoogleSuccess();
      }
    }
  }

  void onGoogleSuccess() async {
    var globalContext = NavigationService.navigatorKey.currentContext;
    if (globalContext != null) {
      showSuccessModal(
          globalContext,
          Container(
              constraints: const BoxConstraints(maxWidth: 272),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/google.png',
                        width: 60,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Google Pay',
                        textAlign: TextAlign.center,
                        style: Theme.of(globalContext)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontSize: 28),
                      )
                    ],
                  ),
                  Text(
                    'успешно привязан',
                    textAlign: TextAlign.center,
                    style: Theme.of(globalContext)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 28),
                  )
                ],
              )));
    }
  }

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
              handleGooglePay();
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
