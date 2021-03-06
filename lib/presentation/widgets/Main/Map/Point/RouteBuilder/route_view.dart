import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:lseway/domain/entitites/coordinates/coordinates.dart';
import 'package:lseway/domain/entitites/point/distance.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';
import 'package:lseway/domain/use-cases/points/points.use_case.dart';
import 'package:lseway/presentation/widgets/Main/Map/geolocation.dart';
import '../../../../../../injection_container.dart' as di;

class RouteView extends StatefulWidget {
  final PointInfo info;
  const RouteView({Key? key, required this.info}) : super(key: key);

  @override
  _RouteViewState createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  late GeolocatorService geolocatorService;
  late PointsUseCase usecase;
  TravelDistance? _travelDistance;
  late StreamSubscription<Position> positionSubscription;
  Position? lastPosition;

  @override
  void initState() {
    geolocatorService = di.sl<GeolocatorService>();
    usecase = di.sl<PointsUseCase>();
    _travelDistance = usecase.getExistingDistance(widget.info.point.id);

    super.initState();
    fetchDistance();
    lastPosition = geolocatorService.myLastPosition;
    positionSubscription =
        geolocatorService.getPositionStream().listen(positionListener);
  }

  @override
  void dispose() {
    positionSubscription.cancel();
    super.dispose();
  }

  void positionListener(Position position) {
    if (lastPosition != null) {
      var traveledDistance = Geolocator.distanceBetween(position.latitude,
          position.longitude, lastPosition!.latitude, lastPosition!.longitude);
      if (traveledDistance > 250) {
        lastPosition = position;
        fetchDistance();
      }
    }
  }

  void fetchDistance() async {
    var lastLocation = geolocatorService.getMyLastPosition;

    if (lastLocation != null) {
      var travelDistance = await usecase.getTravelDistance(
          Coordinates(lat: lastLocation.latitude, long: lastLocation.longitude),
          Coordinates(
            lat: widget.info.point.latitude,
            long: widget.info.point.longitude,
          ),
          widget.info.point.id);
      if (travelDistance != null) {
        if (this.mounted) {
          setState(() {
            _travelDistance = travelDistance;
          });
        }
      }
    }
  }

  String getTravelDistanceString(int distance) {
    if (distance > 1000) {
      return (distance ~/ 1000).toInt().toString() + ' ????';
    } else {
      return distance.toString() + ' ??';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 68,
      constraints: const BoxConstraints(minHeight: 68),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(15, 20),
              blurRadius: 100,
              color: Color.fromRGBO(205, 205, 218, 0.6),
            )
          ],
          borderRadius: BorderRadius.circular(13)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.info.point.address,
            style:
                Theme.of(context).textTheme.headline4?.copyWith(fontSize: 17),
          ),

          // SizedBox(
          //   height: _travelDistance != null ? 3 : 0,
          // ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 150),
            transitionBuilder: (child, animation) {
              return SizeTransition(
                sizeFactor: animation,
                axis: Axis.vertical,
                child: FadeTransition(
                  opacity: animation,
                  child: child),
              );
            },
            child: _travelDistance != null
                ? Row(
                    children: [
                      Image.asset(
                        'assets/directionRed.png',
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        getTravelDistanceString(_travelDistance!.distance),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xffF21D24)),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: const Color(0xffB6B8C2)),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        _travelDistance!.time.inMinutes.toString() + ' ??????',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(fontSize: 16),
                      )
                    ],
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}
