import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/core/clipper/qr_overlay_clipper.dart';
import 'package:lseway/core/painter/qr_painter.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/IconButton/icon_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
      if (scanData.code == 'test') {
        controller.stopCamera();
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
        double width = MediaQuery.of(context).size.width - 130;
        double height = 300;

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

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          ClipPath(
            clipper:
                InvertedClipper(clipSize: cutOffSize, clipOffset: cutOffOffset),
            child: Container(
              height: MediaQuery.of(context).size.height,
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
                      const Text(
                        'Сканирование...',
                        style: TextStyle(color: Colors.white, fontSize: 27),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomPaint(
                    painter: QrPainter(),
                    child: SizedBox(
                      key: containerKey,
                      width: MediaQuery.of(context).size.width - 128,
                      height: 300,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      'Наведите камеру на QR-код в верхней части зарядной станции, чтобы начать зарядку',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
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
              top: MediaQuery.of(context).viewPadding.top + 30,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 20),
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
    );
  }
}
