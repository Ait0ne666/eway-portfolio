import 'package:flutter/material.dart';

import 'package:lseway/domain/entitites/booking/booking.entity.dart'
    as BookingEntity;

import 'package:lseway/presentation/widgets/Booking/booking.dart';
import 'package:lseway/presentation/widgets/Main/Map/map.dart';

import 'package:rubber/rubber.dart';

class BookingWrapper extends StatefulWidget {
  
  final BookingEntity.Booking? booking;

  const BookingWrapper({Key? key,  this.booking})
      : super(key: key);

  @override
  _BookingWrapperState createState() => _BookingWrapperState();
}

class _BookingWrapperState extends State<BookingWrapper>
    with SingleTickerProviderStateMixin {
  late RubberAnimationController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _controller = RubberAnimationController(
      vsync: this, // Thanks to the mixin
      // lowerBoundValue: AnimationControllerValue(pixel: 187),
      lowerBoundValue: AnimationControllerValue(
          percentage: widget.booking != null ? 0.15 : 0),
      upperBoundValue: AnimationControllerValue(percentage: 1),
      springDescription: SpringDescription.withDampingRatio(
          mass: 1, stiffness: Stiffness.MEDIUM, ratio: DampingRatio.NO_BOUNCY),
      duration: const Duration(milliseconds: 300),
    );
    _controller.addStatusListener((status) {
      if (widget.booking != null &&
          _scrollController.hasClients &&
          _scrollController.offset != 0) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 100), curve: Curves.ease);
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.booking != oldWidget.booking) {
      if (widget.booking == null) {
        _controller.lowerBoundValue = AnimationControllerValue(percentage: 0);
        _controller.collapse();
      } else {
        _controller.lowerBoundValue =
            AnimationControllerValue(percentage: 0.15);
        _controller.animateTo(to: 0.15);
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // _controller.dispose();

    super.dispose();
  }
  

  void hideBooking() {
    _controller.collapse();
  }

  void showBooking() {
    _controller.expand();
  }

  @override
  Widget build(BuildContext context) {
    
    
    
    return RubberBottomSheet(
      // scrollController: _scrollController,
      animationController: _controller,
      lowerLayer: MapView(showBooking: showBooking,),
      upperLayer: SingleChildScrollView(
              controller: _scrollController,
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Booking(
                      hideBooking: hideBooking,
                      booking: widget.booking,
                      padding: (_controller.value) *
                          MediaQuery.of(context).size.height *
                          0.15,
                    );
                  }),
            ),
      headerHeight: MediaQuery.of(context).size.height * 0.15 + 100,
      header: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
      ),
    );
  }
}
