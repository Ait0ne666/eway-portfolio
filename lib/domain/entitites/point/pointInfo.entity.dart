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

  const PointInfo({
    required this.point,
    required this.voltage,
    required this.connectors,
    required this.price,
    required this.tariffs,
  });

  PointInfo copyWith({
  Point? point,
  VoltageTypes? voltage,
  List<ConnectorInfo>? connectors,
  double? price,
  List<Tariff>? tariffs,
  }) {
    return PointInfo(
      point: point ?? this.point,
      voltage: voltage ?? this.voltage,
      connectors: connectors ?? this.connectors,
      price: price ?? this.price,
      tariffs: tariffs ?? this.tariffs
    );
  }

  @override
  List<Object?> get props => [point, voltage, connectors, price];
}
