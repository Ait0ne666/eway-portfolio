import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';

class BookingRemoteDataSource {
  final Dio dio;

  static const String _apiUrl = Config.API_URL;

  BookingRemoteDataSource({
    required this.dio,
  });

  Future<List<Booking>> checkBookings() async {
    List<Booking> bookings = [];

    await Future.delayed(Duration(milliseconds: 200));
    return bookings;
  }

  Future<Either<Failure, Booking>> bookPoint(
      DateTime time, int pointId, ConnectorTypes connector) async {
    await Future.delayed(Duration(milliseconds: 200));

    return Right(
      Booking(
          address: 'Старая Басманная, 9',
          connector: ConnectorTypes.CHADEMO,
          pointId: 69777372,
          tariffs: [],
          time: DateTime.now().add(Duration(hours: 2)),
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          latitude: 55.3355,
          longitude: 37.3526,
          voltage: VoltageTypes.DC150),
    );
  }

  Future<Either<Failure, int>> cancelBooking(int pointId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return Right(pointId);
  }
}
