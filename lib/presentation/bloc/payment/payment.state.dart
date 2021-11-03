import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';

class PaymentState extends Equatable {
  final List<CreditCard>cards;



  const PaymentState({required this.cards});

  @override
  List<Object> get props => [cards];

}



class PaymentInitialState extends PaymentState {

  PaymentInitialState():super(cards: []);

}



class CreditCardsLoadedState extends PaymentState {
  const CreditCardsLoadedState({required List<CreditCard> cards}):super(cards: cards);
}


class CreditCardsErrorState extends PaymentState {

  final String message;

  const CreditCardsErrorState({required List<CreditCard> cards, required this.message}):super(cards: cards);
}