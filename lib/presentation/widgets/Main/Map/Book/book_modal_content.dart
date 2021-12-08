import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';
import 'package:lseway/presentation/bloc/booking/booking.bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.event.dart';
import 'package:lseway/presentation/bloc/booking/booking.state.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/widgets/ConfirmationDialog/confirmation_dialog.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Core/GreenContainer/green_container.dart';
import 'package:lseway/presentation/widgets/Core/WheelDatePicker/wheel_date_picker.dart';
import 'package:lseway/presentation/widgets/IconButton/icon_button.dart';
import 'package:lseway/presentation/widgets/global.dart';
import 'package:lseway/utils/utils.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showSuccessDialog(Booking booking) {
  var globalContext = NavigationService.navigatorKey.currentContext;

  if (globalContext != null) {
    showMaterialModalBottomSheet(
        context: globalContext,
        barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
        backgroundColor: Colors.transparent,
        useRootNavigator: true,
        builder: (dialogContext) {
          return ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(dialogContext).size.height),
            child: GestureDetector(
              onTap: () {
                Navigator.of(dialogContext).pop();
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: MediaQuery.of(dialogContext).size.height,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 407,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                  height: 407,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white),
                                  child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                            left: 39,
                                            right: 39,
                                            top: 83,
                                            bottom: 50),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Станция забронирована',
                                              style: Theme.of(dialogContext)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(fontSize: 28),
                                            ),
                                            const SizedBox(
                                              height: 27,
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/arrow-red.svg'),
                                                const SizedBox(
                                                  width: 13,
                                                ),
                                                Text(
                                                  booking.address,
                                                  style: const TextStyle(
                                                      color: Color(0xffB6B8C2),
                                                      fontSize: 20,
                                                      fontFamily: 'Circe'),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 13,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/timer-red.svg'),
                                                const SizedBox(
                                                  width: 13,
                                                ),
                                                Text(
                                                  timeFromNow(booking.time),
                                                  style: const TextStyle(
                                                      color: Color(0xffB6B8C2),
                                                      fontSize: 20,
                                                      fontFamily: 'Circe'),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 37,
                                            ),
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 225),
                                              child: CustomButton(
                                                onPress: () {
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                },
                                                text: 'Отлично',
                                                postfix: SvgPicture.asset(
                                                    'assets/chevron-red.svg'),
                                                sharpAngle: true,
                                              ),
                                            )
                                          ],
                                        ),
                                      ))),
                            ),
                            Positioned(
                              top: (MediaQuery.of(dialogContext).size.height -
                                          407) /
                                      2 -
                                  50,
                              left: ((MediaQuery.of(dialogContext).size.width -
                                          40) /
                                      2 -
                                  50),
                              child: GreenContainer(
                                  borderRadius: 50,
                                  child: Container(
                                    width: 99,
                                    height: 99,
                                    child: Center(
                                      child: SvgPicture.asset(
                                          'assets/check-white.svg'),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class BookModalContent extends StatefulWidget {
  final int pointId;
  final int connector;
  const BookModalContent(
      {Key? key, required this.pointId, required this.connector})
      : super(key: key);

  @override
  _BookModalContentState createState() => _BookModalContentState();
}

class _BookModalContentState extends State<BookModalContent> {
  DateTime? selectedTime;
  List<DateTime> availableDates = [];

  @override
  void initState() {
    List<DateTime> busyDates = [
      // DateTime(2021, 11, 4, 19, 45),
      // DateTime(2021, 11, 4, 22, 30),
    ];

    var newAvailableDates = getAvailableDates(busyDates);

    setState(() {
      availableDates = newAvailableDates;
    });

    super.initState();
  }

  List<DateTime> getAvailableDates(List<DateTime> busyDates) {
    List<DateTime> result = [];
    // var currentTime = DateTime.now().subtract(Duration(minutes: 5)).add(const Duration(minutes: 15));
    // var minute = currentTime.minute;
    // Duration thresholdDuration = const Duration(hours: 1);

    // if (minute < 15) {
    //   minute = 15;
    // } else if (minute < 30) {
    //   minute = 30;
    // } else if (minute < 45) {
    //   minute = 45;
    // } else {
    //   currentTime = currentTime.add(const Duration(hours: 1));
    //   minute = 0;
    // }

    // var newTime = DateTime(currentTime.year, currentTime.month, currentTime.day,
    //     currentTime.hour, minute);

    // var time = newTime;
    // var threshold = currentTime.add(thresholdDuration);

    // while (time.isBefore(threshold)) {
    //   var isTaken = false;

    //   for (var i = 0; i < busyDates.length; i++) {
    //     var diff = time.difference(busyDates[i]).inMinutes;
    //     if (diff < 60 && diff > -60) {
    //       isTaken = true;
    //       break;
    //     }
    //   }

    //   if (!isTaken) {
    //     result.add(time);
    //   }

    //   time = time.add(
    //     const Duration(minutes: 15),
    //   );
    // }
    var currentTime = DateTime.now();
    result.add(currentTime.add(const Duration(minutes: 15)));
    result.add(currentTime.add(const Duration(minutes: 30)));
    result.add(currentTime.add(const Duration(minutes: 45)));
    result.add(currentTime.add(const Duration(minutes: 60)));


    if (result.isNotEmpty) {
      setState(() {
        selectedTime = result[0];
      });
    }

    return result;
  }

  void onGoBack() {
    Navigator.of(context).pop();
    BlocProvider.of<PointInfoBloc>(context).add(
      ShowPoint(pointId: widget.pointId),
    );
  }

  // Future<bool> onWillPop() async {
  //   onGoBack();
  //   return false;
  // }

  void onDateChange(DateTime newDate) {
    setState(() {
      selectedTime = newDate;
    });
  }

  void handleBooking() {
    if (selectedTime != null) {
      var existingBooking = BlocProvider.of<BookingBloc>(context).state.booking;

      if (existingBooking != null) {
        showConfirmationModal(() {
          Navigator.of(context, rootNavigator: true).pop();
          BlocProvider.of<BookingBloc>(context).add(BookPoint(
              connector: widget.connector,
              time: selectedTime!,
              pointId: widget.pointId));
        }, () {
          Navigator.of(context, rootNavigator: true).pop();
        }, ['Предыдущая бронь будет отменена'], 'Продолжить?');
      } else {
        BlocProvider.of<BookingBloc>(context).add(BookPoint(
            connector: widget.connector,
            time: selectedTime!,
            pointId: widget.pointId));
      }
    }
  }

  void onBookingSuccess(Booking booking) {
    Navigator.of(context).pop();
    showSuccessDialog(booking);
  }

  void bookingsListener(BuildContext context, BookingState state) {
    var dialog = DialogBuilder();
    var isVisible = TickerMode.of(context);

    if (state is BookingInProgress) {
      dialog.showLoadingDialog(
        context,
      );
    } else if (state is BookingErrorState) {
      Navigator.of(context, rootNavigator: true).pop();
      Toast.showToast(context, state.message);
    } else if (state is BookingMadeState) {
      Navigator.of(context, rootNavigator: true).pop();

      onBookingSuccess(state.booking!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 35, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocListener<BookingBloc, BookingState>(
            listener: bookingsListener,
            child: SizedBox(),
          ),
          CustomIconButton(
              icon: SvgPicture.asset('assets/arrow-left.svg'), onTap: onGoBack),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Бронирование станции',
            style:
                Theme.of(context).textTheme.headline5?.copyWith(fontSize: 22),
          ),
          const SizedBox(
            height: 22,
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: GreenContainer(
                    borderRadius: 20,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 18, right: 5, bottom: 13, top: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '120',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 25,
                                        height: 1.1),
                              ),
                              const Text('₽',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontFamily: 'Circe')),
                            ],
                          ),
                          const Text(
                            'Стоимость брони',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffC8FFCF),
                                fontFamily: 'Circe'),
                          )
                        ],
                      ),
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 18, right: 0, bottom: 13, top: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/timer-green.svg'),
                            const SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                  text: '1',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontSize: 22),
                                ),
                                TextSpan(
                                  text: 'час',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontSize: 18),
                                )
                              ])),
                            )
                          ],
                        ),
                        const FittedBox(
                          child: Text(
                            'Max интервал времени',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffB6B8C2),
                                fontFamily: 'Circe'),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: 27,
          ),
          WheelDatePicker(
            dates: availableDates,
            onDateChange: onDateChange,
            currentValue: selectedTime,
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 249),
              child: CustomButton(
                onPress: handleBooking,
                text: 'Забронировать',
                postfix: SvgPicture.asset('assets/chevron-red.svg'),
                sharpAngle: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
