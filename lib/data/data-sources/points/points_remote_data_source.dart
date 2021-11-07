import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/data/adapters/points/points.adapter.dart';
import 'package:lseway/data/data-sources/points/temp_points.dart';
import 'package:lseway/domain/entitites/coordinates/coordinates.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/distance.dart';
import 'package:lseway/domain/entitites/point/nearest_point.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';

class PointsRemoteDataSource {
  final Dio dio;

  static const String _apiUrl = Config.API_URL;

  PointsRemoteDataSource({required this.dio});

  Future<Either<Failure, List<Point>>> getPointsByFilter(
      Filter filter, Coordinates gps, double range) async {
    var url = _apiUrl + 'points?';

    url = url + 'gps=' + gps.lat.toString() + ',' + gps.long.toString() + '&';

    url = url + 'range=' + (range ~/ 500).toInt().toString() + '&';

    if (filter.connector != null) {
      url = url +
          'connector=' +
          mapConnectorTypesToString(filter.connector!) +
          '&';
    }

    if (filter.voltage != null) {
      url = url + 'power=' + mapVoltageToString(filter.voltage!) + '&';
    }

    url = url + 'status=' + (filter.availability ? 'available' : 'all') + '&';

    try {
      var response = await dio.get(url);

      var result = response.data['result'];
      print(result);

      // await Future.delayed(Duration(milliseconds: 50));

      return Right(mapJsonToPoints(result));
      // return Right(filter.availability ? tempPoints.where((element) => element.availability).toList() : tempPoints);
    } on DioError catch (err) {
      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        var message = 'Не удалось получить список точек';
        return Left(ServerFailure(message));
      }
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, PointInfo>> getPointInfo(int pointId) async {
    var url = _apiUrl + 'point/' + pointId.toString();

    try {
      var response = await dio.get(url);

      var result = response.data['result'];

      // await Future.delayed(Duration(milliseconds: 200));

      return Right(mapJsonToPointInfo(result));
    } on DioError catch (err) {
      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        var message = 'Не удалось получить информацию о точке';
        return Left(ServerFailure(message));
      }
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<TravelDistance?> getTravelDistance(
      Coordinates origin, Coordinates destination) async {
    var url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${origin.lat},${origin.long}&destinations=${destination.lat},${destination.long}&key=AIzaSyBrqanf0JgOKydUfoWZ-eZqq97Mhr38ePQ';

    try {
      var response = await dio.get(url);

      print(response.data);

      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<Either<Failure, List<NearestPoint>>> getNearestPoints(
      LatLng coords) async {
    return Right([
      NearestPoint(
          pointId: 69777372,
          time: Duration(minutes: 20),
          address: 'Старая Басманная, 9',
          distance: 8),
      NearestPoint(
          pointId: 69777372,
          time: Duration(minutes: 20),
          address: 'Старая Басманная, 9',
          distance: 8),
      NearestPoint(
          pointId: 69777372,
          time: Duration(minutes: 20),
          address: 'Старая Басманная, 9',
          distance: 8)
    ]);
  }
}
