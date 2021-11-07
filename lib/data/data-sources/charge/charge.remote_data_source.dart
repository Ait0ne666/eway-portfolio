import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';

class ChargeRemoteDataSource {
  final Dio dio;

  static const String _apiUrl = Config.API_URL;

  StreamController<ChargeProgress>? progressController;
  Timer? timer;

  ChargeRemoteDataSource({required this.dio});

  Future<Either<Failure, ChargeProgress>> fetchChargeProgress(
      int pointId, int progress) async {
    return Right(ChargeProgress(
        createdAt: DateTime.now().subtract(Duration(minutes: 10)),
        paymentAmount: 120,
        pointId: 69777372,
        powerAmount: 149,
        progress: progress.toDouble()));
  }

  Future<Either<Failure, ChargeResult>> startCharge(int pointId) async {
    if (progressController != null) {
      progressController!.close();
    }
    progressController = StreamController<ChargeProgress>();

    Stream<ChargeProgress> progressStream = progressController!.stream;

    progressController!.add(ChargeProgress(
        createdAt: DateTime.now().subtract(Duration(minutes: 10)),
        paymentAmount: 0,
        pointId: 69777372,
        powerAmount: 0,
        progress: 0));

    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      var result = await fetchChargeProgress(pointId, timer.tick);

      result.fold((l) => null, (r) {
        progressController?.add(r);
        if (r.progress == 100) {
          timer.cancel();
          progressController!.close();
        }
      });
    });

    return Right(ChargeResult(
        initialValue: ChargeProgress(
            createdAt: DateTime.now().subtract(Duration(minutes: 10)),
            paymentAmount: 0,
            pointId: 69777372,
            powerAmount: 0,
            progress: 0),
        stream: progressStream));
  }

  Future<Either<Failure, Stream<ChargeProgress>>> resumeCharge(
      int pointId) async {
    if (progressController != null) {
      progressController!.close();
    }
    progressController = StreamController<ChargeProgress>();

    Stream<ChargeProgress> progressStream = progressController!.stream;

    progressController!.add(ChargeProgress(
        createdAt: DateTime.now().subtract(Duration(minutes: 10)),
        paymentAmount: 0,
        pointId: 69777372,
        powerAmount: 0,
        progress: 0));

    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      var result = await fetchChargeProgress(pointId, timer.tick);

      result.fold((l) => null, (r) {
        progressController?.add(r);
        if (r.progress == 100) {
          timer.cancel();
          progressController!.close();
        }
      });
    });

    return Right(progressStream);
  }

  Future<Either<Failure, Success>> cancelCharge(int pointId) async {
    progressController?.close();
    timer?.cancel();

    return Right(Success());
  }
}
