import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';

class PointsState extends Equatable {

  final Filter filter;
  final List<Point> points;


  const PointsState({required this.filter, required this.points});


  @override
  List<Object?> get props => [filter, points];

}


class PointsInitialState extends PointsState {
  PointsInitialState():super(filter: Filter(availability: false), points: []);
}


class PointsErrorState extends PointsState {
  final String message;
  
  const PointsErrorState({required Filter filter, required List<Point> points, required this.message}): super(filter: filter, points: points);
}


class PointsLoadingState extends PointsState {
  const PointsLoadingState({required Filter filter, required List<Point> points}): super(filter: filter, points: points);
}

class PointsLoadedState extends PointsState {
  const PointsLoadedState({required Filter filter, required List<Point> points}): super(filter: filter, points: points);
}


class FilterChangedState extends PointsState {
  const FilterChangedState({required Filter filter, required List<Point> points}): super(filter: filter, points: points);
}


