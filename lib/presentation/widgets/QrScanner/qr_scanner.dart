import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/widgets/Core/SuccessModal/success_modal.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/Charge/charge_view.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/NoPaymentMethodsDialog/no_payment_methods_dialog.dart';
import 'package:lseway/presentation/widgets/QrCodeViewer/qr_code_viewer.dart';
import 'package:lseway/presentation/widgets/QrScanner/ManualQrEnter/manual_qr_enter.dart';
import 'package:lseway/presentation/widgets/global.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class QRScanner extends StatelessWidget {
  final void Function() toggleMap;
  const QRScanner({Key? key, required this.toggleMap}) : super(key: key);

  void openQrDialog(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Future(() => showDialog(
        context: context,
        useRootNavigator: true,
        useSafeArea: false,
        builder: (dialogContext) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: QrCodeViewer(
              openManual: openManualQrDialog,
            ),
          );
        })).then((value) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
  }

  void openManualQrDialog(BuildContext context) {
    Navigator.of(context).pop();
    Future(() => showDialog(
        context: context,
        useRootNavigator: true,
        useSafeArea: false,
        builder: (dialogContext) {
          return const Dialog(
            insetPadding: EdgeInsets.zero,
            child: ManualQrEnter(),
          );
        })).then((value) {});
  }


  // void charge(BuildContext context, int pointId) {

  //   var cards = BlocProvider.of<PaymentBloc>(context).state.cards;

  //   if (cards.length > 0) {
  //     BlocProvider.of<ChargeBloc>(context).add(
  //         StartCharge(pointId: pointId, connector: connector));
  //   } else {
  //     Navigator.of(context).pop();
  //     showNoPaymentMethodsDialog(() => showSuccess(pointId));
  //   }
  // }

  // void showSuccess(int pointId) {
  //   var globalContext = NavigationService.navigatorKey.currentContext;

  //   if (globalContext != null) {
  //     Navigator.of(globalContext).pop();
  //     showSuccessModal(
  //         globalContext,
  //         Container(
  //             constraints: const BoxConstraints(maxWidth: 272),
  //             child: Text(
  //               'Карта успешно привязана',
  //               textAlign: TextAlign.center,
  //               style: Theme.of(globalContext)
  //                   .textTheme
  //                   .bodyText2
  //                   ?.copyWith(fontSize: 28),
  //             ))).then((value) {
  //       BlocProvider.of<PointInfoBloc>(globalContext).add(
  //         ShowPoint(pointId: pointId),
  //       );
  //     });
  //   }
  // }






  // void startCharge(int pointId) {
  //   var context = NavigationService.navigatorKey.currentContext;

  //   if (context != null) {
  //     showMaterialModalBottomSheet(
  //         context: context,
  //         barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
  //         backgroundColor: Colors.transparent,
  //         builder: (dialogContext) {
  //           return ChargeView(
  //             pointId: pointId,
  //           );
  //         }).then((value) {
  //       var globalContext = NavigationService.navigatorKey.currentContext;
  //       if (globalContext != null) {
  //         var currentPercent = BlocProvider.of<ChargeBloc>(globalContext)
  //             .state
  //             .progress
  //             ?.progress;
  //         if (currentPercent == 100) {
  //           BlocProvider.of<ChargeBloc>(globalContext)
  //               .add(StopChargeAutomatic(pointId: pointId));
  //         }
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openQrDialog(context),
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(42),
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xffE01E1D), Color(0xffF41D25)]),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(42),
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.5),
              ],
              center: AlignmentDirectional(0.0, 0.0),
              // focal: AlignmentDirectional(0.0, 0.0),
              // radius: 5,
              // focalRadius: 0.005,
              stops: [0.8, 1],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xffE01E1D), Color(0xffF41D25)]),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(42),
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.3),
                  ],
                  center: AlignmentDirectional(0.0, 0.0),
                  stops: [0.7, 1],
                ),
              ),
              child: Center(
                child: SvgPicture.asset('assets/QR.svg'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
