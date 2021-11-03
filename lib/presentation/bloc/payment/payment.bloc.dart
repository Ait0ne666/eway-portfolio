import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/payment/card.entity.dart';
import 'package:lseway/domain/use-cases/payment/payment.usecase.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentUsecase usecase;
  
  List<CreditCard> cards = [];

  PaymentBloc({required this.usecase}):super(PaymentInitialState()){


    on<FetchCards>((event, emit) async {
      
        var result  = await usecase.fetchCards();


      result.fold((failure) {
        emit(CreditCardsErrorState(cards: cards, message: failure.message));
      }, (success) {
        cards = success;
        emit(CreditCardsLoadedState(cards: cards));
      });

    


      
    });
  }



}
