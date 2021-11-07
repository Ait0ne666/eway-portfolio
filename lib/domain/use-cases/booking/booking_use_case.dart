import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/repositories/booking/booking.repository.dart';

class BookingUseCase {
  BookingRepository repository;

  BookingUseCase({required this.repository});

  Future<List<Booking>> checkBookings() {
    return repository.checkBookings();
  }

  Future<Either<Failure, Booking>> bookPoint(
      DateTime time, int pointId, ConnectorTypes connector) {
    return repository.bookPoint(time, pointId, connector);
  }

  Future<Either<Failure, int>> cancelBooking(int pointId) {
    return repository.cancelBooking(pointId);
  }
}
