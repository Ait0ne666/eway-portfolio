import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';

class Booking {
  final int pointId;
  final List<Tariff> tariffs;
  final VoltageTypes voltage;
  final ConnectorInfo connector;
  final String address;
  final DateTime time;
  final DateTime createdAt;
  final double latitude;
  final double longitude;

  const Booking(
      {required this.address,
      required this.connector,
      required this.pointId,
      required this.tariffs,
      required this.time,
      required this.voltage,
      required this.createdAt,
      required this.latitude, 
      required this.longitude,
      });
}


class BookingPart {
  final int pointId;
  final int connector;
  final DateTime time;
  final DateTime createdAt;
  

  const BookingPart(
      {
      required this.connector,
      required this.pointId,
      required this.time,
      required this.createdAt,
      });
}