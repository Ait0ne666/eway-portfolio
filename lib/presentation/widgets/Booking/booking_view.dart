import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/core/dialogBuilder/dialogBuilder.dart';
import 'package:lseway/core/painter/timer_painter.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/domain/entitites/booking/booking.entity.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/presentation/bloc/activePoints/active_points_bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.event.dart';
import 'package:lseway/presentation/bloc/booking/booking.state.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';
import 'package:lseway/presentation/bloc/charge/charge.state.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Core/GreenContainer/green_container.dart';
import 'package:lseway/presentation/widgets/Core/LabeledBox/labeled_box.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/PrepareToChargeDialog/prepare_to_charge_dialog.dart';
import 'package:lseway/presentation/widgets/Main/Map/geolocation.dart';
import 'package:lseway/utils/utils.dart';
import 'package:map_launcher/map_launcher.dart';
import '../../../injection_container.dart' as di;

class BookingView extends StatefulWidget {
  final double padding;
  final Booking? booking;
  final void Function() hideBooking;
  const BookingView(
      {Key? key,
      required this.booking,
      required this.padding,
      required this.hideBooking})
      : super(key: key);

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  Timer? timer;
  late GeolocatorService geolocatorService;
  int? timeLeft;
  late Booking? booking;

  @override
  void initState() {
    geolocatorService = di.sl<GeolocatorService>();
    booking = widget.booking;
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    updateTimer();
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      updateTimer();
    });
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (oldWidget.booking != widget.booking && widget.booking != null) {
      setState(() {
        booking = widget.booking;
      });
      updateTimer();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  void updateTimer() {
    if (widget.booking != null) {
      var bookingEnd = widget.booking!.time;
      var currentTime = DateTime.now();
      var start = widget.booking!.createdAt;

      var total = bookingEnd.difference(start).inMinutes;
      var gone = currentTime.difference(start).inMinutes;

      var percent = 1 - gone / total;
      _controller.animateTo(percent);
      setState(() {
        timeLeft = total - gone > 0 ? total - gone : 0;
      });
      if (currentTime.isAfter(bookingEnd)) {
        timer?.cancel();
        BlocProvider.of<BookingBloc>(context).add(ClearBooking());
      }
    } else {
      timer?.cancel();
    }
  }

  void handleBooking(BuildContext context) {
    if (booking != null) {
      BlocProvider.of<BookingBloc>(context)
          .add(CancelBooking(pointId: booking!.pointId));
    }
  }

  void buildRoute(BuildContext context, Coords destination) {
    geolocatorService.determinePosition().then((value) {
      Coords coords = Coords(value.latitude, value.longitude);
      openMapsSheet(context, coords, destination);
    }).catchError((err) {
      print(err);
    });
  }

  openMapsSheet(BuildContext context, Coords coords, Coords destination) async {
    try {
      final title = "Маршрут";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showDirections(
                            destination: destination, origin: coords),
                        title: Text(
                          map.mapName,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void charge(BuildContext context) {
    if (booking != null) {
      BlocProvider.of<ChargeBloc>(context).add(StartCharge(
          pointId: booking!.pointId, connector: booking!.connector.id));
    }
  }

  void chargeListener(BuildContext context, ChargeState state) {
    var dialog = DialogBuilder();
    var isVisible = TickerMode.of(context);



    if (state is ChargeConnectingState) {
      if (BlocProvider.of<ActivePointsBloc>(context).reservedPoint == null ||
          state.progress?.pointId ==
              BlocProvider.of<ActivePointsBloc>(context).reservedPoint) return;


      if (isVisible) {
        widget.hideBooking();
        showPreparationDialog(widget.booking!.pointId,
            (BuildContext ctx, bool shouldDismiss) {
          BlocProvider.of<PointInfoBloc>(ctx)
              .add(ShowPoint(pointId: booking!.pointId));
        });
      }
    } else if (state is ChargeStartedState) {
      BlocProvider.of<BookingBloc>(context).add(ClearBooking());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      padding: EdgeInsets.only(left: 20, right: 20, top: widget.padding),
      child: Stack(
        children: [
          Container(
            child: Column(
              children: [
                MultiBlocListener(listeners: [
                  BlocListener<ChargeBloc, ChargeState>(
                      listener: chargeListener),
                ], child: const SizedBox()),
                Container(
                  height: 101,
                  width: MediaQuery.of(context).size.width - 40,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffECEDF2)),
                        width: 34,
                        height: 4,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomPaint(
                            painter: TimerPainter(
                                currentPercent: animation,
                                stroke: 7,
                                innerStroke: 2),
                            child: Container(
                              width: 56,
                              height: 56,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (timeLeft ?? 0).toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(fontSize: 16, height: 1),
                                  ),
                                  Text('мин',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                              color: const Color(0xffB6B8C2),
                                              fontSize: 13,
                                              height: 1)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                                'Ваша зарядная станция ждет вас, по истечении времени бронь отменится',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        color: const Color(0xffB6B8C2),
                                        fontSize: 15)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  height: 556,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(
                              152,
                              156,
                              160,
                              0.5,
                            ),
                            blurRadius: 100,
                            offset: Offset(20, 30))
                      ]),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 30, top: 45),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width - 80),
                                child: FractionallySizedBox(
                                  widthFactor: 0.6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            '№',
                                            style: TextStyle(
                                                color: Color(0xffFF4147),
                                                fontSize: 15,
                                                fontFamily: 'URWGeometricExt'),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            booking == null
                                                ? ''
                                                : booking!.pointId.toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Benzin',
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 1
                                                ..color = Color(0xffFF4147),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Зарядка',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      booking != null &&
                                              isCurrentTariffFixed(
                                                  booking!.tariffs)
                                          ? Stack(
                                              children: [
                                                GreenContainer(
                                                  borderRadius: 15,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20,
                                                            left: 20,
                                                            right: 20,
                                                            bottom: 12),
                                                    child: FittedBox(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                booking == null
                                                                    ? ''
                                                                    : (getCurrentPriceFromTariffs(booking!
                                                                            .tariffs))
                                                                        .toString()
                                                                        .replaceAll(
                                                                            '.',
                                                                            ','),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText2
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            25,
                                                                        height:
                                                                            1.1),
                                                              ),
                                                              const Text('₽',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'Circe')),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 5,
                                                  top: 5,
                                                  child: Tooltip(
                                                      message:
                                                          'Фиксированная цена за одну зарядку',
                                                      triggerMode:
                                                          TooltipTriggerMode
                                                              .tap,
                                                      verticalOffset: 0,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.topRight,
                                                        width: 80,
                                                        height: 40,
                                                        child: const Icon(
                                                          Icons
                                                              .info_outline_rounded,
                                                          size: 20,
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : GreenContainer(
                                              borderRadius: 15,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 20,
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 12),
                                                child: FittedBox(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            booking == null
                                                                ? ''
                                                                : (getCurrentPriceFromTariffs(
                                                                        booking!
                                                                            .tariffs))
                                                                    .toString()
                                                                    .replaceAll(
                                                                        '.',
                                                                        ','),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText2
                                                                ?.copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        25,
                                                                    height:
                                                                        1.1),
                                                          ),
                                                          const Text('₽',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Circe')),
                                                        ],
                                                      ),
                                                      const Text(
                                                        '/ 1 кВт',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffA8FFA7),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontFamily:
                                                                'Circe'),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: LabeledBox(
                                    label: 'Мощность',
                                    // width: (MediaQuery.of(context).size.width - 94) / 2,
                                    paddingRight: 5,
                                    text: Text(
                                      booking == null
                                          ? ''
                                          : mapVoltageToString(
                                              booking!.voltage),
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    icon: Image.asset(
                                      'assets/bolt.png',
                                      width: 82 / 3,
                                      height: 95 / 3,
                                    )),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                flex: 1,
                                child: LabeledBox(
                                  label: 'Тип разъема',
                                  // width: (MediaQuery.of(context).size.width - 94) / 2,
                                  paddingRight: 5,
                                  text: Text(
                                    booking == null
                                        ? ''
                                        : mapConnectorTypesToString(
                                            booking!.connector.type),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  icon: Image.asset(
                                    'assets/fork.png',
                                    width: 82 / 3,
                                    height: 95 / 3,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomButton(
                            text: 'Начать зарядку',
                            onPress: () => charge(context),
                            type: ButtonTypes.PRIMARY,
                            icon: SvgPicture.asset('assets/QR.svg'),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomButton(
                            text: 'Проложить маршрут',
                            onPress: booking == null
                                ? () {}
                                : () => buildRoute(
                                    context,
                                    Coords(
                                        booking!.latitude, booking!.longitude)),
                            type: ButtonTypes.SECONDARY,
                            icon: SvgPicture.asset('assets/route.svg'),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomButton(
                            text: 'Отменить бронирование',
                            onPress: () => handleBooking(context),
                            type: ButtonTypes.SECONDARY,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 23),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(
                              152,
                              156,
                              160,
                              0.5,
                            ),
                            blurRadius: 100,
                            offset: Offset(20, 30))
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/direction-grey.svg'),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 140,
                            child: Text(
                              booking == null ? '' : booking!.address,
                              style: const TextStyle(
                                  color: Color(0xff1A1D21),
                                  fontSize: 15,
                                  fontFamily: 'Circe'),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset('assets/timer-grey.svg'),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            booking == null ? '' : timeFromNow(booking!.time),
                            style: const TextStyle(
                                color: Color(0xff1A1D21),
                                fontSize: 15,
                                fontFamily: 'Circe'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          Positioned(
            child: Center(
              child: Image.asset('assets/point.png',
                  height: 1335 / 3.5, width: 876 / 3.5),
            ),
            top: 20,
            right: 0,
          ),
        ],
      ),
    );
  }
}
