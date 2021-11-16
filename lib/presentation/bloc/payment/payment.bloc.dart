import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/domain/use-cases/payment/payment.usecase.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentUsecase usecase;

  List<CreditCard> cards = [];

  PaymentBloc({required this.usecase}) : super(PaymentInitialState()) {
    on<FetchCards>((event, emit) async {
      var result = await usecase.fetchCards();

      result.fold((failure) {
        emit(CreditCardsErrorState(cards: cards, message: failure.message));
      }, (success) {
        cards = success;
        emit(CreditCardsLoadedState(cards: cards));
      });
    });

    on<AddCard>((event, emit) async {
      emit(CreditCardAddingState(cards: cards));
      var result = await usecase.addCard(event.cryptoToken);

      result.fold((failure) {
        emit(CreditCardAddErrorState(cards: cards, message: failure.message));
      }, (success) {
        cards = success;
        emit(CreditCardAddedState(cards: cards));
      });
    });

    on<Get3DS>((event, emit) async {
      emit(CreditCardAddingState(cards: cards));
      var result = await usecase.get3DsInfo(event.cryptoToken);

      result.fold((failure) {
        emit(CreditCardAddErrorState(cards: cards, message: failure.message));
      }, (success) {
        
        emit(CreditCard3DSState(cards: cards, threeDs: success));
      });
    });
    on<ChangeActiveCard>((event, emit) {
      var newCards = cards.map((e) {
        if (e.id != event.id) {
          return e.copyWith(isActive: false);
        }
        return e.copyWith(isActive: true);
      }).toList();

      cards = newCards;

      emit(CreditCardsLoadedState(cards: cards));

      usecase.changeActiveCard(event.id);

    });
  }
}
