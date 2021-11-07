import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/point/nearest_point.dart';

class NearestPointsState extends Equatable {
  final List<NearestPoint> points;

  const NearestPointsState({required this.points});

  @override
  List<Object> get props => [points];
}

class NearestPointsInitialState extends NearestPointsState {
  NearestPointsInitialState() : super(points: []);
}

class NearestPointsLoadedState extends NearestPointsState {
  const NearestPointsLoadedState({required List<NearestPoint> points})
      : super(points: points);
}

class NearestPointsErrorState extends NearestPointsState {
  final String message;

  const NearestPointsErrorState(
      {required List<NearestPoint> points, required this.message})
      : super(points: points);
}
