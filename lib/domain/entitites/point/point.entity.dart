import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';

class Point extends Equatable {
  final int id;
  final String address;
  final bool availability;
  final bool up;
  final double latitude;
  final double longitude;
  final VoltageTypes? voltage;


  const Point(
      {required this.id,
      required this.longitude,
      required this.latitude,
      required this.address,
      required this.availability,
      this.voltage,
      required this.up
      });

  Point copyWith({
    int? id,
    String? address,
    bool? availability,
    double? latitude,
    double? longitude,
    VoltageTypes? voltage,
    bool? up

  }) {
    return Point(
      id: id ?? this.id,
      address: address ?? this.address,
      availability: availability ?? this.availability,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      voltage: voltage ?? this.voltage,
      up: up ?? this.up,
    );
  }

  @override
  List<Object?> get props => [id, address, availability, latitude, longitude, voltage, up];
}
