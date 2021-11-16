import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<String> imageNames = [
  'icons/active7',
  'icons/active22',
  'icons/active50',
  'icons/active80',
  'icons/active90',
  'icons/active120',
  'icons/active150',
  'icons/active180',
  'icons/free7',
  'icons/free22',
  'icons/free50',
  'icons/free80',
  'icons/free90',
  'icons/free120',
  'icons/free150',
  'icons/free180',
  'icons/busy7',
  'icons/busy22',
  'icons/busy50',
  'icons/busy80',
  'icons/busy90',
  'icons/busy120',
  'icons/busy150',
  'icons/busy180',
  'icons/inactive7',
  'icons/inactive22',
  'icons/inactive50',
  'icons/inactive80',
  'icons/inactive90',
  'icons/inactive120',
  'icons/inactive150',
  'icons/inactive180',
  'active_far',
  'inactive_far',
  'down_far'
];

class ImageService {
  Map<String, BitmapDescriptor> images = {};

  Future<void> init() async {
    await Future.forEach<String>(imageNames, (element) async {
      var descriptor = await getDescriptorFromAsset(
          'assets/' + element + '.png',
          element.contains('icons/active') ? 240 : element.contains('_far') ? 50 : null);
      if (descriptor != null) {
        images[element] = descriptor;
      }
    });
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

  BitmapDescriptor? getDescriptor(String title) {
    return images[title];
  }
}
