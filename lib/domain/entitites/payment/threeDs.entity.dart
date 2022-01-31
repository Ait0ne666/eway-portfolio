import 'package:lseway/domain/entitites/payment/card.entity.dart';

class ThreeDS {
  final String acsUrl;
  final String transactionId;
  final String paReq;


  ThreeDS({required this.acsUrl, required this.paReq, required this.transactionId});
}




class WalletPaymentResult {

  final bool show3DS;
  final ThreeDS? threeDS;
  final List<CreditCard> cards;


  WalletPaymentResult({required this.show3DS, required this.cards, this.threeDS});

}