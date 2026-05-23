import 'package:flutter/foundation.dart';
import '../models/practice_record.dart';
import '../services/database_helper.dart';

class PracticeHistoryProvider with ChangeNotifier {
  List<PracticeRecord> _records = [];
  List<PracticeRecord> get records => _records;

  Future<void> loadRecords() async {
    final data = await DatabaseHelper.instance.getPracticeHistory();
    _records = data.map((e) => PracticeRecord.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> addRecord(PracticeRecord record) async {
    await DatabaseHelper.instance.insertPracticeRecord(record.toJson());
    await loadRecords();
  }
}