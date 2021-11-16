import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lseway/presentation/bloc/points/points.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.state.dart';

class Map extends StatelessWidget {
  final Completer<GoogleMapController> controller;
  final BitmapDescriptor? activeIcon;
  final BitmapDescriptor? inActiveIcon;
  final Set<Marker> markers;
  final bool showMyLocation;
  final CameraPosition kGooglePlex;
  final ClusterManager manager;
  final void Function(CameraPosition) onCameraMove;
  final void Function(BuildContext, PointsState) pointsListener;

  const Map(
      {Key? key,
      required this.controller,
      required this.markers,
      required this.kGooglePlex,
      required this.pointsListener,
      required this.showMyLocation,
      this.activeIcon,
      this.inActiveIcon,
      required this.onCameraMove,
      required this.manager,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PointsBloc, PointsState>(
        listener: pointsListener,
        builder: (context, state) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: kGooglePlex,
            zoomControlsEnabled: false,
            myLocationEnabled: showMyLocation,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            onCameraMove: (camera) {
              onCameraMove(camera);
              manager.onCameraMove(camera);
            } ,
            
            onCameraIdle: manager.updateMap,
            markers: markers,
            onMapCreated: (GoogleMapController _controller) {
              if (!controller.isCompleted) {
                controller.complete(_controller);
              }
              manager.setMapId(_controller.mapId);
            },
          );
        });
  }
}
