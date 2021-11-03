import 'package:dio/dio.dart';
import 'package:lseway/config/config.dart';
import 'package:lseway/data/data-sources/history/temp_history.dart';
import 'package:lseway/data/models/history/history.dart';






class HistoryRemoteDataSource {

  final Dio dio;

  static const String _apiUrl = Config.API_URL;

  HistoryRemoteDataSource({required this.dio});

  Future<List<HistoryItemModel>> getHistory() async {
      var url = _apiUrl + 'history';


      try {
        


        var response = await dio.get(url);

        var result = response.data['result'];
        print(result);
        




        return tempHistory;
        // return Right(filter.availability ? tempPoints.where((element) => element.availability).toList() : tempPoints);
    } on DioError catch (err) {
      
      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        
        return [];
      } 
      return [];
    } 
  }

}