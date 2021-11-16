import 'package:equatable/equatable.dart';

class PaymentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCards extends PaymentEvent {}

class AddCard extends PaymentEvent {
  final String cryptoToken;

  AddCard({required this.cryptoToken});

  @override
  List<Object> get props => [cryptoToken];
}

class Get3DS extends PaymentEvent {
  final String cryptoToken;

  Get3DS({required this.cryptoToken});

  @override
  List<Object> get props => [cryptoToken];
}

class ChangeActiveCard extends PaymentEvent {
  final String id;

  ChangeActiveCard({required this.id});
}
