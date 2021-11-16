import 'package:equatable/equatable.dart';

class ActivePointsState extends Equatable {

  final int? chargingPoint;
  final int? reservedPoint;



  const ActivePointsState({this.chargingPoint, this.reservedPoint});



  @override
  List<Object?> get props => [chargingPoint, reservedPoint];

}





class ActivePointsInitialState extends ActivePointsState {


}


class ActivePointsLoadedState extends ActivePointsState {


  ActivePointsLoadedState({int? chargingPoint, int? reservedPoint}): super(chargingPoint: chargingPoint, reservedPoint: reservedPoint);

}

class ShowActiveChargingPoint extends ActivePointsLoadedState {

  ShowActiveChargingPoint({int? chargingPoint, int? reservedPoint}): super(chargingPoint: chargingPoint, reservedPoint: reservedPoint);
}

