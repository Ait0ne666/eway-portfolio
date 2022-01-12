import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/data/data-sources/payment/payment.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/domain/entitites/payment/threeDs.entity.dart';
import 'package:lseway/domain/repositories/payment/payment.repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final UserLocalDataSource localDataSource;

  PaymentRepositoryImpl(
      {required this.localDataSource,
      required this.networkInfo,
      required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CreditCard>>> fetchCards() async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    var result = await remoteDataSource.fetchCards();

    return result.fold((failure) {
      return Left(failure);
    }, (models) {
      var cards = models
          .map((model) => CreditCard(
              mask: model.mask,
              month: model.month,
              year: model.year,
              id: model.id,
              isActive: model.isActive,
              type: model.type))
          .toList();
      return Right(cards);
    });
  }

  @override
  Future<Either<Failure, List<CreditCard>>> addCard(String cryptoToken) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    var result = await remoteDataSource.addCard(cryptoToken);

    return result.fold((failure) {
      return Left(failure);
    }, (models) {
      var cards = models
          .map((model) => CreditCard(
              mask: model.mask,
              month: model.month,
              year: model.year,
              id: model.id,
              isActive: model.isActive,
              type: model.type))
          .toList();
      return Right(cards);
    });
  }

  @override
  Future<Either<Failure, ThreeDS>> get3DsInfo(String cryptoToken) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    return remoteDataSource.get3DsInfo(cryptoToken);
  }

  @override
  Future<Either<Failure, List<CreditCard>>> confirm3Ds(
      String md, String paRes) async {
    bool isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure("Отсутствует подключение к интернету"),
      );
    }

    var result = await remoteDataSource.confirm3Ds(md, paRes);

    return result.fold((failure) {
      return Left(failure);
    }, (models) {
      var cards = models
          .map((model) => CreditCard(
              mask: model.mask,
              month: model.month,
              year: model.year,
              id: model.id,
              isActive: model.isActive,
              type: model.type))
          .toList();
      return Right(cards);
    });
  }

  @override
  Future<Either<Failure, String>> changeActiveCard(String id) async {
    return remoteDataSource.changeActiveCard(id);
  }

  @override
  Future<Either<Failure, Success>> confirmPayment(
      int chargeId, bool confirm) async {
    return remoteDataSource.confirmPayment(chargeId, confirm);
  }

  @override
  Future<Either<Failure, Success>> confirm3dsForPayment(
      String md, String paRes) async {
    return remoteDataSource.confirm3dsForPayment(md, paRes);
  }
}
