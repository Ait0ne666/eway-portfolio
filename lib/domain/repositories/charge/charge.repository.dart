import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';

abstract class ChargeRepository {

  
  Future<Either<Failure, Stream<ChargeProgress>>> startCharge(int pointId);

  Future<Either<Failure, Stream<ChargeProgress>>> resumeCharge(int pointId);

  Future<Either<Failure, Success>> cancelCharge(int pointId);




}