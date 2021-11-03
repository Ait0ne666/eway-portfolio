import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/history/history.entity.dart';

class HistoryState {
  final List<HistoryItem> history;


  const HistoryState({required this.history});

  // @override
  // List<Object> get props => [history];

}




class HistoryInitialState extends HistoryState {


  HistoryInitialState():super(history: []);

}


class HistoryLoadedState extends HistoryState {


  const HistoryLoadedState({required List<HistoryItem> history}):super(history: history);

}


