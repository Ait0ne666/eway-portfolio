
import 'package:lseway/domain/entitites/history/history.entity.dart';
import 'package:lseway/domain/repositories/history/history.repository.dart';

class HistoryuseCase {
   final HistoryRepository repository;

  HistoryuseCase({required this.repository});

  Future<List<HistoryItem>> getHistory() {
    return repository.getHistory();
  }
}
