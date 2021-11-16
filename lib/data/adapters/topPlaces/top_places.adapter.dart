import 'package:lseway/domain/entitites/history/top_place.entity.dart';

List<TopPlace> mapJsonToTopPlaces(List<dynamic> json) {

  List<TopPlace> places = [];


  json.forEach((place) {
    places.add(TopPlace(
      address: place["address"] ?? '',
      id: place["point_number"],
      city: place["city"] ?? '',
      count: place["count"] ?? 1
    ));
  });

  return places;

}