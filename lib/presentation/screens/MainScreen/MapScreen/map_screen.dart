import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.state.dart';
import 'package:lseway/presentation/screens/MainScreen/BookingWrapper/booking_wrapper.dart';
import 'package:lseway/presentation/widgets/Booking/booking.dart';
import 'package:lseway/presentation/widgets/CustomDrawer/custom_drawer.dart';
import 'package:lseway/presentation/widgets/Main/Map/map.dart';
import 'package:lseway/presentation/widgets/SplashScreen/splash_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool showSplash = true;
  bool showMap = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        showSplash = false;
      });
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        showMap = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: const Drawer(
          child: CustomDrawer(),
        ),
      ),
      body: Stack(
        children: [
          showMap
              ? BlocBuilder<BookingBloc, BookingState>(
                  builder: (context, state) {
                  return BookingWrapper(
                    booking: state.booking,
                    
                  );
                })
              : SizedBox(),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: showSplash ? const SplashScreen() : SizedBox(),
          )
        ],
      ),
    );
  }
}
