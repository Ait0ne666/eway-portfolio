import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';

class ChargeRemoteDataSource {
  final Dio dio;

  static const String _apiUrl = Config.API_URL;

  StreamController<ChargeProgress>? progressController;
  ChargeProgress? lastProgress;
  Timer? timer;

  ChargeRemoteDataSource({required this.dio});

  Future<Either<Failure, ChargeProgress>> fetchChargeProgress(
      int pointId) async {
    var url = _apiUrl + 'point/$pointId/status';

    try {
      Response<dynamic> response = await dio.get(url);

      var result = response.data['result'];

      var progress = ChargeProgress(
          createdAt: result['created_at'] != null
              ? DateFormat('DD/MM/yyyy HH:mm:ss').parse(result['created_at'])
              : DateTime.now(),
          paymentAmount: result['payment_amount'] ?? 0,
          pointId: result['point_number'],
          powerAmount: result['power_amount'] ?? 0,
          progress: result['battery_level'] ?? 0,
          timeLeft: result['remaining_time']);
      lastProgress = progress;
      return Right(progress);
    } on DioError catch (err) {
      if (err.response?.statusCode == 400) {
        if (lastProgress != null && lastProgress?.pointId == pointId) {
          return Right(
            lastProgress!.copyWith(canceled: true),
          );
        }
        return Left(
          ServerFailure(
            'cancel',
          ),
        );
      }

      return Left(
        ServerFailure(
          'Произошла непредвиденная ошибка',
        ),
      );
    }
  }

  Future<Either<Failure, ChargeResult>> startCharge(
      int pointId, int connector) async {
    var url = _apiUrl + 'point/$pointId/action';

    var data = {"connector": connector, "evse": 1, "action": "start"};

    try {
      var response = await dio.post(url, data: data);

      var initialValue = await fetchChargeProgress(pointId);

      return initialValue.fold((failure) {
        return Left(failure);
      }, (success) {
        if (progressController != null) {
          progressController!.close();
        }
        progressController = StreamController<ChargeProgress>();

        Stream<ChargeProgress> progressStream = progressController!.stream;

        progressController!.add(success);

        timer =
            Timer.periodic(const Duration(milliseconds: 10000), (timer) async {
          var result = await fetchChargeProgress(pointId);

          result.fold((l) {
            if (l.message == 'cancel') {
              progressController?.close();
              timer.cancel();
            }
          }, (r) {
            progressController?.add(r);
            if (r.progress == 100 || r.timeLeft == 0 || r.canceled == true) {
              timer.cancel();
              progressController!.close();
            }
          });
        });

        return Right(
            ChargeResult(initialValue: success, stream: progressStream));
      });
    } on DioError catch (err) {
      if (err.response?.statusCode == 400) {
        var message = 'Сожалеем, но точка на данный момент занята';
        return Left(ServerFailure(message));
      }
      return Left(
        ServerFailure(
          'Произошла непредвиденная ошибка',
        ),
      );
    }
  }

  Future<Either<Failure, ChargeResult>> resumeCharge(int pointId) async {
    if (progressController != null) {
      progressController!.close();
    }
    progressController = StreamController<ChargeProgress>();

    Stream<ChargeProgress> progressStream = progressController!.stream;

    var initialValue = await fetchChargeProgress(pointId);

    return initialValue.fold((failure) {
      return Left(failure);
    }, (success) {
      if (progressController != null) {
        progressController!.close();
      }
      progressController = StreamController<ChargeProgress>();

      Stream<ChargeProgress> progressStream = progressController!.stream;

      progressController!.add(success);

      timer =
          Timer.periodic(const Duration(milliseconds: 10000), (timer) async {
        var result = await fetchChargeProgress(pointId);

        result.fold((l) {
          if (l.message == 'cancel') {
            progressController?.close();
            timer.cancel();
          }
        }, (r) {
          progressController?.add(r);
          if (r.progress == 100 || r.timeLeft == 0 || r.canceled == true) {
            timer.cancel();
            progressController!.close();
          }
        });
      });

      return Right(ChargeResult(initialValue: success, stream: progressStream));
    });
  }

  Future<Either<Failure, Success>> cancelCharge(int pointId) async {
    var url = _apiUrl + 'point/$pointId/action';

    var data = {"connector": 1, "evse": 1, "action": "stop"};

    try {
      timer?.cancel();
      timer = null;
      var response = await dio.post(url, data: data);

      progressController?.close();
      return Right(Success());
    } catch (err) {
      if (timer == null) {
        timer =
            Timer.periodic(const Duration(milliseconds: 10000), (timer) async {
          var result = await fetchChargeProgress(pointId);

          result.fold((l) {
            if (l.message == 'cancel') {
              progressController?.close();
              timer.cancel();
            }
          }, (r) {
            progressController?.add(r);
            if (r.progress == 100 || r.timeLeft == 0 || r.canceled == true) {
              timer.cancel();
              progressController!.close();
            }
          });
        });
      }
      return Left(
        ServerFailure(
          'Произошла непредвиденная ошибка',
        ),
      );
    }
  }
}
