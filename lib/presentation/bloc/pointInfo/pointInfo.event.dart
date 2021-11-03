import 'package:equatable/equatable.dart';

class PointInfoEvent extends Equatable {

  @override
  List<Object> get props => [];


}



class LoadPoint extends PointInfoEvent {
  final int pointId;

  LoadPoint({required this.pointId});


    @override
  List<Object> get props => [pointId];
}

class ShowPoint extends PointInfoEvent {

  final int pointId;

  ShowPoint({required this.pointId});



  @override
  List<Object> get props => [pointId];
}


class ClearPoint extends PointInfoEvent {


}