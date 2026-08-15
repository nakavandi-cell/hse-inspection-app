import '../db/app_database.dart';
import '../models/answer_model.dart';
import '../models/inspection_model.dart';
import '../models/inspection_status.dart';

class InspectionRepository {
  Future<int> createInspection({
    required int equipmentId,
    required String checklistId,
    required String inspectorName,
  }) async {
    final db = await AppDatabase.instance.database;
    final now = DateTime.now().toIso8601String();
    final inspection = InspectionModel(
      equipmentId: equipmentId,
      checklistId: checklistId,
      inspectorName: inspectorName,
      inspectionDate: now,
      status: InspectionStatus.draft,
      createdAt: now,
      updatedAt: now,
    );
    return db.insert('inspections', inspection.toMap());
  }

  Future<InspectionModel?> getInspection(int id) async {
    final db = await AppDatabase.instance.database;
    final rows =
        await db.query('inspections', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return InspectionModel.fromMap(rows.first);
  }

  Future<void> updateStatus(int inspectionId, InspectionStatus status) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'inspections',
      {
        'status': status.value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [inspectionId],
    );
  }

  Future<void> markCompleted(int inspectionId) async {
    await updateStatus(inspectionId, InspectionStatus.completed);
  }

  Future<List<InspectionModel>> getInspectionsForEquipment(int equipmentId) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'inspections',
      where: 'equipment_id = ?',
      whereArgs: [equipmentId],
      orderBy: 'inspection_date DESC',
    );
    return rows.map(InspectionModel.fromMap).toList();
  }

  Future<List<InspectionModel>> getDraftInspections() async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'inspections',
      where: 'status IN (?, ?)',
      whereArgs: [InspectionStatus.draft.value, InspectionStatus.inProgress.value],
      orderBy: 'updated_at DESC',
    );
    return rows.map(InspectionModel.fromMap).toList();
  }

  Future<void> saveAnswer(AnswerModel answer) async {
    final db = await AppDatabase.instance.database;
    final existing = await db.query(
      'inspection_answers',
      where: 'inspection_id = ? AND question_id = ?',
      whereArgs: [answer.inspectionId, answer.questionId],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      final id = existing.first['id'] as int;
      await db.update(
        'inspection_answers',
        {...answer.toMap(), 'id': id},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      await db.insert('inspection_answers', answer.toMap());
    }
  }

  Future<Map<String, AnswerModel>> getAnswersForInspection(int inspectionId) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'inspection_answers',
      where: 'inspection_id = ?',
      whereArgs: [inspectionId],
    );

    return {
      for (final r in rows) r['question_id'] as String: AnswerModel.fromMap(r),
    };
  }

  Future<int> countAnswered(int inspectionId) async {
    final db = await AppDatabase.instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM inspection_answers WHERE inspection_id = ?',
      [inspectionId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<AnswerModel>> getNotOkAnswers(int inspectionId) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'inspection_answers',
      where: 'inspection_id = ? AND answer = ?',
      whereArgs: [inspectionId, AnswerValue.notOk.value],
    );
    return rows.map(AnswerModel.fromMap).toList();
  }

  Future<Map<String, int>> getInspectionStats(int inspectionId) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.rawQuery(
      'SELECT answer, COUNT(*) AS c FROM inspection_answers WHERE inspection_id = ? GROUP BY answer',
      [inspectionId],
    );

    final stats = {'OK': 0, 'NG': 0, 'NA': 0};
    for (final r in rows) {
      stats[r['answer'] as String] = r['c'] as int;
    }
    return stats;
  }

  Future<void> deleteInspection(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete('inspections', where: 'id = ?', whereArgs: [id]);
  }
}
