import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/data/models/payment/card.model.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/domain/entitites/payment/threeDs.entity.dart';

class PaymentRemoteDataSource {
  final Dio dio;

  static const String _apiUrl = Config.API_URL;

  PaymentRemoteDataSource({required this.dio});

  Future<Either<Failure, List<CreditCardModel>>> fetchCards() async {
    var url = _apiUrl + 'cards';

    try {
      var response = await dio.get(url);

      var result = response.data['result'];

      List<CreditCardModel> cards = [];

      if (result != null && result is List) {
        result.forEach((card) {
          if (card["card_id"] != (Platform.isIOS ? 'GooglePay' : 'ApplePay')) {
            cards.add(CreditCardModel(
                mask: card["card_mask"],
                month: card["expiration_date_month"],
                year: card["expiration_date_year"],
                id: card["card_id"],
                isActive: card["active"] ?? false,
                type: card["card_id"] == 'GooglePay'
                    ? PaymentTypes.GOOGLE_PAY
                    : card["card_id"] == 'ApplePay'
                        ? PaymentTypes.APPLE_PAY
                        : PaymentTypes.CARD));
          }
        });
      } else if (result != null &&
          result["card_id"] != (Platform.isIOS ? 'GooglePay' : 'ApplePay')) {
        cards.add(CreditCardModel(
            mask: result["card_mask"],
            month: result["expiration_date_month"],
            year: result["expiration_date_year"],
            id: result["card_id"],
            isActive: result["active"] ?? false,
            type: result["card_id"] == 'GooglePay'
                ? PaymentTypes.GOOGLE_PAY
                : result["card_id"] == 'ApplePay'
                    ? PaymentTypes.APPLE_PAY
                    : PaymentTypes.CARD));
      }

      return Right(cards);
      // return Right([]);
    } on DioError catch (err) {
      if (err.response?.data['errors'] != null &&
          err.response?.data['errors'].length > 0) {
        var message = err.response?.data['errors'][0]['message'];
        // if (message == '400 Client don`t have cards') {
        //   return Left(
        //       ServerFailure('У вас не привязан ни один способ платежа'));
        // }
        return Left(ServerFailure(message));
      }
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, List<CreditCardModel>>> addCard(
      String cryptoToken) async {
    var url = _apiUrl + 'card';

    var data = {"card_crypto_token": cryptoToken};

    try {
      var response = await dio.post(url, data: data);

      var result = response.data['result'];

      return fetchCards();
    } catch (err) {
      if (err is DioError) {
        if (err.response?.data['errors'] != null &&
            err.response?.data['errors'].length > 0) {
          var message = err.response?.data['errors'][0]['message'];
          // if (message == '400 Client don`t have cards') {
          //   return Left(
          //       ServerFailure('У вас не привязан ни один способ платежа'));
          // }
          return Left(ServerFailure(message));
        }
        return Left(ServerFailure('Произошла непредвиденная ошибка'));
      }
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, ThreeDS>> get3DsInfo(String cryptoToken) async {
    var url = _apiUrl + 'card';

    var data = {"card_crypto_token": cryptoToken};

    try {
      var response = await dio.post(url, data: data);

      var result = response.data['result'];

      return Right(ThreeDS(
          acsUrl: result['AcsUrl'].toString(),
          transactionId: result['TransactionId'].toString(),
          paReq: result["PaReq"].toString()));
    } catch (err) {
      if (err is DioError) {
        if (err.response?.data['errors'] != null &&
            err.response?.data['errors'].length > 0) {
          var message = err.response?.data['errors'][0]['message'];
          // if (message == '400 Client don`t have cards') {
          //   return Left(
          //       ServerFailure('У вас не привязан ни один способ платежа'));
          // }
          return Left(ServerFailure(message));
        }
        return Left(ServerFailure('Произошла непредвиденная ошибка'));
      }
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }

  Future<Either<Failure, String>> changeActiveCard(String id) async {
    const url = _apiUrl + 'cards';

    var data = {"card_id": id};

    try {
      var response = await dio.put(url, data: data);

      return Right(id);
    } catch (err) {
      if (err is DioError) {
        if (err.response?.data['errors'] != null &&
            err.response?.data['errors'].length > 0) {
          var message = err.response?.data['errors'][0]['message'];
          // if (message == '400 Client don`t have cards') {
          //   return Left(
          //       ServerFailure('У вас не привязан ни один способ платежа'));
          // }
          return Left(ServerFailure(message));
        }
        return Left(ServerFailure('Не удалось сменить активную карту'));
      }

      return Left(ServerFailure('Не удалось сменить активную карту'));
    }
  }

  Future<Either<Failure, List<CreditCardModel>>> confirm3Ds(
      String md, String paRes) async {
    var url = Config.PAYMENT_URL + 'payment';

    var data = {'MD': md, 'PaRes': paRes};

    try {
      var response = await dio.post(url, data: data);

      return fetchCards();
    } catch (err) {
      if (err is DioError) {
        if (err.response?.data['errors'] != null &&
            err.response?.data['errors'].length > 0) {
          var message = err.response?.data['errors'][0]['message'];
          // if (message == '400 Client don`t have cards') {
          //   return Left(
          //       ServerFailure('У вас не привязан ни один способ платежа'));
          // }
          return Left(ServerFailure(message));
        }
        return Left(ServerFailure('Не удалось привязать карту'));
      }

      return Left(ServerFailure('Не удалось привязать карту'));
    }
  }

  Future<Either<Failure, Success>> confirmPayment(
      int chargeId, bool confirm) async {
    var url = _apiUrl + 'payment';
    // var url  = "https://run.mocky.io/v3/b310a60b-0679-4f22-974e-7436aa41fad4";

    var data = {"charging_id": chargeId, "confirm_payment": confirm};

    try {
      var response = await dio.post(url, data: data);
      var result = response.data['result'];

      return Right(Success());
    } catch (err) {
      if (err is DioError) {
        print('ERROR ${err.response?.data}');
        if (err.response?.data['errors'] != null &&
            err.response?.data['errors'].runtimeType == String) {
          var message = err.response?.data['errors'];

          // if (message == '400 Client don`t have cards') {
          //   return Left(
          //       ServerFailure('У вас не привязан ни один способ платежа'));
          // }
          return Left(ServerFailure(message));
        } else if (err.response?.data['errors'] != null &&
            err.response?.data['errors'].length > 0) {
          var message = err.response?.data['errors'][0]['message'];
          // if (message == '400 Client don`t have cards') {
          //   return Left(
          //       ServerFailure('У вас не привязан ни один способ платежа'));
          // }
          return Left(ServerFailure(message));
        }
        return Left(ServerFailure('Не удалось провести оплату'));
      }
      return Left(ServerFailure('Не удалось провести оплату'));
    }
  }

  Future<Either<Failure, Success>> confirm3dsForPayment(
      String md, String paRes) async {
    var url = Config.PAYMENT_URL + 'payment';

    var data = {'MD': md, 'PaRes': paRes};

    try {
      var response =
          await dio.post('https://ruscharge.ru/srv/v1/payment', data: data);

      return Right(Success());
    } catch (err) {
      if (err is DioError) {
        if (err.response?.data['errors'] != null &&
            err.response?.data['errors'].length > 0) {
          var message = err.response?.data['errors'][0]['message'];
          return Left(ServerFailure(message));
        }
        return Left(ServerFailure('Не удалось привязать карту'));
      }
      return Left(ServerFailure('Не удалось привязать карту'));
    }
  }

  Future<Either<Failure, WalletPaymentResult>> addWalletPayment(
      String cryptoToken, String type) async {
    var url = _apiUrl + 'card';

    var data = {"card_crypto_token": cryptoToken, "cardholder_name": type};

    try {
      var response = await dio.post(url, data: data);

      var result = response.data['result'];

      ThreeDS? threeDS = null;

      print(result);

      if (result == "Оплата успешно проведена") {
        var cardResult = await fetchCards();

        return cardResult.fold((failure) {
          return Left(failure);
        }, (cards) {
          return Right(WalletPaymentResult(
              cards: cards
                  .map((model) => CreditCard(
                      mask: model.mask,
                      month: model.month,
                      year: model.year,
                      id: model.id,
                      isActive: model.isActive,
                      type: model.type))
                  .toList(),
              threeDS: null,
              show3DS: false));
        });
      }

      if (result != null &&
          result['AcsUrl'] != null &&
          result['TransactionId'] != null &&
          result["PaReq"] != null) {
        threeDS = ThreeDS(
            acsUrl: result['AcsUrl'].toString(),
            transactionId: result['TransactionId'].toString(),
            paReq: result["PaReq"].toString());
      }

      if (threeDS != null) {
        return Right(
            WalletPaymentResult(cards: [], threeDS: threeDS, show3DS: true));
      } else {
        var cardResult = await fetchCards();

        return cardResult.fold((failure) {
          return Left(failure);
        }, (cards) {
          return Right(WalletPaymentResult(
              cards: cards
                  .map((model) => CreditCard(
                      mask: model.mask,
                      month: model.month,
                      year: model.year,
                      id: model.id,
                      isActive: model.isActive,
                      type: model.type))
                  .toList(),
              threeDS: null,
              show3DS: false));
        });
      }
    } catch (err) {
      if (err is DioError) {
        if (err.response?.data['errors'] != null &&
            err.response?.data['errors'].length > 0) {
          var message = err.response?.data['errors'][0]['message'];
          return Left(ServerFailure(message));
        }
        return Left(ServerFailure('Произошла непредвиденная ошибка'));
      }
      print(err);
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    }
  }
}
