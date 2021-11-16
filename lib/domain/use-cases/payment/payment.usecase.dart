import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/domain/entitites/payment/threeDs.entity.dart';
import 'package:lseway/domain/repositories/payment/payment.repository.dart';

class PaymentUsecase {
   final PaymentRepository repository;

  PaymentUsecase({required this.repository});

  Future<Either<Failure, List<CreditCard>>> fetchCards() {
    return repository.fetchCards();
  }

  Future<Either<Failure, List<CreditCard>>> addCard(String cryptoToken) {
    return repository.addCard(cryptoToken);
  }

  Future<Either<Failure, ThreeDS>> get3DsInfo(String cryptoToken) {
    return repository.get3DsInfo(cryptoToken);
  }
  

  
  Future<Either<Failure, String>> changeActiveCard(String id)  { 

    return repository.changeActiveCard(id);
  }
}
