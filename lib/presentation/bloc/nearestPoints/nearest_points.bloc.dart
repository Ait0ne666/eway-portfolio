import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/point/nearest_point.dart';
import 'package:lseway/domain/use-cases/points/points.use_case.dart';
import 'package:lseway/presentation/bloc/nearestPoints/nearest_points.event.dart';
import 'package:lseway/presentation/bloc/nearestPoints/nearest_points.state.dart';

class NearestPointsBloc extends Bloc<NearestPointsEvent, NearestPointsState> {
  final PointsUseCase usecase;
  List<NearestPoint> points = [];

  NearestPointsBloc({required this.usecase})
      : super(NearestPointsInitialState()) {
    on<LoadNearestPoints>((event, emit) async {
      var result = await usecase.getNearestPoints(event.coords);

      result.fold((failure) {
        emit(NearestPointsErrorState(points: points, message: failure.message));
      }, (success) {
        points = success;
        emit(NearestPointsLoadedState(points: points));
      });
    });
  }
}
