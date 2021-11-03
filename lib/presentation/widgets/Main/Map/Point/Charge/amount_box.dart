import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lseway/utils/utils.dart';

class AmountBox extends StatelessWidget {
  final double amount;
  final DateTime startTime;
  const AmountBox({Key? key, required this.amount, required this.startTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat('HH:mm:ss');
    var time = DateTime.now().difference(startTime);



      var mod = (amount*100) % 100;

    var formatCurrency = NumberFormat.currency(
        locale: 'ru_RU', symbol: '', decimalDigits: mod == 0 ? 0 : 2);

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 17, right: 35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xffF6F6FA),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatCurrency.format(amount),
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
