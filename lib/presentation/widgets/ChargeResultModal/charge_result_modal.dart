import 'package:cloudpayments/cloudpayments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lseway/core/clipper/cheque_clipper.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/domain/entitites/charge/charge_ended_result.dart';
import 'package:lseway/domain/entitites/payment/threeDs.entity.dart';
import 'package:lseway/presentation/bloc/history/history.bloc.dart';
import 'package:lseway/presentation/bloc/history/history.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.state.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/PaymentErrorModal/payment_error_modal.dart';
import 'package:sizer/sizer.dart';
import 'package:dotted_line/dotted_line.dart';

class ChargeResultModal extends StatefulWidget {
  final ChargeEndedResult result;
  const ChargeResultModal({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  State<ChargeResultModal> createState() => _ChargeResultModalState();
}

class _ChargeResultModalState extends State<ChargeResultModal> {
  void paymentListener(BuildContext context, PaymentState state) {
    var dialog = DialogBuilder();
    var isVisible = TickerMode.of(context);

    if (state is PaymentProcessingState) {
      dialog.showLoadingDialog(
        context,
      );
    } else if (state is PaymentErrorState) {
      Navigator.of(context, rootNavigator: true).pop();
      // Toast.showToast(context, state.message);
      showPaymentErrorodal(handlePayment);
    } else if (state is PaymentDoneState) {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context, rootNavigator: true).pop();
      BlocProvider.of<HistoryBloc>(context).add(FetchHistory());
    } else if (state is Payment3DSState) {
      Navigator.of(context, rootNavigator: true).pop();
      handle3DS(state.threeDs);
    }
  }

  void handle3DS(ThreeDS threeDs) async {
    try {
      var result = await Cloudpayments.show3ds(
          acsUrl: threeDs.acsUrl,
          transactionId: threeDs.transactionId,
          paReq: threeDs.paReq);
      if (result?.md != null && result?.paRes != null) {
        BlocProvider.of<PaymentBloc>(context)
            .add(Confirm3DSForPayment(md: result!.md!, paRes: result.paRes!));
      } else {
        Toast.showToast(context, 'Не удалось провести оплату');
      }
    } catch (err) {
      Toast.showToast(context, 'Не удалось провести оплату');
    }
  }

  void handlePayment() {
    if (widget.result.id != null) {
      BlocProvider.of<PaymentBloc>(context)
          .add(ConfirmPayment(confirmation: true, chargeId: widget.result.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    var mod = (widget.result.amount * 100) % 100;

    var formatCurrency = NumberFormat.currency(
        locale: 'ru_RU', symbol: '', decimalDigits: mod == 0 ? 0 : 2);
    return Center(
      child: ClipPath(
        clipper: ChequeClipper(),
        child: Container(
          height: 505,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 6.w,
          ),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(40)),
          child: Column(
            children: [
              BlocListener<PaymentBloc, PaymentState>(
                listener: paymentListener,
                child: const SizedBox(),
              ),
              Container(
                height: 186,
                padding: const EdgeInsets.only(top: 45),
                child: Column(
                  children: [
                    Text(
                      'Зарядка завершена',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 17),
                    ),
                    const SizedBox(
                      height: 19,
                    ),
                    Text(
                      'Итоговая сумма',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: 15, color: Color(0xffB6B8C2)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          colors: [
                            Color(0xff41C696),
                            Color(0xff6BD15A),
                          ],
                        ).createShader(rect);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatCurrency.format(widget.result.amount),
                            style: const TextStyle(
                                fontSize: 40,
                                fontFamily: 'URWGeometricExt',
                                height: 1,
                                color: Colors.white),
                          ),
                          Transform.translate(
                            offset: Offset(-3, 2),
                            child: const Text(
                              '₽',
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 1,
                                  fontFamily: 'Circe',
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const DottedLine(
                dashColor: Color(0xffD8DCE7),
                dashGapLength: 13,
                lineThickness: 2,
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.only(top: 42),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 58,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xffEDEDF3),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 8),
                                    blurRadius: 26,
                                    color: Color.fromRGBO(247, 247, 247, 0.3))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        width: 45,
                                        padding: EdgeInsets.only(right: 9),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: SvgPicture.asset(
                                              'assets/bolt-grey.svg'),
                                        )),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Передаваемый заряд',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                fontSize: 15,
                                                color: Color(0xffB6B8C2)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  Text(widget.result.voltage.toInt().toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(fontSize: 25, height: 1)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Container(
                                    width: 32,
                                    child: Text(
                                      'кВт',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                              fontSize: 16,
                                              color: Color(0xffB6B8C2)),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.infinity,
                          height: 58,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xffEDEDF3),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 8),
                                    blurRadius: 26,
                                    color: Color.fromRGBO(247, 247, 247, 0.3))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        width: 45,
                                        padding: EdgeInsets.only(right: 7),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: SvgPicture.asset(
                                              'assets/timer-grey-dark.svg'),
                                        )),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Время зарядки',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                fontSize: 15,
                                                color: Color(0xffB6B8C2)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  Text(widget.result.time.toInt().toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(fontSize: 25, height: 1)),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Container(
                                    width: 32,
                                    child: Text(
                                      'мин',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                              fontSize: 16,
                                              color: Color(0xffB6B8C2)),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 220),
                            child: CustomButton(
                              text: 'Оплатить',
                              onPress: handlePayment,
                              sharpAngle: true,
                              postfix:
                                  SvgPicture.asset('assets/chevron-red.svg'),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
