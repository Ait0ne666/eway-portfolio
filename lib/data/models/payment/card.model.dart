import 'package:lseway/domain/entitites/payment/card.entity.dart';

class CreditCardModel {
  String mask;
  String month;
  String year;
  String id;
  bool isActive;
  PaymentTypes type;

  CreditCardModel({required this.mask, required this.month, required this.year, required this.isActive, required this.id, required this.type});
}
