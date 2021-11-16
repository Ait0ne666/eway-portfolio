import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';

abstract class BookingRepository {


  Future<List<Booking>> checkBookings();


  Future<Either<Failure, Booking>> bookPoint(DateTime time, int pointId, int connector);


  Future<Either<Failure, int>>  cancelBooking(int pointId);


}