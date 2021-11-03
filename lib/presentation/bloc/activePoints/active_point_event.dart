import 'package:equatable/equatable.dart';

class ActivePointEvent extends Equatable {



  @override
  List<Object> get props => [];
}



class SetChargingPoint extends ActivePointEvent {


  final int pointId;


  SetChargingPoint({required this.pointId});


}


class SetReservedPoint extends ActivePointEvent {


  final int pointId;


  SetReservedPoint({required this.pointId});


}


class ClearChargingPoint extends ActivePointEvent {


  


  


}



class ClearReservedPoint extends ActivePointEvent {



}