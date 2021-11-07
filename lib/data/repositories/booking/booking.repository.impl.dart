import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/data/data-sources/booking/booking.remote_data_source.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/repositories/booking/booking.repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BookingRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<List<Booking>> checkBookings() async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return [];
    }

    return remoteDataSource.checkBookings();
  }

  @override
  Future<Either<Failure, Booking>> bookPoint(
      DateTime time, int pointId, ConnectorTypes connector) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.bookPoint(time, pointId, connector);
  }

  @override
  Future<Either<Failure, int>> cancelBooking(int pointId) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.cancelBooking(pointId);
  }
}
