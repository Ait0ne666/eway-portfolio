import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/data/data-sources/charge/charge.remote_data_source.dart';
import 'package:lseway/domain/entitites/charge/charge_ended_result.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/repositories/charge/charge.repository.dart';

class ChargeRepositoryImpl implements ChargeRepository {
  final ChargeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChargeRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, ChargeResult>> startCharge(int pointId, int connector) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.startCharge(pointId, connector);
  }

  @override
  Future<Either<Failure, ChargeResult>> resumeCharge(
      int pointId) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.resumeCharge(pointId);
  }

  @override
  Future<Either<Failure, ChargeEndedResult>> cancelCharge(int pointId) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.cancelCharge(pointId);
  }


  @override 
  Future<ChargeEndedResult?> fetchUnpaidCharge() {
    return remoteDataSource.fetchUnpaidCharge();
  }
}
