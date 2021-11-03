import 'package:equatable/equatable.dart';

class Point extends Equatable {
  final int id;
  final String address;
  final bool availability;
  final double latitude;
  final double longitude;

  const Point(
      {required this.id,
      required this.longitude,
      required this.latitude,
      required this.address,
      required this.availability});

  Point copyWith({
    int? id,
    String? address,
    bool? availability,
    double? latitude,
    double? longitude,
  }) {
    return Point(
      id: id ?? this.id,
      address: address ?? this.address,
      availability: availability ?? this.availability,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [id, address, availability, latitude, longitude];
}
