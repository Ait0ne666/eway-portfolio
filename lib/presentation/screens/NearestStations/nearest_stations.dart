import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lseway/presentation/bloc/nearestPoints/nearest_points.bloc.dart';
import 'package:lseway/presentation/bloc/nearestPoints/nearest_points.event.dart';
import 'package:lseway/presentation/bloc/nearestPoints/nearest_points.state.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';
import 'package:lseway/presentation/widgets/Main/Map/geolocation.dart';
import '../../../injection_container.dart' as di;

class NearestStations extends StatefulWidget {
  const NearestStations({Key? key}) : super(key: key);

  @override
  _NearestStationsState createState() => _NearestStationsState();
}

class _NearestStationsState extends State<NearestStations> {
  @override
  void initState() {
    loadPoints();
    super.initState();
  }

  void loadPoints() async {
    var geolocatorService = di.sl<GeolocatorService>();
    try {
      var coords = await geolocatorService.determinePosition();
      BlocProvider.of<NearestPointsBloc>(context).add(
        LoadNearestPoints(
          coords: LatLng(coords.latitude, coords.longitude),
        ),
      );
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF0F1F6),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: MediaQuery.of(context).viewPadding.top + 30),
        child: Column(
          children: [
            const CustomProfileBar(
              title: 'Станции поблизости',
              isCentered: true,
            ),
            const SizedBox(
              height: 52,
            ),
            BlocBuilder<NearestPointsBloc, NearestPointsState>(
                builder: (context, state) {
              var points = state.points;
              if (state.points.isEmpty) {
                return Text(
                  'Нет точек поблизости',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                );
              } else {
                return Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.points.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 18,
                      );
                    },
                    itemBuilder: (context, index) {
                      var point = points[index];
                      return InkWell(
                        onTap: () {
                          AppRouter.router.pop(context);
                          BlocProvider.of<PointInfoBloc>(context).add(
                            ShowPoint(pointId: point.pointId),
                          );
                        },
                        child: Container(
                          height: 68,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
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
                                point.address,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(fontSize: 17),
                              ),
                              Row(
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
                                    point.distance.toString() + ' км',
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
                                    point.time.inMinutes.toString() + ' мин',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(fontSize: 16),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
