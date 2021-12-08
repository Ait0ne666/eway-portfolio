import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/core/clipper/qr_overlay_clipper.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/painter/qr_painter.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.state.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/IconButton/icon_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sizer/sizer.dart';


class QrCodeViewer extends StatefulWidget {
  final void Function(BuildContext) openManual;
  const QrCodeViewer({Key? key, required this.openManual}) : super(key: key);

  @override
  _QrCodeViewerState createState() => _QrCodeViewerState();
}

class _QrCodeViewerState extends State<QrCodeViewer> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final GlobalKey containerKey = GlobalKey();
  Size? cutOffSize;
  Offset? cutOffOffset;
  bool scanning = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!scanning) {
        var code = scanData.code;
        var codeNumber = int.tryParse(code);
        if (codeNumber != null) {
          // controller.stopCamera();
          setState(() {
            scanning = true;
          });
          BlocProvider.of<PointInfoBloc>(context)
              .add(CheckIfPointExist(pointId: codeNumber));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      RenderBox? box =
          containerKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        Offset containerOffset = box.localToGlobal(Offset.zero);
        double width = math.max(MediaQuery.of(context).size.width - 140, 248);
        double height = 270;

        setState(() {
          cutOffOffset = containerOffset;
          cutOffSize = Size(width, height);
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void pointInfoListener(BuildContext context, PointInfoState state) {
    var dialog = DialogBuilder();
    var isVisible = TickerMode.of(context);

    if (state is PointInfoExistLoadingState && isVisible) {
      dialog.showLoadingDialog(
        context,
      );
    } else if (state is PointInfoExistErrorState && isVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      Toast.showToast(context, 'Неверный код');
      setState(() {
        scanning = false;
      });
    } else if (state is PointInfoExistState && isVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context, rootNavigator: true).popUntil((route) {
        print(route.settings.name);

        return route.settings.name == '/main';
      });
      BlocProvider.of<PointInfoBloc>(context)
          .add(ShowPoint(pointId: state.pointId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          maxHeight: math.max(700, MediaQuery.of(context).size.height),
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: Stack(
          children: [
            BlocListener<PointInfoBloc, PointInfoState>(
              listener: pointInfoListener,
              child: const SizedBox(),
            ),
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
            ClipPath(
              clipper:
                  InvertedClipper(clipSize: cutOffSize, clipOffset: cutOffOffset),
              child: Container(
                height: math.max(700, MediaQuery.of(context).size.height),
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(0, 0, 0, 0.7),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 90),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/QR.svg'),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Сканирование...',
                          style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width > 370 ?  22.sp : 20.sp),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    CustomPaint(
                      painter: QrPainter(),
                      child: SizedBox(
                        key: containerKey,
                        width: math.max(MediaQuery.of(context).size.width - 138, 250),
                        height:270,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        'Наведите камеру на QR-код в верхней части зарядной станции, чтобы начать зарядку',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width > 370 ? 14.sp : 12.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    CustomButton(
                      text: 'Ввести код вручную',
                      onPress: () {
                        widget.openManual(context);
                      },
                      type: ButtonTypes.SECONDARY,
                      maxW: 282,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).viewPadding.top + 3.h,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomIconButton(
                          icon: SvgPicture.asset('assets/arrow.svg'),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          }),
                      CustomIconButton(
                          icon: SvgPicture.asset('assets/flashlight.svg'),
                          onTap: () async {
                            controller?.toggleFlash();
                          }),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
