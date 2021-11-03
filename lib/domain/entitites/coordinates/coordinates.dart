import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart';


@JsonSerializable()
class Coordinates {
  double lat;
  double long;

  Coordinates({required this.lat, required this.long});

  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);

  /// Connect the generated [_$CoordinatesToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}