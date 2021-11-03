import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/activePoints/active_point_event.dart';
import 'package:lseway/presentation/bloc/activePoints/active_point_state.dart';

class ActivePointsBloc extends Bloc<ActivePointEvent, ActivePointsState> {
  int? chargingPoint;
  int? reservedPoint;

  ActivePointsBloc() : super(ActivePointsInitialState()) {
    on<SetChargingPoint>((event, emit) async {
      chargingPoint = event.pointId;

      emit(ActivePointsLoadedState(chargingPoint: chargingPoint));
    });
    on<SetReservedPoint>((event, emit) async {
      reservedPoint = event.pointId;

      emit(ActivePointsLoadedState(reservedPoint: reservedPoint));
    });

    on<ClearChargingPoint>((event, emit) async {
      chargingPoint = null;

      emit(ActivePointsLoadedState(chargingPoint: chargingPoint));
    });
    on<ClearReservedPoint>((event, emit) async {
      reservedPoint = null;

      emit(ActivePointsLoadedState(reservedPoint: reservedPoint));
    });
  }
}
