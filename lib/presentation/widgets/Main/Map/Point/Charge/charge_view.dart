import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/core/snackbarBuilder/snackbarBuilder.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';
import 'package:lseway/presentation/bloc/charge/charge.state.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/Charge/amount_box.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/Charge/charge_80_dialog.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/Charge/timer.dart';
import 'package:lseway/presentation/widgets/global.dart';

class ChargeView extends StatefulWidget {
  final int pointId;
  const ChargeView({Key? key, required this.pointId}) : super(key: key);

  @override
  State<ChargeView> createState() => _ChargeViewState();
}

class _ChargeViewState extends State<ChargeView> {
  void chargeListener(BuildContext context, ChargeState state) {
    if (state is ChargeErrorState) {

      Toast.showToast(context, state.message);

    } else if (state is ChargeEndedState) {
      
        Navigator.of(context, rootNavigator: true).pop();
      
      
    } else  if (state is ChargeInProgressState) {
      if (state.progress?.progress != null && (state.progress!.progress!  == 80)) {
        showCharge80Dialog(context, widget.pointId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargeBloc, ChargeState>(builder: (context, state) {
      return ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              // color: const Color.fromRGBO(38, 38, 50, 0.2),
              padding: const EdgeInsets.only(
                top: 135,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                    height: 669,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BlocListener<ChargeBloc, ChargeState>(
                              listener: chargeListener,
                              child: const SizedBox(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffECEDF2)),
                              width: 34,
                              height: 4,
                            ),
                            const SizedBox(
                              height: 36,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/bolt-dark.png', width: 13),
                                const SizedBox(width: 13),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    'Заряжаем...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(fontSize: 22, height: 1),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              'Осталось: 15:00:00',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 15,
                                    color: const Color(0xffB6B8C2),
                                  ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TimerView(
                              currentPercent: state.progress?.progress != null
                                  ? state.progress!.progress!
                                  : 0,
                              pointId: widget.pointId,
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AmountBox(
                                    amount: state.progress?.paymentAmount ?? 0,
                                    startTime: state.progress?.createdAt ?? DateTime.now()),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text: state.progress?.powerAmount
                                              .toInt()
                                              .toString() ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(
                                                  fontSize: 25, height: 1.05)),
                                      TextSpan(
                                          text: 'кВт',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xffB6B8C2)))
                                    ])),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/bolt-grey.svg'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text('Передаваемый заряд',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                    fontSize: 15,
                                                    color: const Color(
                                                        0xffB6B8C2)))
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 220),
                                child: CustomButton(
                                  text: 'Отключить',
                                  onPress: () {
                                    BlocProvider.of<ChargeBloc>(context).add(
                                      StopCharge(pointId: widget.pointId),
                                    );
                                  },
                                  sharpAngle: true,
                                  postfix: SvgPicture.asset(
                                      'assets/chevron-red.svg'),
                                ))
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ),
      );
    });
  }
}
