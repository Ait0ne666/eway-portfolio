import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/painter/timer_lines_painter.dart';
import 'package:lseway/core/painter/timer_painter.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';

class TimerView extends StatefulWidget {
  final double currentPercent;
  final int pointId;
  const TimerView({Key? key, required this.currentPercent, required this.pointId}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _controller.animateTo(widget.currentPercent/100);
    animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    super.initState();
  }


  @override
  void didUpdateWidget(oldWidget) {
    if (widget.currentPercent != oldWidget.currentPercent) {
      _controller.animateTo(widget.currentPercent/100);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
    print('PERCENT');
    print(widget.currentPercent);
    return CustomPaint(
      painter: TimerLinesPainter(),
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.currentPercent.floor().toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(fontSize: 50, height: 1),
                            ),
                            Text(
                              '%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 15,
                                    color: const Color(0xff1A1D21),
                                    fontWeight: FontWeight.w800,
                                  ),
                            )
                          ],
                        ),
                        Transform.translate(
                            offset: Offset(-8, 3),
                            child: Text(
                              '/100',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                      fontSize: 28,
                                      color: const Color(0xffB6B7C1),
                                      height: 1,
                                      fontWeight: FontWeight.w400),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Text('Уровень заряда', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 15, color: const Color(0xffB6B7C1),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
