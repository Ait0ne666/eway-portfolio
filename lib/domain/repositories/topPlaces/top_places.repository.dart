import 'package:lseway/domain/entitites/history/top_place.entity.dart';

abstract class TopPlacesRepository {


  Future<List<TopPlace>> getTopPlaces();
}