import 'dart:async';
import 'dart:ui' as ui;

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lseway/domain/entitites/coordinates/coordinates.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';
import 'package:lseway/presentation/bloc/activePoints/active_point_state.dart';
import 'package:lseway/presentation/bloc/activePoints/active_points_bloc.dart';
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
import '../../../../injection_container.dart' as di;
import 'package:permission_handler/permission_handler.dart' as Permission;

class MapView extends StatefulWidget {
  final void Function() showBooking;
  const MapView({Key? key, required this.showBooking}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
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
  bool _showMyLocation = false;
  bool _showMap = true;
  Position? myPosition;
  late StreamSubscription<Position> myPositionStream;
  Set<Marker> myLocationMarker = {};

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
        }
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    geolocatorService = di.sl<GeolocatorService>();
    _kGooglePlex = geolocatorService.getLastKnownPosition();
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
    // geolocatorService.startBackgroundLocation(myPositionListener);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    myPositionStream.cancel();
    // geolocatorService.stopBackgroundLocation();
    super.dispose();
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
      });
    }).catchError((err) async {
      if (err == 'enableLocation') {
        geolocatorService.showLocationDialog(context);
      }
    });
  }

  void onCameraMove(CameraPosition position) async {
    var camera = geolocatorService.getLastKnownPosition();

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

    if ((camera.zoom < 13 && position.zoom >= 13) ||
        (camera.zoom > 13 && position.zoom <= 13)) {
      var points = BlocProvider.of<PointsBloc>(context).state.points;
      _buildMarkersSet(points);
    }

    geolocatorService.saveCameraPosition(position);
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
  }

  void _buildMarkersSet(List<Point> points) async {
    BitmapDescriptor? activeBitmap;
    BitmapDescriptor? inActiveBitmap;
    BitmapDescriptor? activeFarBitmap;
    BitmapDescriptor? inActiveFarBitmap;
    BitmapDescriptor? myLocationBitmap;
    BitmapDescriptor? selectedBitmap;

    if (activeFarIcon == null) {
      activeFarBitmap =
          await getDescriptorFromAsset('assets/active_far.png', null);
      setState(() {
        activeFarIcon = activeFarBitmap;
      });
    } else {
      activeFarBitmap = activeFarIcon;
    }

    if (inActiveFarIcon == null) {
      inActiveFarBitmap =
          await getDescriptorFromAsset('assets/inactive_far.png', null);
      setState(() {
        inActiveFarIcon = inActiveFarBitmap;
      });
    } else {
      inActiveFarBitmap = inActiveFarIcon;
    }

    if (activeIcon == null) {
      activeBitmap = await getDescriptorFromAsset('assets/active.png', null);
      setState(() {
        activeIcon = activeBitmap;
      });
    } else {
      activeBitmap = activeIcon;
    }

    if (inActiveIcon == null) {
      inActiveBitmap =
          await getDescriptorFromAsset('assets/inactive.png', null);
      setState(() {
        inActiveIcon = inActiveBitmap;
      });
    } else {
      inActiveBitmap = inActiveIcon;
    }

    if (myLocationIcon == null) {
      myLocationBitmap = await getDescriptorFromAsset('assets/me.png', 120);
      setState(() {
        myLocationIcon = myLocationBitmap;
      });
    } else {
      myLocationBitmap = myLocationIcon;
    }

    if (selectedIcon == null) {
      selectedBitmap =
          await getDescriptorFromAsset('assets/selected22.png', 240);
      setState(() {
        selectedIcon = selectedBitmap;
      });
    } else {
      selectedBitmap = selectedIcon;
    }



    var camera = geolocatorService.getLastKnownPosition();

    Set<Marker> newMarkers = {};

    var reservedPoint = BlocProvider.of<ActivePointsBloc>(context).state.reservedPoint;
    var chargingPoint = BlocProvider.of<ActivePointsBloc>(context).state.chargingPoint;

    points.forEach((element) {
      newMarkers.add(
        Marker(
            markerId: MarkerId(
              element.id.toString(),
            ),
            position: LatLng(element.latitude, element.longitude),
            icon: (reservedPoint == element.id || chargingPoint == element.id) ? selectedBitmap! : element.availability
                ? camera.zoom < 13
                    ? activeFarBitmap!
                    : activeBitmap!
                : camera.zoom < 13
                    ? inActiveFarBitmap!
                    : inActiveBitmap!,
            anchor:(reservedPoint == element.id || chargingPoint == element.id) ? const Offset(0.5, 0.7) : camera.zoom < 13
                ? const Offset(0.5, 0.4)
                : const Offset(0.5, 0.7),
            onTap: () => onMarkerClick(context, element.id)),
      );
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
    }

    setState(() {
      markers = newMarkers;
    });
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

      if (state.pointid == reservedPoint) {
        widget.showBooking();
      } else {
        var activePoint =
            BlocProvider.of<ActivePointsBloc>(context).state.chargingPoint;
        showPoint(context, state.pointid, state.pointid == activePoint);
        BlocProvider.of<PointInfoBloc>(context).add(ClearPoint());
      }
    }
  }

  void myLocationListener(Position position) {
    setState(() {
      myPosition = position;
    });
    updateMyPositionMarker(position);
  }

  void updateMyPositionMarker(Position position) async {
    if (geolocatorService.getMyLastPosition?.latitude == position.latitude &&
        geolocatorService.getMyLastPosition?.longitude == position.longitude) {
      return;
    }

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
  }


  void activePointsListener(BuildContext context, ActivePointsState state) {
    var points = BlocProvider.of<PointsBloc>(context).state.points;
    _buildMarkersSet(points);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PointInfoBloc, PointInfoState>(
          listener: pointListener,
        ),
        BlocListener<ActivePointsBloc, ActivePointsState>(listener: activePointsListener)
      ],
      child: Container(
          child: Stack(
        children: [
          Animarker(
            mapId: _controller.future.then<int>((value) => value.mapId),
            markers: myLocationMarker,
            shouldAnimateCamera: false,
            useRotation: false,
            child: Map(
                controller: _controller,
                markers: markers,
                kGooglePlex: _kGooglePlex,
                pointsListener: pointsListener,
                showMyLocation: false,
                onCameraMove: onCameraMove),
          ),
          const CustomAppBar(),
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
