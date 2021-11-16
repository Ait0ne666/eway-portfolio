import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/repositories/charge/charge.repository.dart';

class ChargeUseCase {
  final ChargeRepository repository;

  ChargeUseCase({required this.repository});

  Future<Either<Failure, ChargeResult>> startCharge(int pointId, int connector) {
    return repository.startCharge(pointId, connector);
  }

  Future<Either<Failure, ChargeResult>> resumeCharge(int pointId) {
    return repository.resumeCharge(pointId);
  }

  Future<Either<Failure, Success>> cancelCharge(int pointId) {
    return repository.cancelCharge(pointId);
  }
}
