import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:lseway/data/models/user/user.model.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';

class UserLocalDataSource {
  var box = Hive.box('session');

  void saveJwt(String jwt) {
    box.put("jwt", jwt);
  }

  String? getJwt() {
    var token = box.get("jwt");
    return token;
  }

  void deleteJwt() {
    box.delete("jwt");
  }

  void saveRefresh(String refresh) {
    box.put("Refresh", refresh);
  }

  String? getRefresh() {
    var token = box.get("Refresh");
    return token;
  }

  void deleteRefresh() {
    box.delete("Refresh");
  }

  void saveWatchedWelcome(bool agree) {
    box.put("welcome", agree);
  }

  bool? getWatchedWelcome() {
    return box.get("welcome");
  }

  void deleteWatchedWelcome() {
    box.delete("welcome");
  }

  void saveUserModel(UserModel model) {
    box.put('user', jsonEncode(model.toJson()));
  }

  UserModel? getUserModel() {
    var jsonString = box.get('user');
    if (jsonString != null) {
      var json = jsonDecode(jsonString);
      return UserModel.fromJson(json);
    }
    return null;
  }

  void deleteUserModel() {
    box.delete('user');
  }

  void saveFilter(Filter filter) {
    box.put('currentFilter', jsonEncode(filter.toJson()));
  }

  Filter? getFilter() {
    var jsonString = box.get('currentFilter');
    if (jsonString != null) {
      var json = jsonDecode(jsonString);
      return Filter.fromJson(json);
    }

    return null;
  }

  void deleteFilter() {
    box.delete('currentFilter');
  }

  void saveCoordinates(LatLng coords, double bearing, double zoom) {
    box.put("lastCoordinates", json.encode(coords.toJson()));
    box.put("lastBearing", bearing);
    box.put("lastZoom", zoom);
  }

  CoordResult? getCoordinates() {
    var coords = box.get("lastCoordinates");
    var bearing = box.get("lastBearing");
    var zoom = box.get("lastZoom");

    if (coords == null) return null;

    return CoordResult(
        bearing: bearing,
        target: LatLng.fromJson(
          jsonDecode(coords),
        ),
        zoom: zoom);
  }

  void deleteCoords() {
    box.delete("lastCoordinates");
    box.delete("lastBearing");
    box.delete("lastZoom");
  }

  void saveEmailConfirmationShown() {
    box.put("emailConfirmShown", true);
  }

  bool getEmailConfirmationShown() {
    var shown = box.get("emailConfirmShown");
    return shown ?? false;
  }

  void deleteEmailConfrimationShown() {
    box.delete("emailConfirmShown");
  }

  String? getDeviceToken() {
    return box.get("device_token");
  }


  void setDeviceToken(String token) {
    var shown = box.put("device_token", token);
  }

  void deleteDeviceToken() {
    box.delete("device_token");
  }

}

class CoordResult {
  final LatLng? target;
  final double? bearing;
  final double? zoom;

  CoordResult(
      {required this.bearing, required this.target, required this.zoom});
}
