import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:lseway/data/models/history/history.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';
import 'package:lseway/domain/entitites/charge/charge_ended_result.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/history/history.entity.dart';

List<HistoryItemModel> mapJsonToHistory(List<dynamic> json) {
  List<HistoryItemModel> items = [];
  DateFormat format = DateFormat('DD/MM/yyyy HH:mm:ss');

  json.forEach((element) {
    var payment = element['payment_amount'];
    var paid = element["paid"];
    var status = element['status'];
    if (payment != null && payment > 0 && status == 'Charging end' && paid) {
      items.add(HistoryItemModel(
        address: element['point_address'],
        id: element['id'],
        pointId: element['point_number'],
        amount: payment,
        receiptUrl: element['receipt_url'],
        refundReceiptUrl: element['refunded'] == true ? element['refund_receipt_url'] : null,
        date: format.parse(element['created_at'],
        ),
      ));
    }
  });

  return items;
}

int? getChargingPointFromJson(List<dynamic> json) {
  int? result;

  json.forEach((element) {
    var status = element['status'];
    if (status == 'EV charging') {
      result = element["point_number"];
    }
  });

  return result;
}

List<BookingPart> getBookingsFromJson(List<dynamic> json) {
  List<BookingPart> result = [];
  DateFormat format = DateFormat('DD/MM/yyyy HH:mm:ss');

  json.forEach((element) {
    var status = element['status'];
    if (status == 'Reserved charge point') {
      result.add(BookingPart(
        connector: element["reserved_connector"],
        createdAt: format.parse(element['created_at']),
        pointId: element["point_number"],
        time: format.parse(element['reserve_time']),
      ));
    }
  });

  return result;
}

BookingPart getBookingFromJson(Map<String, dynamic> json) {
  DateFormat format = DateFormat('DD/MM/yyyy HH:mm:ss');

  return BookingPart(
    connector: json["reserved_connector"],
    createdAt: format.parse(json['created_at']),
    pointId: json["point_number"],
    time: format.parse(json['reserve_time']),
  );
}

ChargeEndedResult? getUnpaidPointFromJson(List<dynamic> json) {
  ChargeEndedResult? result;

  for (var i = 0; i < json.length; i++) {
    var element = json[i];
    var status = element['status'];
    var paid = element["paid"];
    if (status == 'Charging end' && !paid) {
      result = ChargeEndedResult(
          amount: element['payment_amount'] != null ? element['payment_amount'].toDouble() : 30,
          id: element['id'],
          time: DateFormat('DD/MM/yyyy HH:mm:ss')
              .parse(element['updated_at'])
              .difference(DateFormat('DD/MM/yyyy HH:mm:ss')
                  .parse(element['created_at']))
              .inMinutes + 1,
          voltage: element['power_amount'] ?? 0);
      break;
    }
  }



  return result;
}
