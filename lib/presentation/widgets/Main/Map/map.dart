import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lseway/domain/entitites/coordinates/coordinates.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';
import 'package:lseway/presentation/bloc/activePoints/active_point_event.dart';
import 'package:lseway/presentation/bloc/activePoints/active_point_state.dart';
import 'package:lseway/presentation/bloc/activePoints/active_points_bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.event.dart';
import 'package:lseway/presentation/bloc/history/history.bloc.dart';
import 'package:lseway/presentation/bloc/history/history.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.state.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.event.dart';
import 'package:lseway/presentation/bloc/points/points.state.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/widgets/AppBar/app_bar.dart';
import 'package:lseway/presentation/widgets/IconButton/icon_button.dart';
import 'package:lseway/presentation/widgets/Main/Map/Map/map.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/Charge/timer.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/point.dart';
import 'package:lseway/presentation/widgets/Main/Map/geolocation.dart';
import 'package:lseway/presentation/widgets/QrScanner/qr_scanner.dart';
import 'package:lseway/utils/ImageService/image_service.dart';
import '../../../../injection_container.dart' as di;
import 'package:permission_handler/permission_handler.dart' as Permission;

class Place with ClusterItem {
  final Point point;

  Place({required this.point});

  @override
  LatLng get location => LatLng(point.latitude, point.longitude);
}

class MapView extends StatefulWidget {
  final void Function() showBooking;
  const MapView({Key? key, required this.showBooking}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

Set<Marker> constantAmarkers = {};
Timer? timer;
Timer? updateTimer;
DateTime? lastUpdate;

class _MapViewState extends State<MapView> with WidgetsBindingObserver {
  final ValueNotifier<Set<Marker>?> _myLocationMarkerNotifier =
      ValueNotifier<Set<Marker>?>(null);
  Completer<GoogleMapController> _controller = Completer();
  GlobalKey<AnimarkerState> animarkerKey = GlobalKey<AnimarkerState>();
  late Stream<ServiceStatus> serviceStatusStream;
  StreamSubscription<ServiceStatus>? serviceListener;
  Coordinates defaultCoordinates = Coordinates(lat: 55.751244, long: 37.618423);
  BitmapDescriptor? activeIcon;
  BitmapDescriptor? inActiveIcon;
  BitmapDescriptor? activeFarIcon;
  BitmapDescriptor? inActiveFarIcon;
  BitmapDescriptor? myLocationIcon;
  BitmapDescriptor? selectedIcon;
  Set<Marker> markers = {};
  late GeolocatorService geolocatorService;
  late ImageService imageService;
  late ClusterManager _clusterManager;
  bool _showMyLocation = false;
  bool _showMap = true;
  Position? myPosition;
  late StreamSubscription<Position> myPositionStream;
  Set<Marker> myLocationMarker = {};
  double zoom = 15;

  late CameraPosition _kGooglePlex;

  void toggleMap() {
    setState(() {
      _showMap = !_showMap;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == ui.AppLifecycleState.resumed) {
      var controller = await _controller.future;
      controller.setMapStyle("[]");
    }
    if (state == ui.AppLifecycleState.resumed && !_showMyLocation) {
      var permissionStatus = Permission.Permission.locationWhenInUse.status;

      permissionStatus.isGranted.then((value) {
        if (value) {
          setState(() {
            _showMyLocation = true;
          });
          myPositionStream.cancel();
          myPositionStream =
              geolocatorService.getPositionStream().listen(myLocationListener);
        }
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    geolocatorService = di.sl<GeolocatorService>();
    imageService = di.sl<ImageService>();
    _kGooglePlex = geolocatorService.getLastKnownPosition();
    _clusterManager = initClusterManager();
    var permissionStatus = Permission.Permission.locationWhenInUse.status;

    permissionStatus.isGranted.then((value) {
      if (value) {
        setState(() {
          _showMyLocation = true;
        });
      }
    });

    serviceStatusStream = Geolocator.getServiceStatusStream();
    serviceListener = serviceStatusStream.listen((status) {
      if (status == ServiceStatus.enabled) {
        getCurrentPosition(true);
        var permissionStatus = Permission.Permission.locationWhenInUse.status;

        permissionStatus.isGranted.then((value) {
          if (value) {
            setState(() {
              _showMyLocation = true;
            });
            myPositionStream.cancel();
            myPositionStream = geolocatorService
                .getPositionStream()
                .listen(myLocationListener);
          }
        });
      }
    });

    super.initState();
    geolocatorService.determinePosition().then((position) async {
      final GoogleMapController controller = await _controller.future;

      var zoom = await controller.getZoomLevel();

      var newPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: zoom);

      geolocatorService.saveCameraPosition(newPosition);

      controller
          .animateCamera(CameraUpdate.newCameraPosition(newPosition))
          .then((value) async {
        var bounds = await controller.getVisibleRegion();
        var range = Geolocator.distanceBetween(
            bounds.northeast.latitude,
            bounds.northeast.longitude,
            bounds.southwest.latitude,
            bounds.southwest.longitude);
        BlocProvider.of<PointsBloc>(context).add(LoadInitialPoints(
            gps: Coordinates(lat: position.latitude, long: position.longitude),
            range: range));
      });
    }).catchError((err) async {
      if (err == 'enableLocation') {
        // geolocatorService.showLocationDialog(context);

        final GoogleMapController controller = await _controller.future;
        var bounds = await controller.getVisibleRegion();
        var range = Geolocator.distanceBetween(
            bounds.northeast.latitude,
            bounds.northeast.longitude,
            bounds.southwest.latitude,
            bounds.southwest.longitude);
        BlocProvider.of<PointsBloc>(context).add(LoadInitialPoints(
            gps: Coordinates(
                lat:
                    (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
                long:
                    (bounds.northeast.longitude + bounds.southwest.longitude) /
                        2),
            range: range));
      }
    });
    myPositionStream =
        geolocatorService.getPositionStream().listen(myLocationListener);

    loadData();
    setupPointUpdate();
  }

  void loadData() {
    BlocProvider.of<PointsBloc>(context).add(FetchChargingPoint());
    BlocProvider.of<BookingBloc>(context).add(CheckBookings());
    BlocProvider.of<PaymentBloc>(context).add(FetchCards());
    BlocProvider.of<HistoryBloc>(context).add(FetchHistory());
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    myPositionStream.cancel();
    // geolocatorService.stopBackgroundLocation();
    timer?.cancel();
    updateTimer?.cancel();
    super.dispose();
  }

  void setupPointUpdate() {
    updateTimer = Timer.periodic(Duration(milliseconds: 30000), (timer) {
      if (lastUpdate != null) {
        var time = DateTime.now();
        if (time.difference(lastUpdate!).inSeconds > 10) {
          loadMorePoints();
          lastUpdate = time;
        }
      }
    });
  }

  ClusterManager initClusterManager() {
    return ClusterManager<Place>([], (Set<Marker> marks) {
      setState(() {
        markers = constantAmarkers;
      });
      constantAmarkers = {};
    },
        clusterAlgorithm: ClusterAlgorithm.MAX_DIST,
        maxDistParams: MaxDistParams(3),
        stopClusteringZoom: 15,
        markerBuilder: _markerBuilder,
        extraPercent: 1.5);
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        var camera = geolocatorService.getLastKnownPosition();
        var reservedPoint =
            BlocProvider.of<ActivePointsBloc>(context).state.reservedPoint;
        var chargingPoint =
            BlocProvider.of<ActivePointsBloc>(context).state.chargingPoint;

        if (!cluster.isMultiple) {
          constantAmarkers.add(
            Marker(
              markerId: MarkerId(
                cluster.items.toList()[0].point.id.toString(),
              ),
              position: cluster.location,
              icon: getImageForSingularCluster(cluster.items.toList()[0].point,
                  reservedPoint: reservedPoint, chargingPoint: chargingPoint),
              anchor: (reservedPoint == cluster.items.toList()[0].point.id ||
                      chargingPoint == cluster.items.toList()[0].point.id)
                  ? const Offset(0.5, 0.7)
                  : const Offset(0.5, 0.4),
              onTap: () =>
                  onMarkerClick(context, cluster.items.toList()[0].point.id),
            ),
          );
        }

        return cluster.isMultiple
            ? getMarkerForMultiplePoints(cluster)
            : Marker(
                markerId: MarkerId(
                  cluster.items.toList()[0].point.id.toString(),
                ),
                position: cluster.location,
                icon: getImageForSingularCluster(
                    cluster.items.toList()[0].point,
                    reservedPoint: reservedPoint,
                    chargingPoint: chargingPoint),
                anchor: (reservedPoint == cluster.items.toList()[0].point.id ||
                        chargingPoint == cluster.items.toList()[0].point.id)
                    ? const Offset(0.5, 0.7)
                    : const Offset(0.5, 0.4),
                onTap: () =>
                    onMarkerClick(context, cluster.items.toList()[0].point.id));
      };

  Marker getMarkerForMultiplePoints(Cluster<Place> places) {
    bool available = false;
    bool up = false;

    places.items.toList().forEach((place) {
      if (place.point.up) {
        up = true;
      }
      if (place.point.availability) {
        available = true;
      }
    });

    places.items.toList().asMap().forEach((index, place) => {
          constantAmarkers.add(Marker(
            markerId: MarkerId(
              place.point.id.toString(),
            ),
            position: places.location,
            icon: getImageForCluster(available, up),
            anchor: const Offset(0.5, 0.7),
            // visible: index == 0
          ))
        });

    return Marker(
      markerId: MarkerId(
        places.items.toList()[0].point.id.toString(),
      ),
      position: places.location,
      icon: getImageForCluster(available, up),
      anchor: const Offset(0.5, 0.7),
    );
  }

  void getCurrentPosition(bool initial) {
    geolocatorService.determinePosition().then((position) async {
      final GoogleMapController controller = await _controller.future;
      var zoom = await controller.getZoomLevel();

      var newPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: zoom);

      geolocatorService.saveCameraPosition(newPosition);

      controller
          .animateCamera(CameraUpdate.newCameraPosition(newPosition))
          .then((value) async {
        var bounds = await controller.getVisibleRegion();
        var range = Geolocator.distanceBetween(
            bounds.northeast.latitude,
            bounds.northeast.longitude,
            bounds.southwest.latitude,
            bounds.southwest.longitude);

        if (initial) {
          BlocProvider.of<PointsBloc>(context).add(LoadInitialPoints(
              gps:
                  Coordinates(lat: position.latitude, long: position.longitude),
              range: range));
        } else {
          BlocProvider.of<PointsBloc>(context).add(LoadMorePoints(
              gps:
                  Coordinates(lat: position.latitude, long: position.longitude),
              range: range));
        }
        lastUpdate = DateTime.now();
      });
    }).catchError((err) async {
      if (err == 'enableLocation') {
        geolocatorService.showLocationDialog(context);
      }
    });
  }

  void onCameraMove(CameraPosition position) async {
    var camera = geolocatorService.getLastKnownPosition();
    // setState(() {
    //   zoom = position.zoom;
    // });
    final GoogleMapController controller = await _controller.future;
    var bounds = await controller.getVisibleRegion();
    var range = Geolocator.distanceBetween(
        bounds.northeast.latitude,
        bounds.northeast.longitude,
        bounds.southwest.latitude,
        bounds.southwest.longitude);
    BlocProvider.of<PointsBloc>(context).add(LoadMorePoints(
        gps: Coordinates(
            lat: position.target.latitude, long: position.target.longitude),
        range: range));
    geolocatorService.saveCameraPosition(position);
    lastUpdate = DateTime.now();
    if ((camera.zoom < 13 && position.zoom >= 13) ||
        (camera.zoom > 13 && position.zoom <= 13)) {
      var points = BlocProvider.of<PointsBloc>(context).state.points;

      _buildMarkersSet(points);
    }
  }

  void loadMorePoints() async {
    final GoogleMapController controller = await _controller.future;

    var bounds = await controller.getVisibleRegion();
    var range = Geolocator.distanceBetween(
        bounds.northeast.latitude,
        bounds.northeast.longitude,
        bounds.southwest.latitude,
        bounds.southwest.longitude);

    BlocProvider.of<PointsBloc>(context).add(LoadMorePoints(
        gps: Coordinates(
            lat: (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
            long:
                (bounds.northeast.longitude + bounds.southwest.longitude) / 2),
        range: range));
    lastUpdate = DateTime.now();
  }

  BitmapDescriptor getImageForPoint(Point point, CameraPosition camera,
      {int? reservedPoint, int? chargingPoint}) {
    var imageTitle = (reservedPoint == point.id || chargingPoint == point.id)
        ? 'icons/active' + mapVoltageToNumber(point.voltage!).toString()
        : point.up
            ? point.availability
                ? camera.zoom < 13
                    ? 'active_far'
                    : 'icons/free' +
                        mapVoltageToNumber(point.voltage!).toString()
                : camera.zoom < 13
                    ? 'inactive_far'
                    : 'icons/busy' +
                        mapVoltageToNumber(point.voltage!).toString()
            : camera.zoom < 13
                ? 'down_far'
                : 'icons/inactive' +
                    mapVoltageToNumber(point.voltage!).toString();

    return imageService.getDescriptor(imageTitle)!;
  }

  BitmapDescriptor getImageForSingularCluster(Point point,
      {int? reservedPoint, int? chargingPoint}) {
    var imageTitle = (reservedPoint == point.id || chargingPoint == point.id)
        ? 'icons/active' +
            mapVoltageToNumber(point.voltage ?? VoltageTypes.AC7).toString()
        : point.up
            ? point.availability
                ? 'icons/free' +
                    mapVoltageToNumber(point.voltage ?? VoltageTypes.AC7)
                        .toString()
                : 'icons/busy' +
                    mapVoltageToNumber(point.voltage ?? VoltageTypes.AC7)
                        .toString()
            : 'icons/inactive' +
                mapVoltageToNumber(point.voltage ?? VoltageTypes.AC7)
                    .toString();

    return imageService.getDescriptor(imageTitle)!;
  }

  BitmapDescriptor getImageForCluster(bool available, bool up) {
    var imageTitle = up
        ? available
            ? 'active_far'
            : 'inactive_far'
        : 'down_far';

    return imageService.getDescriptor(imageTitle)!;
  }

  void _buildMarkersSet(List<Point> points, {bool? near}) async {
    BitmapDescriptor? myLocationBitmap;

    if (myLocationIcon == null) {
      myLocationBitmap = await getDescriptorFromAsset('assets/me.png', 120);
      setState(() {
        myLocationIcon = myLocationBitmap;
      });
    } else {
      myLocationBitmap = myLocationIcon;
    }

    var camera = geolocatorService.getLastKnownPosition();

    List<Place> items = [];

    points.forEach((element) {
      items.add(Place(point: element));
    });

    if (myPosition != null) {
      Set<Marker> newLocationMarkers = {};

      newLocationMarkers.add(Marker(
        markerId: const MarkerId(
          'myLocationMarker',
        ),
        position: LatLng(myPosition!.latitude, myPosition!.longitude),
        rotation: myPosition!.heading + camera.bearing,
        icon: myLocationBitmap!,
        anchor: const Offset(0.5, 0.5),
      ));

      setState(() {
        myLocationMarker = newLocationMarkers;
      });
      _myLocationMarkerNotifier.value = newLocationMarkers;
    }

    _clusterManager.setItems(items);
  }

  void pointsListener(BuildContext context, PointsState state) {
    _buildMarkersSet(state.points);
    if (state is FilterChangedState) {
      loadMorePoints();
    }
  }

  Future<BitmapDescriptor?> getDescriptorFromAsset(
      String asset, int? width) async {
    final ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width ?? 186);
    ui.FrameInfo fi = await codec.getNextFrame();
    var buffer = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    if (buffer != null) {
      var bytes = buffer.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(bytes);
    } else {
      return null;
    }
  }

  void onMarkerClick(BuildContext context, int pointId) {
    if (timer != null) {
      return;
    }
    timer = Timer(Duration(milliseconds: 200), () {
      timer = null;
    });
    var reservedPoint =
        BlocProvider.of<ActivePointsBloc>(context).state.reservedPoint;

    if (pointId == reservedPoint) {
      widget.showBooking();
    } else {
      var activePoint =
          BlocProvider.of<ActivePointsBloc>(context).state.chargingPoint;

      showPoint(context, pointId, pointId == activePoint);
    }
  }

  void pointListener(BuildContext context, PointInfoState state) {
    if (state is ShowPointState) {
      var reservedPoint =
          BlocProvider.of<ActivePointsBloc>(context).state.reservedPoint;
      var activePoint =
          BlocProvider.of<ActivePointsBloc>(context).state.chargingPoint;

      if (state.pointid == activePoint) {
        showPoint(context, state.pointid, state.pointid == activePoint);
      } else if (state.pointid == reservedPoint) {
        // showPoint(context, state.pointid, state.pointid == activePoint);
        widget.showBooking();
      } else {
        showPoint(context, state.pointid, state.pointid == activePoint);
      }
      BlocProvider.of<PointInfoBloc>(context).add(ClearPoint());
    }
  }

  void myLocationListener(Position position) {
    setState(() {
      myPosition = position;
    });
    updateMyPositionMarker(position);
  }

  void updateMyPositionMarker(Position position) async {
    // if (geolocatorService.getMyLastPosition?.latitude == position.latitude &&
    //     geolocatorService.getMyLastPosition?.longitude == position.longitude) {
    //   return;
    // }

    BitmapDescriptor? myLocationBitmap;

    if (myLocationIcon == null) {
      myLocationBitmap = await getDescriptorFromAsset('assets/me.png', 120);
      setState(() {
        myLocationIcon = myLocationBitmap;
      });
    } else {
      myLocationBitmap = myLocationIcon;
    }

    Set<Marker> newMarkers = {};

    var camera = geolocatorService.getLastKnownPosition();

    geolocatorService.setMyLastPosition = position;

    newMarkers.add(Marker(
        markerId: const MarkerId(
          'myLocationMarker',
        ),
        position: LatLng(position.latitude, position.longitude),
        icon: myLocationBitmap!,
        anchor: const Offset(0.5, 0.5),
        rotation: position.heading + camera.bearing));

    setState(() {
      myLocationMarker = newMarkers;
    });
    _myLocationMarkerNotifier.value = newMarkers;
  }

  void activePointsListener(BuildContext context, ActivePointsState state) {
    var points = BlocProvider.of<PointsBloc>(context).state.points;
    _buildMarkersSet(points);
    if (state is ShowActiveChargingPoint && state.chargingPoint != null) {
      showPoint(context, state.chargingPoint!, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(lastUpdate);
    return MultiBlocListener(
      listeners: [
        BlocListener<PointInfoBloc, PointInfoState>(
          listener: pointListener,
        ),
        BlocListener<ActivePointsBloc, ActivePointsState>(
            listener: activePointsListener)
      ],
      child: Container(
          child: Stack(
        children: [
          Animarker(
            key: animarkerKey,
            mapId: _controller.future.then<int>((value) => value.mapId),
            markers: markers,
            shouldAnimateCamera: false,
            useRotation: false,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: ValueListenableBuilder<Set<Marker>?>(
                valueListenable: _myLocationMarkerNotifier,
                builder: (context, value, child) {
                  return Map(
                      manager: _clusterManager,
                      controller: _controller,
                      markers: value ?? {},
                      kGooglePlex: _kGooglePlex,
                      pointsListener: pointsListener,
                      showMyLocation: false,
                      onCameraMove: onCameraMove);
                }),
          ),
          CustomAppBar(
            reload: () {
              // if (animarkerKey.currentState != null) {
              //   animarkerKey.currentState?.widget.updateMarkers(animarkerKey.currentState!.widget.markers, markers);
              // }
              // setState(() {
              //   markers= {...markers};
              // });
            },
          ),
          BlocBuilder<ActivePointsBloc, ActivePointsState>(
              builder: (context, state) {
            if (state.reservedPoint != null) {
              return const SizedBox();
            }
            return Positioned(
                right: 0,
                bottom: 50 + MediaQuery.of(context).viewPadding.bottom,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      QRScanner(
                        toggleMap: toggleMap,
                      ),
                      CustomIconButton(
                          onTap: () => getCurrentPosition(false),
                          icon: SvgPicture.asset('assets/position.svg'))
                    ],
                  ),
                ));
          }),
        ],
      )),
    );
  }
}
