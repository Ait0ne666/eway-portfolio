import 'package:dartz/dartz.dart';
import 'package:lseway/domain/entitites/history/history.entity.dart';

abstract class HistoryRepository {


  Future<List<HistoryItem>> getHistory();
}