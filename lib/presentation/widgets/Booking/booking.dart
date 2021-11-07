import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart'
    as BookingEntity;
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/presentation/bloc/booking/booking.bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.state.dart';
import 'package:lseway/presentation/widgets/Booking/booking_view.dart';

class Booking extends StatelessWidget {
  final double padding;
  final BookingEntity.Booking? booking;
  final void Function() hideBooking;
  // final void Function() hideBottomSheet;
  const Booking({
    Key? key,
    required this.padding,
    required this.booking,
    required this.hideBooking
  }) : super(key: key);

  void bookingListener(BuildContext context, BookingState state) {
    var dialog = DialogBuilder();
    var isVisible = TickerMode.of(context);

    if (state is BookingCancelInProgress) {
      dialog.showLoadingDialog(
        context,
      );
    } else if (state is BookingCancelErrorState) {
      Navigator.of(context, rootNavigator: true).pop();
      Toast.showToast(context, state.message);
    } else if (state is BookingCanceledState) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
        listener: bookingListener,
        child: BookingView(padding: padding, booking: booking, hideBooking: hideBooking,));
  }
}
