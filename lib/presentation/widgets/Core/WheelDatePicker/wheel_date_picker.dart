import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lseway/utils/utils.dart';

class WheelDatePicker extends StatelessWidget {
  final List<DateTime> dates;
  final void Function(DateTime newDate) onDateChange;
  final DateTime? currentValue;

  final DateFormat dateFormat = DateFormat('d MMMM yyyy', 'ru');

  WheelDatePicker(
      {Key? key,
      required this.dates,
      required this.onDateChange,
      this.currentValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildDateList() {
      DateFormat hourFormat = DateFormat('HH');
      DateFormat minuteFormat = DateFormat('mm');

      return dates.map((date) {
        return Container(
          // height: 60,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 25,
                    child: Center(
                        child: Text(
                      hourFormat.format(date),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: currentValue != null &&
                                  date.isAtSameMomentAs(currentValue!)
                              ? 20
                              : 16),
                    ))),
                const SizedBox(
                  width: 30,
                ),
                Container(
                    width: 25,
                    child: Center(
                        child: Text(
                      minuteFormat.format(date),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: currentValue != null &&
                                  date.isAtSameMomentAs(currentValue!)
                              ? 20
                              : 16),
                    ))),
              ],
            ),
          ),
        );
      }).toList();
    }

    return Container(
      height: 180,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 58,
              ),
              Container(
                height: 64,
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Color(0xffE0E0E7), width: 2),
                      top: BorderSide(color: Color(0xffE0E0E7), width: 2)),
                ),
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Container(
                          child: Center(
                            child: Text(
                              currentValue == null
                                  ? 'Сегодня'
                                  : isSameDay(currentValue!, DateTime.now())
                                      ? 'Сегодня'
                                      : dateFormat.format(currentValue!),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                      fontFamily: 'Circe',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Container(
                height: 58,
              )
            ],
          ),
          Row(
            children: [
              Flexible(flex: 1, child: Container()),
              Flexible(
                flex: 1,
                child: Container(
                  child: ListWheelScrollView(
                    children: _buildDateList(),
                    itemExtent: 60,
                    physics: const FixedExtentScrollPhysics(),
                    overAndUnderCenterOpacity: 0.3,
                    onSelectedItemChanged: (index) =>
                        onDateChange(dates[index]),
                    magnification: 1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
