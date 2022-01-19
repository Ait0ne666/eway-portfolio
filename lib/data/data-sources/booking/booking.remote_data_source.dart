import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/data/adapters/history/history.adapter.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';

class BookingRemoteDataSource {
  final Dio dio;

  static const String _apiUrl = Config.API_URL;

  BookingRemoteDataSource({
    required this.dio,
  });

  Future<List<BookingPart>> checkBookings() async {
    var url = _apiUrl + 'history';

    try {
      var response = await dio.get(url);

      var result = response.data['result'] as List<dynamic>;

      return getBookingsFromJson(result);
    } on DioError catch (err) {
      return [];
    }
  }

  Future<Either<Failure, BookingPart>> bookPoint(
      DateTime time, int pointId, int connector) async {
    var url = _apiUrl + 'point/$pointId/action';
    var statusUrl = _apiUrl + 'point/$pointId/status';

    var diff = time.difference(DateTime.now()).inMinutes;

    var t = diff >= 60 ? '1h' : diff.toString() + 'm';

    var data = {"connector": connector, "evse": 1, "action": "reserve", "time": t};

    try {
      var response = await dio.post(url, data: data);

      var statusResponse = await dio.get(statusUrl);

      var result = statusResponse.data["result"];

      return Right(
        getBookingFromJson(result),
      );
    } on DioError catch (err) {
      if (err.response?.statusCode == 400) {
        var message = 'Сожалеем, но точка уже забронирована';
        return Left(ServerFailure(message));
      }
      return Left(
        ServerFailure(
          'Произошла непредвиденная ошибка',
        ),
      );
    }

    // await Future.delayed(Duration(milliseconds: 200));

    // return Right(
    //   Booking(
    //       address: 'Старая Басманная, 9',
    //       connector: ConnectorTypes.CHADEMO,
    //       pointId: 69777372,
    //       tariffs: [],
    //       time: DateTime.now().add(Duration(hours: 2)),
    //       createdAt: DateTime.now().subtract(Duration(hours: 2)),
    //       latitude: 55.3355,
    //       longitude: 37.3526,
    //       voltage: VoltageTypes.DC150),
    // );
  }

  Future<Either<Failure, int>> cancelBooking(int pointId) async {
    var url = _apiUrl + 'point/$pointId/action';

    var data = {"connector": 1, "evse": 1, "action": "stop"};

    try {
      var response = await dio.post(url, data: data);
      return Right(pointId);
    } on DioError catch (err) {
      if (err.response?.statusCode == 400) {
        return Right(pointId);
      }
      return Left(
        ServerFailure(
          'Произошла непредвиденная ошибка',
        ),
      );
    }
  }
}
