import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/history/history.entity.dart';
import 'package:lseway/domain/use-cases/history/history_use_case.dart';
import 'package:lseway/presentation/bloc/history/history.event.dart';
import 'package:lseway/presentation/bloc/history/history.state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryuseCase usecase;
  
  List<HistoryItem> history = [];

  HistoryBloc({required this.usecase}):super(HistoryInitialState()){


    on<FetchHistory>((event, emit) async {
      
        List<HistoryItem> items = await usecase.getHistory();


        history = items;


        emit(HistoryLoadedState(history: history));


      
    });
  }



}
