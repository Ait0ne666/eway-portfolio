import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';


class ConnectorInfo {
  ConnectorTypes type;
  bool available;
  int id;

  ConnectorInfo({required this.type, required this.available, required this.id});
}


class Tariff {
  double price;
  String from;
  String to;


  Tariff({required this.from, required this.to, required this.price});
}



class PointInfo extends Equatable {
  final Point point;
  final VoltageTypes? voltage;
  final List<ConnectorInfo> connectors;
  final double? price;
  final List<Tariff> tariffs;
  final double? distance;
  final double? duration;

  const PointInfo({
    required this.point,
    required this.voltage,
    required this.connectors,
    required this.price,
    required this.tariffs,
    this.distance,
    this.duration
  });

  PointInfo copyWith({
  Point? point,
  VoltageTypes? voltage,
  List<ConnectorInfo>? connectors,
  double? price,
  List<Tariff>? tariffs,
  double? distance,
  double? duration
  }) {
    return PointInfo(
      point: point ?? this.point,
      voltage: voltage ?? this.voltage,
      connectors: connectors ?? this.connectors,
      price: price ?? this.price,
      tariffs: tariffs ?? this.tariffs,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [point, voltage, connectors, price, distance, duration];
}
