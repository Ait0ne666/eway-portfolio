import 'package:dartz/dartz.dart';
import 'package:lseway/core/Responses/failures.dart';
import 'package:lseway/core/Responses/success.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/domain/entitites/payment/threeDs.entity.dart';

abstract class PaymentRepository {

  Future<Either<Failure, List<CreditCard>>> fetchCards();



  Future<Either<Failure, List<CreditCard>>> addCard(String cryptoToken);


  Future<Either<Failure, String>> changeActiveCard(String id);

  Future<Either<Failure, ThreeDS>> get3DsInfo(String cryptoToken);

  
}


