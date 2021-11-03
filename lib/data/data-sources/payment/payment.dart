import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/data/models/payment/card.model.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';

class PaymentRemoteDataSource {
  final Dio dio;

  static const String _apiUrl = Config.API_URL;

  PaymentRemoteDataSource({required this.dio});



  Future<Either<Failure, List<CreditCardModel>>> fetchCards() async {

    var url = _apiUrl + 'cards';


    try {
      

        var response = await dio.get(url);

        
        
        var result = response.data['result'];
        
        var tempCard  = CreditCardModel(mask: '7689', year: '24', month: '11');
        var tempCard2  = CreditCardModel(mask: '7690', year: '23', month: '11');

        return Right([tempCard, tempCard2]);
        
    } on DioError catch (err) {
      
      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        
        return Left(ServerFailure('Произошла непредвиденная ошибка'));
      } 
      return Left(ServerFailure('Произошла непредвиденная ошибка'));
    } 

  }
}