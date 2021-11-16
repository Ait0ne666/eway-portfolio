import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';

class BookingEvent extends Equatable {

  @override
  List<Object> get props => [];

}



class BookPoint extends BookingEvent {

  final int pointId;
  final int connector;
  final DateTime time;


  BookPoint({required this.pointId, required this.connector, required this.time});
}



class CancelBooking extends BookingEvent {


  final int pointId;

  CancelBooking({required this.pointId});
}


class CheckBookings extends BookingEvent {

  
}


class ClearBooking extends BookingEvent {

}