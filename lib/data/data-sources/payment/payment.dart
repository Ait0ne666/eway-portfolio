import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
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
          cards.add(CreditCardModel(
              mask: card["card_mask"],
              month: card["expiration_date_month"],
              year: card["expiration_date_year"],
              id: card["card_id"],
              isActive: card["active"] ?? false));
        });
      } else if (result != null) {
        cards.add(CreditCardModel(
            mask: result["card_mask"],
            month: result["expiration_date_month"],
            year: result["expiration_date_year"],
            id: result["card_id"],
            isActive: result["active"] ?? false));
      }

      return Right(cards);
      // return Right([]);
    } on DioError catch (err) {
      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        return Left(ServerFailure('Произошла непредвиденная ошибка'));
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
      return Left(ServerFailure('Не удалось сменить активную карту'));
    }
  }

  Future<Either<Failure, List<CreditCardModel>>> confirm3Ds(
      String md, String paRes) async {
    var url = Config.PAYMENT_URL + 'payment';

    var data = {'MD': md, 'PaRes': paRes};

    try {
      var response =
          await dio.post(url, data: data);

      return fetchCards();
    } catch (err) {
      return Left(ServerFailure('Не удалось привязать карту'));
    }
  }

  Future<Either<Failure, Success>> confirmPayment(
      int chargeId, bool confirm) async {
    var url = _apiUrl + 'payment';

    var data = {"charging_id": chargeId, "confirm_payment": confirm};

    try {
      var response = await dio.post(url, data: data);
      var result = response.data['result'];

      return Right(
        Success()
      );
    } catch (err) {
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
      return Left(ServerFailure('Не удалось привязать карту'));
    }
  }
}
