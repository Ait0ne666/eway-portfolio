import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/snackbarBuilder/snackbarBuilder.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';

double getCurrentPriceFromTariffs(List<Tariff> tariffs) {
  double price = 0;
  DateTime currentTime = DateTime.now();

  DateFormat format = DateFormat("HH:mm");

  var time = format.format(currentTime);
  var date = format.parse(time);

  tariffs.forEach((element) {
    var start = format.parse(element.from);
    var end = format.parse(element.to);

    if ((date.isAfter(
              start,
            ) &&
            date.isBefore(end) ||
        (date.isAtSameMomentAs(start)) ||
        date.isAtSameMomentAs(end))) {
      price = element.price;
    }
  });

  return price;
}

String convertPhoneToString(String phone) {
  var mask = '9 (999) 999-99-99';
  var currentIndex = 0;
  for (var i = 0; i < mask.length; i++) {
    if (mask[i] == '9') {
      mask = mask.replaceRange(i, i + 1, phone[currentIndex]);
      currentIndex += 1;
      if (currentIndex >= phone.length) {
        break;
      }
    }
  }
  return '+' + mask;
}

void setupBlocListener<T, L, E, S>(
    BuildContext context, T state, void Function(S state) onSuccess) {
  var dialog = DialogBuilder();
  var isVisible = TickerMode.of(context);

  if (state is L) {
    if (ModalRoute.of(context) != null &&
        ModalRoute.of(context)!.isCurrent &&
        isVisible) {
      dialog.showLoadingDialog(context);
    }
  } else if (state is E) {
    if (ModalRoute.of(context) != null &&
        ModalRoute.of(context)!.isActive &&
        isVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      SnackBar snackBar = SnackbarBuilder.errorSnackBar(
          text: (state as dynamic).message, context: context);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } else if (state is S) {
    if (ModalRoute.of(context) != null &&
        ModalRoute.of(context)!.isActive &&
        isVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      onSuccess(state);
    }
  }
}

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

String timeFromNow(DateTime time) {
  var timeFormat = DateFormat('HH:mm');
  var dateFormat = DateFormat('DD.MM.yyyy HH:mm');

  var currentTime = DateTime.now();

  var diff = time.difference(currentTime);

  if (diff.inHours < 25 && currentTime.day == time.day) {
    return 'Сегодня в ' + timeFormat.format(time);
  } else {
    return dateFormat.format(time);
  }
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.day == date2.day &&
      date1.month == date2.month &&
      date1.year == date2.year;
}

List<Point> combinePointLists(List<Point> first, List<Point> second) {
  
  
  
  
  List<Point> result = [...first];

  
  second.forEach((element) {
      var exist = false;
      for (var i=0; i<first.length; i++) {
        if (element.id == first[i].id) {
          result[i] = element;
          break;
        }
      }
  });

  


  

  return result;
}




Duration getDurationForDistance(double distance) {
  var speed = 25;

  var time = distance/speed*60;

  var minutes = time.round();
  

  return Duration(minutes: minutes);
}