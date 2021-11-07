import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';
import 'package:lseway/domain/use-cases/booking/booking_use_case.dart';
import 'package:lseway/presentation/bloc/activePoints/active_point_event.dart';
import 'package:lseway/presentation/bloc/activePoints/active_points_bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.event.dart';
import 'package:lseway/presentation/bloc/booking/booking.state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingUseCase usecase;
  final ActivePointsBloc activePointsBloc;

  Booking? booking;

  BookingBloc({required this.usecase, required this.activePointsBloc})
      : super(const BookingInitialsState()) {
    on<BookPoint>((event, emit) async {
      emit(BookingInProgress(booking: booking));
      var result =
          await usecase.bookPoint(event.time, event.pointId, event.connector);

      result.fold((failure) {
        emit(BookingErrorState(message: failure.message));
      }, (success) {
        booking = success;
        activePointsBloc.add(SetReservedPoint(pointId: booking!.pointId));
        emit(BookingMadeState(booking: booking!));
      });
    });

    on<CancelBooking>((event, emit) async {
      emit(BookingCancelInProgress(booking: booking));

      var result = await usecase.cancelBooking(event.pointId);

      result.fold((failure) {
        emit(BookingCancelErrorState(message: failure.message));
      }, (success) {
        booking = null;
        activePointsBloc.add(ClearReservedPoint());
        emit(const BookingCanceledState());
      });
    });

    on<CheckBookings>((event, emit) async {
      var result = await usecase.checkBookings();

      if (result.isNotEmpty) {
        booking = result[0];
        activePointsBloc.add(SetReservedPoint(pointId: booking!.pointId));
        emit(BookingMadeState(booking: booking!));
      }
    });
  }
}
