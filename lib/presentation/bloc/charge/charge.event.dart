import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/charge/charge_ended_result.dart';
import 'package:lseway/domain/entitites/charge/charge_progress.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';

class ChargeEvent  {


  @override
  List<Object> get props => [];
}




class StartCharge extends ChargeEvent {

  final int pointId;
  final int connector;

  StartCharge({required this.pointId, required this.connector});


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


class ResumeCharge extends ChargeEvent {

  final int pointId;

  ResumeCharge({required this.pointId});

}


class ClearCharge extends ChargeEvent {
  final ChargeEndedResult result;

  ClearCharge({required this.result});

}



class FetchUnpaidCharge extends ChargeEvent {
  
}