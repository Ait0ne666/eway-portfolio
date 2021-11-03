import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lseway/core/snackbarBuilder/snackbarBuilder.dart';
import 'package:lseway/presentation/widgets/global.dart';

class SendAgainButton extends StatefulWidget {
  final void Function() onSend;
  final String sendText;
  final int? time;

  const SendAgainButton(
      {Key? key, required this.onSend, required this.sendText, this.time})
      : super(key: key);

  @override
  _SendAgainButtonState createState() => _SendAgainButtonState();
}

class _SendAgainButtonState extends State<SendAgainButton> {
  late int timeLeft;
  Timer? timer;

  @override
  void initState() {
    timeLeft = widget.time ?? 15;
    super.initState();

    setupTimer();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  void setupTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft = timeLeft - 1;
        }else {
          t.cancel();
        }
      });
    });
  }



  void handleSend() {
    if (timeLeft == 0) {
      widget.onSend();
      setState(() {
        timeLeft = widget.time ?? 15;
      });
      var globalContext = NavigationService.navigatorKey.currentContext;
      setupTimer();
      if (globalContext != null) {
        SnackBar snackBar = SnackbarBuilder.successSnackBar(
            text: widget.sendText, context: globalContext);

        ScaffoldMessenger.of(globalContext).showSnackBar(snackBar);
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: handleSend,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
            color: const Color(0xffE7E7F2),
            borderRadius: BorderRadius.circular(100)),
        child: Neumorphic(
          style: NeumorphicStyle(
            color: Colors.transparent,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
            depth: -2,
            shadowDarkColorEmboss: Colors.white.withOpacity(0.6),
            shadowLightColorEmboss: Colors.white.withOpacity(0.6),
          ),
          child: Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Отправить повторно',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  
                  timeLeft> 0 ? Text(
                    '($timeLeft сек)',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 16, color: const Color(0xffB0B3BD)),
                  ) : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
