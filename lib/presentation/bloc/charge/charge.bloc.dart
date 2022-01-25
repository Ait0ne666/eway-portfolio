

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/charge/charge_ended_result.dart';
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
      emit(ChargeConnectingState(progress: progress));
      var result = await usecase.startCharge(event.pointId, event.connector);

      result.fold((failure) {
        emit(ChargeErrorState(progress: progress, message: failure.message));
      }, (result) {
        activePointsBloc.add(SetChargingPoint(pointId: event.pointId));
        emit(ChargeStartedState(progress: result.initialValue));
        result.stream.listen((event) {
          progress = event;
          if (progress?.status == ChargeStatus.CANCELED) {
            var chargeEndedResult = ChargeEndedResult(
              id: progress!.chargeId,
              voltage: progress!.powerAmount,
              amount: progress!.paymentAmount,
              time: DateTime.now().difference(progress!.createdAt).inMinutes,
            );

            add(ClearCharge(result: chargeEndedResult));
          } else {
            add(SetChargeProgress(progress: progress!));
          }
        });
      });
    });
    on<ResumeCharge>((event, emit) async {
      var result = await usecase.resumeCharge(event.pointId);

      result.fold((failure) {
        // emit(ChargeErrorState(progress: progress, message: failure.message));
      }, (result) {
        activePointsBloc.add(SetAndShowChargingPoint(pointId: event.pointId));
        progress = result.initialValue;
        emit(ChargeInProgressState(progress: progress!));
        result.stream.listen((event) {
          progress = event;
          if (progress?.status == ChargeStatus.CANCELED) {
            var chargeEndedResult = ChargeEndedResult(
              id: progress!.chargeId,
              voltage: progress!.powerAmount,
              amount: progress!.paymentAmount,
              time: DateTime.now().difference(progress!.createdAt).inMinutes,
            );

            add(ClearCharge(result: chargeEndedResult));
          } else {
            add(SetChargeProgress(progress: progress!));
          }
        });
      });
    });
    on<StopCharge>((event, emit) async {
      emit(ChargeStoppingState(progress: progress));
      var result = await usecase.cancelCharge(event.pointId);

      result.fold((failure) {
        emit(ChargeStoppingErrorState(
            progress: progress, message: failure.message));
      }, (result) {
        progress = null;
        activePointsBloc.add(ClearChargingPoint());
        emit(ChargeEndedState(result: result));
      });
    });
    on<StopChargeAutomatic>((event, emit) async {
      var result = await usecase.cancelCharge(event.pointId);

      result.fold((failure) {
        emit(ChargeErrorState(progress: progress, message: failure.message));
      }, (success) {
        progress = null;
        activePointsBloc.add(ClearChargingPoint());
        emit(ChargeEndedAutomaticState(result: success));
      });
    });
    on<SetChargeProgress>((event, emit) {
      progress = event.progress;
      emit(ChargeInProgressState(progress: progress!));
    });

    on<ClearCharge>((event, emit) {
      progress = null;
      activePointsBloc.add(ClearChargingPoint());

      emit(ChargeEndedRemotelyState(result: event.result));
    });
    on<FetchUnpaidCharge>((event, emit) async {
      var result = await usecase.fetchUnpaidCharge();

      if (result != null) {
        emit(UnpaidChargeState(progress: progress, result: result));
      }
    });
  }
}
