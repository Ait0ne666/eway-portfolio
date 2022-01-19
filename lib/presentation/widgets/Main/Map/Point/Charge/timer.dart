import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/core/painter/timer_lines_painter.dart';
import 'package:lseway/core/painter/timer_painter.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';

Timer? timer;

class TimerView extends StatefulWidget {
  final double currentPercent;
  final int pointId;
  final bool lowVoltage;
  final double? power;
  const TimerView(
      {Key? key,
      required this.currentPercent,
      required this.pointId,
      required this.lowVoltage,
      this.power})
      : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  var lines = 49;
  var currentLine = 25;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _controller.animateTo(widget.currentPercent / 100);
    animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    updateCurrentLine();
    super.initState();
  }

  void updateCurrentLine() {
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (currentLine - 1 >= 0) {
        setState(() {
          currentLine = currentLine - 1;
        });
      } else {
        currentLine = lines;
      }
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.currentPercent != oldWidget.currentPercent) {
      _controller.animateTo(widget.currentPercent / 100);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CustomPaint(
      painter: TimerLinesPainter(currentHighlight: currentLine),
      child: Container(
        padding: EdgeInsets.all(28),
        child: CustomPaint(
          painter: TimerPainter(currentPercent: animation),
          child: Container(
            // width: min(MediaQuery.of(context).size.width - 40 - 40, 220),
            // height: min(MediaQuery.of(context).size.width - 40 - 40, 220),
            width: 210,
            height: 210,
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: widget.power?.toStringAsFixed(2) ?? '0.00',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 25, height: 1.05)),
                  TextSpan(
                      text: ' кВт',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: 16, color: const Color(0xffB6B8C2)))
                ])),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/bolt-grey.svg'),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      // color: Colors.red,
                      constraints: BoxConstraints(maxWidth: 150),
                      child: FittedBox(
                        child: Text('Переданный заряд',
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                fontSize: 15, color: const Color(0xffB6B8C2))),
                      ),
                    )
                  ],
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
