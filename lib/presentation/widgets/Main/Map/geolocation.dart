import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';

class GeolocatorService {
  UserLocalDataSource localDataSource;
  Position? lastPosition;
  Position? myLastPosition;

  void init() {
    myLastPosition = localDataSource.getUserLocation();
    if (Platform.isAndroid) {
      // BackgroundLocation.setAndroidNotification(
      //   title: "Location",
      //   message: "location",
      //   icon: "@mipmap/ic_launcher",
      // );
      // BackgroundLocation.setAndroidConfiguration(1000);
    }
  }

  Position? get getLastViewerPosition => lastPosition;
  Position? get getMyLastPosition => myLastPosition;
  set setMyLastPosition(Position? position) {
    myLastPosition = position;
    if (position != null) {
      localDataSource.saveUserLocation(position);
    }
  }

  GeolocatorService({required this.localDataSource});

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('enableLocation');
    }
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('denied');
        }
      }
    } catch (err) {
      return Future.error('inprogress');
    }

    var position = await Geolocator.getCurrentPosition();
    lastPosition = position;
    return position;
  }

  Future<Position?> getLastPosition() async {
    var position = await Geolocator.getLastKnownPosition();

    return position;
  }

  void showLocationDialog(BuildContext context) {
    Future(
      () => showDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: true,
        barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
        builder: (dialogContext) {
          return SimpleDialog(
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            insetPadding: const EdgeInsets.all(20),
            contentPadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 2,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 450),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Center(
                              child: Text(
                                'Для работы приложения необходимо включить геолокацию. Включить?',
                                style: Theme.of(context).textTheme.bodyText2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 45,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 53),
                            child: CustomButton(
                              text: 'Нет, спасибо',
                              type: ButtonTypes.SECONDARY,
                              onPress: () {
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 19,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 53),
                            child: CustomButton(
                              text: 'Да',
                              onPress: () {
                                Navigator.of(dialogContext, rootNavigator: true)
                                    .pop();
                                Geolocator.openLocationSettings();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 21,
                      right: 21,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(dialogContext, rootNavigator: true)
                              .pop();
                        },
                        child: SvgPicture.asset('assets/close.svg'),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  CameraPosition getLastKnownPosition() {
    var coords = localDataSource.getCoordinates();
    if (coords == null || coords.target == null) {
      return const CameraPosition(
        target: LatLng(55.751244, 37.618423),
        zoom: 14.4746,
      );
    } else {
      return CameraPosition(
          target: coords.target!,
          zoom: coords.zoom ?? 14.4746,
          bearing: coords.bearing ?? 0);
    }
  }

  void saveCameraPosition(CameraPosition position) async {
    localDataSource.saveCoordinates(
        position.target, position.bearing, position.zoom);
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
        intervalDuration: const Duration(milliseconds: 2000));
  }

  // void startBackgroundLocation(void Function(Location location) callback) {
  //   BackgroundLocation.startLocationService();

  //   BackgroundLocation.getLocationUpdates(callback);
  // }

  // void stopBackgroundLocation() {
  //   BackgroundLocation.stopLocationService();
  // }
}
