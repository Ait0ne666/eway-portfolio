import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/coordinates/coordinates.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';

class PointsEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class ChangeFilter extends PointsEvent {
  final Filter filter;
  
  ChangeFilter({required this.filter});

  @override
  List<Object> get props => [filter];
}



class SaveCurrentFilter extends PointsEvent {

}


class LoadMorePoints extends PointsEvent {
  final Coordinates gps;
final double range;
  LoadMorePoints({required this.gps, required this.range});
}


class LoadInitialPoints extends PointsEvent {
  final Coordinates gps;
  final double range;

  LoadInitialPoints({required this.gps, required this.range});
}


