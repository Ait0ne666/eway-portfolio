import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lseway/utils/utils.dart';

class TimeLeftCounter extends StatefulWidget {
  final double time;
  final DateTime updatedAt;
  const TimeLeftCounter({Key? key, required this.time, required this.updatedAt}) : super(key: key);

  @override
  _TimeLeftCounterState createState() => _TimeLeftCounterState();
}

class _TimeLeftCounterState extends State<TimeLeftCounter> {

  late double timeLeft;
  Timer? timer;


  @override
  void initState() {

    timeLeft = _calculateTimeLeft(widget.updatedAt, widget.time);

    updateTimer();
    super.initState();
  }

  double _calculateTimeLeft(DateTime updatedAt, double timeleft) {

    var diff = DateTime.now().difference(updatedAt.toLocal()).inSeconds;


    return (timeleft - diff) >0 ? (timeleft - diff) : 0;
  }


  @override
  void didUpdateWidget(oldWidget) {

    if (oldWidget.time != widget.time) {
      setState(() {
        timeLeft = _calculateTimeLeft(widget.updatedAt, widget.time);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateTimer() {
    // timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) { 
      setState(() {
        timeLeft = timeLeft>1 ? timeLeft - 1 : 0;
      });
    });
  }


  String hoursString(double time) {
    return printDuration(Duration(seconds: time.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    print(timeLeft);
    return Text(
      'Осталось: '+ hoursString(timeLeft),
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontSize: 15,
            color: const Color(0xffB6B8C2),
          ),
    );
  }
}
