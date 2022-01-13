import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/data/adapters/topPlaces/top_places.adapter.dart';
import 'package:lseway/domain/entitites/history/top_place.entity.dart';







class TopPlacesRemoteDataSource {

  final Dio dio;

  static const String _apiUrl = Config.API_URL;

  TopPlacesRemoteDataSource({required this.dio});

  Future<List<TopPlace>> getTopPlaces() async {
      var url = _apiUrl + 'top_points';


      try {
        


        var response = await dio.get(url);

        var result = response.data['result'] as List<dynamic>;
        




        // return [
        //   TopPlace(address: 'Покровка, 21', count: 2, city: 'г.Москва', id: 72717798),
        //   TopPlace(address: 'Большая Семеновская, 39', count: 3, city: 'г.Москва', id: 72717798),
        //   TopPlace(address: 'Тверская, 40', count: 5, city: 'г.Москва', id: 72717798),
        // ];


        return mapJsonToTopPlaces(result);
        
    } on DioError catch (err) {
      
      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        
        return [];
      } 
      return [];
    } 
  }

}