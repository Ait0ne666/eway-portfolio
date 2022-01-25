import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';
import 'package:lseway/presentation/bloc/charge/charge.state.dart';
import 'package:lseway/presentation/bloc/history/history.bloc.dart';
import 'package:lseway/presentation/bloc/history/history.event.dart';
import 'package:lseway/presentation/bloc/points/points.bloc.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/global.dart';

void showPreparationDialog(int pointId, Function charge) {
  var context = NavigationService.navigatorKey.currentContext;

  if (context != null) {
    Future(
      () => showGeneralDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: true,
          barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
          pageBuilder: (context, anim1, anim2) {
            return SimpleDialog(
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              insetPadding: const EdgeInsets.all(20),
              contentPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 2,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 500,
                  ),
                  child: PreparationDialogBody(
                    context: context,
                    pointId: pointId,
                    charge: charge,
                  ),
                )
              ],
            );
          },
          barrierLabel: '',
          transitionBuilder: (context, anim1, anim2, child) {
            return Transform.translate(
                offset: Offset(
                    0, (1 - anim1.value) * MediaQuery.of(context).size.height),
                child: SimpleDialog(
                  backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                  insetPadding: const EdgeInsets.all(20),
                  contentPadding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 2,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 500,
                      ),
                      child: PreparationDialogBody(
                        context: context,
                        pointId: pointId,
                        charge: charge,
                      ),
                    )
                  ],
                ));
          },
          transitionDuration: Duration(milliseconds: 300)

          ),
    );
  }
}

class PreparationDialogBody extends StatelessWidget {
  final int pointId;
  final Function charge;

  PreparationDialogBody(
      {Key? key,
      required this.context,
      required this.charge,
      required this.pointId})
      : super(key: key);

  final BuildContext? context;

  void chargeListener(BuildContext context, ChargeState state) {
    var dialog = DialogBuilder();
    var isVisible = TickerMode.of(context);
    print(state.progress?.status);
    if ((state is ChargeStartedState || state is ChargeInProgressState) &&
        state.progress?.pointId == pointId &&
        state.progress?.status == ChargeStatus.CHARGING) {
      Navigator.of(context, rootNavigator: true)
          .popUntil((route) => route.settings.name == '/main');
      var globalCtx = NavigationService.navigatorKey.currentContext;
      if (globalCtx != null) {
        charge(context, false);
      }
    } else if (state is ChargeEndedRemotelyState || state is ChargeEndedState) {
      Navigator.of(context, rootNavigator: true)
          .popUntil((route) => route.settings.name == '/main');
      BlocProvider.of<HistoryBloc>(context).add(FetchHistory());
    } else if (state is ChargeErrorState) {
      Navigator.of(context, rootNavigator: true).pop();
      Toast.showToast(context, state.message);
    } else if (state is ChargeStoppingState) {
      if (isVisible) {
        dialog.showLoadingDialog(
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChargeBloc, ChargeState>(
      listener: chargeListener,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/preparing.png'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Text(
                      'Подготовка к зарядке',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: Text(
                      'Подключите машину к зарядной станции',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: CustomButton(
                      text: 'Прервать',
                      onPress: () {
                        BlocProvider.of<ChargeBloc>(context).add(
                          StopCharge(pointId: pointId),
                        );
                      },
                      sharpAngle: true,
                      postfix: SvgPicture.asset('assets/chevron-red.svg'),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
