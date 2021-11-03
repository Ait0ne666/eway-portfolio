import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/presentation/widgets/QrCodeViewer/qr_code_viewer.dart';
import 'package:lseway/presentation/widgets/QrScanner/ManualQrEnter/manual_qr_enter.dart';

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
            child: QrCodeViewer(openManual: openManualQrDialog,),
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
        })).then((value) {
          
        });
  }

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
