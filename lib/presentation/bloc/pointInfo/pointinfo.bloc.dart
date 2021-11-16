import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';
import 'package:lseway/domain/use-cases/points/points.use_case.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.state.dart';

class PointInfoBloc extends Bloc<PointInfoEvent, PointInfoState> {
  final PointsUseCase usecase;
  final UserLocalDataSource localDataSource;
  Map<int, PointInfo> points = {};

  PointInfoBloc({required this.usecase, required this.localDataSource})
      : super(InitialPointInfoState()) {
    on<LoadPoint>((event, emit) async {
      var existingPoint = points.containsKey(event.pointId);

      if (!existingPoint) {
        emit(PointInfoLoadingState(points: points));
      }

      var result = await usecase.getPointInfo(event.pointId);

      result.fold((failure) {
        emit(PointInfoErrorState(points: points, message: failure.message));
      }, (success) {
        points[event.pointId] = success;
        emit(PointInfoLoadedState(points: points));
      });
    });

    on<ShowPoint>((event, emit) {
      emit(ShowPointState(pointid: event.pointId, points: points));
    });

    on<ClearPoint>((event, emit) {
      emit(ClearPointState(points: points));
    });
    on<CheckIfPointExist>((event, emit) async {
      var existingPoint = points.containsKey(event.pointId);

      if (!existingPoint) {
        emit(PointInfoExistLoadingState(points: points,));

        var result = await usecase.getPointInfo(event.pointId);

        result.fold((failure) {
          emit(PointInfoExistErrorState(points: points, message: failure.message));
        }, (success) {
          points[event.pointId] = success;
          emit(PointInfoExistState(points: points, pointId: event.pointId));
        });
      } else {
        emit(PointInfoExistState(points: points, pointId: event.pointId));
      }
    });
  }
}
