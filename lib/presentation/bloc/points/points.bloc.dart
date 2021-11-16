import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';
import 'package:lseway/domain/use-cases/points/points.use_case.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';
import 'package:lseway/presentation/bloc/points/points.event.dart';
import 'package:lseway/presentation/bloc/points/points.state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:lseway/utils/utils.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  final PointsUseCase usecase;
  final UserLocalDataSource localDataSource;
  final ChargeBloc chargeBloc;
  Filter filter = Filter(availability: false);
  List<Point> points = [];

  PointsBloc(
      {required this.usecase,
      required this.localDataSource,
      required this.chargeBloc})
      : super(PointsInitialState()) {
    on<ChangeFilter>((event, emit) async {
      filter = event.filter;
      emit(FilterChangedState(filter: filter, points: points));
    });
    on<SaveCurrentFilter>((event, emit) {
      localDataSource.saveFilter(filter);
    });
    on<LoadInitialPoints>((event, emit) async {
      emit(PointsLoadingState(filter: filter, points: points));

      var savedFilter = localDataSource.getFilter();

      if (savedFilter != null) {
        filter = savedFilter;
      }

      var result =
          await usecase.getPointsByFilter(filter, event.gps, event.range);

      result.fold((failure) {
        emit(PointsErrorState(
            filter: filter, message: failure.message, points: points));
      }, (success) {
        // points = combinePointLists(points, success, filter: filter);
        points = success;
        emit(PointsLoadedState(filter: filter, points: points));
      });
    });
    on<LoadMorePoints>((event, emit) async {
      emit(PointsLoadingState(filter: filter, points: points));

      var result =
          await usecase.getPointsByFilter(filter, event.gps, event.range);

      result.fold((failure) {
        emit(PointsErrorState(
            filter: filter, message: failure.message, points: points));
      }, (success) {
        // points = combinePointLists(points, success);
        points = success;
        emit(PointsLoadedState(filter: filter, points: points));
      });
    }, transformer: droppable());

    on<FetchChargingPoint>((event, emit) async {
      var result = await usecase.getChargingPoint();

      result.fold((failure) {}, (success) {
        points = combinePointLists(points, [success.point]);
        chargeBloc.add(ResumeCharge(pointId: success.point.id));
        emit(PointsLoadedState(filter: filter, points: points));
      });
    });
  }
}
