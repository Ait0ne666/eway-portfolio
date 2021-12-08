import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/domain/entitites/payment/threeDs.entity.dart';

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


class CreditCardAddedState extends PaymentState {
  const CreditCardAddedState({required List<CreditCard> cards}):super(cards: cards);
}


class CreditCardAddingState extends PaymentState {
  const CreditCardAddingState({required List<CreditCard> cards}):super(cards: cards);
}


class CreditCardAddErrorState extends PaymentState {

  final String message;

  const CreditCardAddErrorState({required List<CreditCard> cards, required this.message}):super(cards: cards);
}


class CreditCard3DSState extends PaymentState {
  final ThreeDS threeDs;
  const CreditCard3DSState({required List<CreditCard> cards, required this.threeDs}):super(cards: cards);
}


class PaymentDoneState extends PaymentState {
  const PaymentDoneState({required List<CreditCard> cards}):super(cards: cards);
}


class PaymentProcessingState extends PaymentState {
  const PaymentProcessingState({required List<CreditCard> cards}):super(cards: cards);
}


class PaymentErrorState extends PaymentState {

  final String message;

  const PaymentErrorState({required List<CreditCard> cards, required this.message}):super(cards: cards);
}


class Payment3DSState extends PaymentState {
  final ThreeDS threeDs;
  const Payment3DSState({required List<CreditCard> cards, required this.threeDs}):super(cards: cards);
}
