import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/data/data-sources/payment/payment.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/domain/repositories/payment/payment.repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {

  final PaymentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final UserLocalDataSource localDataSource;



  PaymentRepositoryImpl({required this.localDataSource, required this.networkInfo, required this.remoteDataSource});



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

      var cards = models.map((model) => CreditCard(mask: model.mask, month: model.month, year: model.year)).toList();
      return Right(cards);
    });

  }



}