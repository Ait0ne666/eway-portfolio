import 'package:lseway/domain/entitites/history/top_place.entity.dart';
import 'package:lseway/domain/repositories/topPlaces/top_places.repository.dart';

class TopPlacesuseCase {
   final TopPlacesRepository repository;

  TopPlacesuseCase({required this.repository});

  Future<List<TopPlace>> getTopPlaces() {
    return repository.getTopPlaces();
  }
}
