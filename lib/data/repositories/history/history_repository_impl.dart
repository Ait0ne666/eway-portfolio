import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/data/data-sources/history/history_remote_data_source.dart';
import 'package:lseway/data/models/history/history.dart';
import 'package:lseway/domain/entitites/history/history.entity.dart';
import 'package:lseway/domain/repositories/history/history.repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
    final HistoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;


  HistoryRepositoryImpl({required this.networkInfo, required this.remoteDataSource});

  @override
  Future<List<HistoryItem>> getHistory() async {



    var result = await remoteDataSource.getHistory();


    return result.map((items){
      return HistoryItem(amount: items.amount, address: items.address, date: items.date);
    }).toList();
  }
}