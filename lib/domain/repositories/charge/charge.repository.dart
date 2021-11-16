import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';

abstract class ChargeRepository {

  
  Future<Either<Failure, ChargeResult>> startCharge(int pointId, int connector);

  Future<Either<Failure, ChargeResult>> resumeCharge(int pointId);

  Future<Either<Failure, Success>> cancelCharge(int pointId);




}