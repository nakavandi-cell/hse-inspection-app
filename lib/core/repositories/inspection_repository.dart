import '../db/app_database.dart';
import '../models/answer_model.dart';
import '../models/inspection_model.dart';

class InspectionRepository {
  InspectionRepository(this._db);
  final AppDatabase _db;

  /// اگر `id` داشته باشد یعنی ویرایش/ادامه است؛ وگرنه بازرسی جدید ثبت می‌شود.
  Future<int> saveInspection({
    required InspectionModel inspection,
    required List<AnswerModel> answers,
  }) async {
    final db = await _db.database;
    return db.transaction((txn) async {
      final int inspectionId;
      if (inspection.id != null) {
        inspectionId = inspection.id!;
        await txn.update(
          'inspections',
          inspection.toMap(),
          where: 'id = ?',
          whereArgs: [inspectionId],
        );
        await txn.delete(
          'inspection_answers',
          where: 'inspection_id = ?',
          whereArgs: [inspectionId],
        );
      } else {
        inspectionId = await txn.insert('inspections', inspection.toMap());
      }
      for (final answer in answers) {
        await txn.insert(
          'inspection_answers',
          answer.copyWithInspectionId(inspectionId).toMap(),
        );
      }
      return inspectionId;
    });
  }

  Future<List<InspectionModel>> getAll() async {
    final db = await _db.database;
    final rows = await db.query('inspections', orderBy: 'id DESC');
    return rows.map(InspectionModel.fromMap).toList();
  }

  Future<InspectionModel?> getById(int id) async {
    final db = await _db.database;
    final rows = await db.query(
      'inspections',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return InspectionModel.fromMap(rows.first);
  }

  Future<List<AnswerModel>> getAnswers(int inspectionId) async {
    final db = await _db.database;
    final rows = await db.query(
      'inspection_answers',
      where: 'inspection_id = ?',
      whereArgs: [inspectionId],
      orderBy: 'id ASC',
    );
    return rows.map(AnswerModel.fromMap).toList();
  }
}
