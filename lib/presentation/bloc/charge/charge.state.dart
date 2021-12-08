import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/charge/charge_ended_result.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';

class ChargeState {
  final ChargeProgress? progress;

  const ChargeState({this.progress});

  // @override
  // List<Object?> get props => [progress];

}

class ChargeInitialState extends ChargeState {
  const ChargeInitialState() : super(progress: null);
}

class ChargeStartedState extends ChargeState {
  const ChargeStartedState({required ChargeProgress progress})
      : super(progress: progress);
}

class ChargeConnectingState extends ChargeState {
  const ChargeConnectingState({required ChargeProgress? progress})
      : super(progress: progress);
}

class ChargeStoppingState extends ChargeState {
  const ChargeStoppingState({required ChargeProgress? progress})
      : super(progress: progress);
}

class ChargeInProgressState extends ChargeState {
  const ChargeInProgressState({required ChargeProgress progress})
      : super(progress: progress);
}

class ChargeErrorState extends ChargeState {
  final String message;

  const ChargeErrorState(
      {required this.message, required ChargeProgress? progress})
      : super(progress: progress);
}

class ChargeStoppingErrorState extends ChargeState {
  final String message;

  const ChargeStoppingErrorState(
      {required this.message, required ChargeProgress? progress})
      : super(progress: progress);
}

class ChargeEndedState extends ChargeState {
  final ChargeEndedResult result;
  const ChargeEndedState({required this.result}) : super(progress: null);
}

class ChargeEndedAutomaticState extends ChargeState {
  final ChargeEndedResult result;
  const ChargeEndedAutomaticState({required this.result})
      : super(progress: null);
}

class ChargeEndedRemotelyState extends ChargeState {
  final ChargeEndedResult result;
  const ChargeEndedRemotelyState({required this.result})
      : super(progress: null);
}

class UnpaidChargeState extends ChargeState {
  final ChargeEndedResult result;
  const UnpaidChargeState(
      {required ChargeProgress? progress, required this.result})
      : super(progress: progress);
}
