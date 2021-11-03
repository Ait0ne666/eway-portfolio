



import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/data/data-sources/topPlaces/top_places.data-source.dart';
import 'package:lseway/domain/entitites/history/top_place.entity.dart';
import 'package:lseway/domain/repositories/topPlaces/top_places.repository.dart';

class TopPlacesRepositoryImpl implements TopPlacesRepository {
    final TopPlacesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;


  TopPlacesRepositoryImpl({required this.networkInfo, required this.remoteDataSource});

  @override
  Future<List<TopPlace>> getTopPlaces() async {



    var result = await remoteDataSource.getTopPlaces();


    return result;
  }
}