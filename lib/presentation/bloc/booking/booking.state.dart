import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';

class BookingState extends Equatable {

  final Booking? booking;

  const BookingState({required this.booking});


  @override
  List<Object?> get props => [booking] ;

}



class BookingInitialsState extends BookingState {


  const BookingInitialsState():super(booking: null);

}


class BookingMadeState extends BookingState {


  const BookingMadeState({required Booking booking}):super(booking: booking);

}

class BookingInProgress extends BookingState {

  const BookingInProgress({Booking? booking}): super(booking: booking);

}

class BookingCancelInProgress extends BookingState {

  const BookingCancelInProgress({Booking? booking}): super(booking: booking);

}


class BookingErrorState extends BookingState {

  final String message;


  const BookingErrorState({required this.message, Booking? booking}): super(booking: booking);
}


class BookingCancelErrorState extends BookingState {

  final String message;


  const BookingCancelErrorState({required this.message, Booking? booking}): super(booking: booking);
}


class BookingCanceledState extends BookingState {


  const BookingCanceledState():super(booking: null);

}



