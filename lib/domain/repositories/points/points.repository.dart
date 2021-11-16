import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/domain/entitites/coordinates/coordinates.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/distance.dart';
import 'package:lseway/domain/entitites/point/nearest_point.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';

abstract class PointsRepository {

  Future<Either<Failure, List<Point>>> getPointsByFilter(Filter filter, Coordinates gps, double range);
  Future<Either<Failure, PointInfo>> getPointInfo(int pointId);
  Future<TravelDistance?> getTravelDistance(Coordinates origin, Coordinates destination, int pointId);
  Future<Either<Failure, List<NearestPoint>>> getNearestPoints(LatLng coords);

  Future<Either<Failure, PointInfo>> getChargingPoint();
}