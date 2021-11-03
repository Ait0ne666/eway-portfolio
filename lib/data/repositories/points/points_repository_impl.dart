import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/data/data-sources/points/points_remote_data_source.dart';
import 'package:lseway/domain/entitites/coordinates/coordinates.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/distance.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';
import 'package:lseway/domain/repositories/points/points.repository.dart';

class PointsRepositoryImpl implements PointsRepository {

  final PointsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;


  PointsRepositoryImpl({required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Point>>> getPointsByFilter(Filter filter, Coordinates gps, double range) async {

    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }


    return remoteDataSource.getPointsByFilter(filter, gps, range);


  }


  @override
  Future<Either<Failure, PointInfo>> getPointInfo(int pointId) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }


    return remoteDataSource.getPointInfo(pointId);

  }

  Future<TravelDistance?> getTravelDistance(Coordinates origin, Coordinates destination) {
    return remoteDataSource.getTravelDistance(origin, destination);
  }
}