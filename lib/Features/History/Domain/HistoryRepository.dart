import '../Data/Models/HistoryModel.dart';

abstract class HistoryRepository {
  Future<List<HistoryModel>> getHistory();
}
