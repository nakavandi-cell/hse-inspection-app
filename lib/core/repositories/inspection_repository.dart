import '../db/app_database.dart';
import '../models/answer_model.dart';
import '../models/inspection_model.dart';

class InspectionRepository {
  InspectionRepository(this._db);
  final AppDatabase _db;

  /// بازرسی و همه پاسخ‌هایش را در یک تراکنش ذخیره می‌کند.
  /// شناسه بازرسی جدید را برمی‌گرداند.
  Future<int> saveInspection({
    required InspectionModel inspection,
    required List<AnswerModel> answers,
  }) async {
    final db = await _db.database;
    return db.transaction((txn) async {
      final inspectionId = await txn.insert('inspections', inspection.toMap());
      for (final answer in answers) {
        await txn.insert(
          'inspection_answers',
          answer.copyWithInspectionId(inspectionId).toMap(),
        );
      }
      return inspectionId;
    });
  }
}
