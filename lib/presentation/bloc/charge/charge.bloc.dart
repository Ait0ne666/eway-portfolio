import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';
import 'package:lseway/domain/use-cases/charge/charge_use_case.dart';
import 'package:lseway/presentation/bloc/activePoints/active_point_event.dart';
import 'package:lseway/presentation/bloc/activePoints/active_points_bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';
import 'package:lseway/presentation/bloc/charge/charge.state.dart';

class ChargeBloc extends Bloc<ChargeEvent, ChargeState> {
  final ChargeUseCase usecase;
  final ActivePointsBloc activePointsBloc;

  ChargeProgress? progress;

  ChargeBloc({required this.usecase, required this.activePointsBloc})
      : super(const ChargeInitialState()) {
    on<StartCharge>((event, emit) async {
      var result = await usecase.startCharge(event.pointId);

      result.fold((failure) {
        emit(ChargeErrorState(progress: progress, message: failure.message));
      }, (result) {
        activePointsBloc.add(SetChargingPoint(pointId: event.pointId));
        emit(ChargeStartedState(progress: result.initialValue));
        result.stream.listen((event) {
          progress = event;
          add(SetChargeProgress(progress: progress!));
        });
      });
    });
    on<StopCharge>((event, emit) async {
      var result = await usecase.cancelCharge(event.pointId);

      result.fold((failure) {
        emit(ChargeErrorState(progress: progress, message: failure.message));
      }, (stream) {
        progress = null;
        activePointsBloc.add(ClearChargingPoint());
        emit(const ChargeEndedState());
      });
    });
    on<StopChargeAutomatic>((event, emit) async {
      var result = await usecase.cancelCharge(event.pointId);

      result.fold((failure) {
        emit(ChargeErrorState(progress: progress, message: failure.message));
      }, (stream) {
        progress = null;
        activePointsBloc.add(ClearChargingPoint());
        emit(const ChargeEndedAutomaticState());
      });
    });
    on<SetChargeProgress>((event, emit) {
      progress = event.progress;
      emit(ChargeInProgressState(progress: progress!));
    });
  }
}
