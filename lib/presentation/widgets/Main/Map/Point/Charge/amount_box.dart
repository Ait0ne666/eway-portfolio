import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lseway/utils/utils.dart';

class AmountBox extends StatefulWidget {
  final double amount;
  final DateTime startTime;
  const AmountBox({Key? key, required this.amount, required this.startTime})
      : super(key: key);

  @override
  State<AmountBox> createState() => _AmountBoxState();
}

class _AmountBoxState extends State<AmountBox> {
  late DateTime start;
  Timer? timer;


  @override
  void initState() {

    start = widget.startTime;

    updateTimer();
    super.initState();
  }


  @override
  void didUpdateWidget(oldWidget) {

    if (!oldWidget.startTime.isAtSameMomentAs(widget.startTime)) {
      setState(() {
        start = widget.startTime;
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
        
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat('HH:mm:ss');
    var time = DateTime.now().difference(start);



      var mod = (widget.amount*100) % 100;

    var formatCurrency = NumberFormat.currency(
        locale: 'ru_RU', symbol: '', decimalDigits: mod == 0 ? 0 : 2);

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 17, right: 5 ),
      width: 135,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xffF6F6FA),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatCurrency.format(widget.amount),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 30, height: 1.05),
                ),
                Transform.translate(
                  offset: const Offset(-5,0),
                  child: Text(
                    '₽',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 16, height: 1, fontFamily: 'Circe', fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/timer.svg'),
              const SizedBox(
                width: 8,
              ),
              Text(printDuration(time), style: TextStyle(fontSize: 15, fontFamily: 'Circe', color: Color(0xffB6B8C2)),),
            ],
          )
        ],
      ),
    );
  }
}
