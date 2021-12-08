import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/domain/entitites/coordinates/coordinates.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/distance.dart';
import 'package:lseway/domain/entitites/point/nearest_point.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';
import 'package:lseway/domain/repositories/points/points.repository.dart';

class PointsUseCase {
  final PointsRepository repository;

  Map<int, TravelDistance> distances = {};

  PointsUseCase({required this.repository});

  Future<Either<Failure, List<Point>>> getPointsByFilter(Filter filter, Coordinates gps, double range) {
    return repository.getPointsByFilter(filter, gps, range);
  }


  Future<Either<Failure, PointInfo>> getPointInfo(int pointId) {
    return repository.getPointInfo(pointId);
  }


  Future<TravelDistance?> getTravelDistance(Coordinates origin, Coordinates destination, int pointId) async {
    var result = await repository.getTravelDistance(origin, destination, pointId);

    if (result != null) {
      distances[pointId] = result;
    }
    return result;
  }


  TravelDistance? getExistingDistance (int pointId) {

    if (distances.containsKey(pointId)) {
      return distances[pointId];
    }

    return null;


  }



  Future<Either<Failure, List<NearestPoint>>> getNearestPoints(LatLng coords) {
    return repository.getNearestPoints(coords);
  }


  Future<Either<Failure, PointInfo>> getChargingPoint() {
    return repository.getChargingPoint();
  }
}
