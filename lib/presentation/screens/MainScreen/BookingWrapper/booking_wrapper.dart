import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';

class BookingWrapper extends StatefulWidget {
  final Widget upperLayer;
  final Widget lowerLayer;

  const BookingWrapper(
      {Key? key, required this.lowerLayer, required this.upperLayer})
      : super(key: key);

  @override
  _BookingWrapperState createState() => _BookingWrapperState();
}

class _BookingWrapperState extends State<BookingWrapper>
    with SingleTickerProviderStateMixin {
  late RubberAnimationController _controller;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _controller = RubberAnimationController(
      vsync: this, // Thanks to the mixin
      lowerBoundValue: AnimationControllerValue(pixel: 187),
      upperBoundValue: AnimationControllerValue(percentage: 1),

      duration: Duration(milliseconds: 300),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RubberBottomSheet(
      scrollController: _scrollController,
      animationController: _controller,
      lowerLayer: widget.lowerLayer,
      upperLayer: SingleChildScrollView(
          controller: _scrollController, child: widget.upperLayer),
      headerHeight: 50 + MediaQuery.of(context).padding.top,
      header: Transform.translate(
        offset: Offset(0,  MediaQuery.of(context).padding.top),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.red,
        ),
      ),
    );
  }
}
