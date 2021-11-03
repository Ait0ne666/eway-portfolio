import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';

abstract class PaymentRepository {

  Future<Either<Failure, List<CreditCard>>> fetchCards();


  
}


