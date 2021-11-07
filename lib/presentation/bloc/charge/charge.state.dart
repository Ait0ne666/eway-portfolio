import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';

class ChargeState  {

  final ChargeProgress? progress;

  const ChargeState({this.progress});

  // @override
  // List<Object?> get props => [progress];

}




class ChargeInitialState extends ChargeState {

  const ChargeInitialState(): super(progress: null);
}


class ChargeStartedState extends ChargeState {

  const ChargeStartedState({required ChargeProgress progress}): super(progress: progress);
}

class ChargeInProgressState extends ChargeState {

  const ChargeInProgressState({required ChargeProgress progress}): super(progress: progress);
}


class ChargeErrorState extends ChargeState {
  final String message;


  const ChargeErrorState({required this.message, required ChargeProgress? progress}):super(progress: progress);


}





class ChargeEndedState extends ChargeState {

  const ChargeEndedState(): super(progress: null);
}


class ChargeEndedAutomaticState extends ChargeState {

  const ChargeEndedAutomaticState(): super(progress: null);
}