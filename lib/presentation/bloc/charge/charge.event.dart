import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';

class ChargeEvent extends Equatable {


  @override
  List<Object> get props => [];
}




class StartCharge extends ChargeEvent {

  final int pointId;

  StartCharge({required this.pointId});


}



class SetChargeProgress extends ChargeEvent {

  final ChargeProgress progress;

  SetChargeProgress({required this.progress});


}


class StopCharge extends ChargeEvent {

  final int pointId;

  StopCharge({required this.pointId});


}

class StopChargeAutomatic extends ChargeEvent {

  final int pointId;

  StopChargeAutomatic({required this.pointId});


}