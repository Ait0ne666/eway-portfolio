import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/data/data-sources/booking/booking.remote_data_source.dart';
import 'package:lseway/data/data-sources/points/points_remote_data_source.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';
import 'package:lseway/domain/repositories/booking/booking.repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final PointsRemoteDataSource pointsRemoteDataSource;
  final NetworkInfo networkInfo;

  BookingRepositoryImpl(
      {required this.networkInfo,
      required this.remoteDataSource,
      required this.pointsRemoteDataSource});

  @override
  Future<List<Booking>> checkBookings() async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return [];
    }

    try {
      var ids = await remoteDataSource.checkBookings();

      List<Booking> bookings = [];
      await Future.forEach<BookingPart>(ids, (element) async {
        var pointInfoResult =
            await pointsRemoteDataSource.getPointInfo(element.pointId);

        pointInfoResult.fold((failure) {}, (info) {
          bookings.add(Booking(
            address: info.point.address,
            connector: info.connectors.firstWhere(
                (el) => el.id == element.connector,
                orElse: () => ConnectorInfo(
                    id: 1, type: ConnectorTypes.CHADEMO, available: true)),
            createdAt: element.createdAt,
            latitude: info.point.latitude,
            longitude: info.point.longitude,
            pointId: info.point.id,
            tariffs: info.tariffs,
            time: element.time,
            voltage: info.voltage ?? VoltageTypes.AC22,
          ));
        });
      });

      print(bookings);
      return bookings;
    } catch (err) {
      print(err);
      return [];
    }
  }

  @override
  Future<Either<Failure, Booking>> bookPoint(
      DateTime time, int pointId, int connector) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    var booked = await remoteDataSource.bookPoint(time, pointId, connector);

    return booked.fold((failure) {
      return Left(failure);
    }, (success) async {
      var pointInfoResult = await pointsRemoteDataSource.getPointInfo(pointId);

      return pointInfoResult.fold((failure) {
        return Left(failure);
      }, (info) {
        return Right(Booking(
          address: info.point.address,
          connector: info.connectors.firstWhere(
              (el) => el.id == success.connector,
              orElse: () => ConnectorInfo(
                  id: 1, type: ConnectorTypes.CHADEMO, available: true)),
          createdAt: success.createdAt,
          latitude: info.point.latitude,
          longitude: info.point.longitude,
          pointId: info.point.id,
          tariffs: info.tariffs,
          time: success.time,
          voltage: info.voltage ?? VoltageTypes.AC22,
        ));
      });
    });
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
