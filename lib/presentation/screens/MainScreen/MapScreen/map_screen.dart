import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.event.dart';
import 'package:lseway/presentation/bloc/booking/booking.state.dart';
import 'package:lseway/presentation/bloc/history/history.bloc.dart';
import 'package:lseway/presentation/bloc/history/history.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/bloc/points/points.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.event.dart';
import 'package:lseway/presentation/screens/MainScreen/BookingWrapper/booking_wrapper.dart';
import 'package:lseway/presentation/widgets/Booking/booking.dart';
import 'package:lseway/presentation/widgets/CustomDrawer/custom_drawer.dart';
import 'package:lseway/presentation/widgets/EmailConfirmDialog/email_confirm_dialog.dart';
import 'package:lseway/presentation/widgets/Main/Map/map.dart';
import 'package:lseway/presentation/widgets/SplashScreen/splash_screen.dart';
import 'package:lseway/utils/ImageService/image_service.dart';
import '../../../../injection_container.dart' as di;

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
    
    removeSplash();

  }



  void removeSplash() async {
    var imageService = di.sl<ImageService>();

    await imageService.init();

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

    Future.delayed(const Duration(milliseconds: 1800), showConfirmEmailDialog);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showConfirmEmailDialog() {
    shouldShowConfrimEmail(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      drawer: Container(
        constraints: BoxConstraints(maxWidth: 380),
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
                    print('booking');
                  print(state.booking);
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
