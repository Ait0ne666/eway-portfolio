import 'package:flutter/material.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart'
    as BookingEntity;
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/presentation/widgets/Booking/booking_view.dart';

class Booking extends StatelessWidget {
  const Booking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BookingView(
        booking: BookingEntity.Booking(
            address: 'Старая Басманная, 9',
            connector: ConnectorTypes.CHADEMO,
            pointId: 6978456636,
            tariffs: [],
            time: DateTime.now().add(Duration(hours: 2)),
            createdAt: DateTime.now().subtract(Duration(hours: 2)),
            latitude: 55.3355,
            longitude: 37.3526,
            voltage: VoltageTypes.DC150));
  }
}
