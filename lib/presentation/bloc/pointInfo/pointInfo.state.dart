import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';

class PointInfoState extends Equatable {
  final Map<int,PointInfo> points;


  const PointInfoState({required this.points});


  @override
  List<Object> get props => [points];
}



class InitialPointInfoState extends PointInfoState {


  InitialPointInfoState():super(points: {});

}



class PointInfoLoadedState extends PointInfoState {
  const PointInfoLoadedState({required Map<int,PointInfo> points}): super(points: points);
}


class PointInfoErrorState extends PointInfoState {
  final String message;

  const PointInfoErrorState({required Map<int,PointInfo> points, required this.message}): super(points: points);

    @override
  List<Object> get props => [points, message];
}


class PointInfoLoadingState extends PointInfoState {
  const PointInfoLoadingState({required Map<int,PointInfo> points}): super(points: points);
}



class ShowPointState extends PointInfoState {
  final int pointid;


  const ShowPointState({required this.pointid, required Map<int,PointInfo> points}): super(points: points);

    @override
  List<Object> get props => [points, pointid];
}


class ClearPointState extends PointInfoState {
  


  const ClearPointState({required Map<int,PointInfo> points}): super(points: points);

}



