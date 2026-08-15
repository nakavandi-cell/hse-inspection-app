import '../db/app_database.dart';
import '../models/checklist_model.dart';

class ChecklistRepository {
  Future<List<ChecklistModel>> getAllChecklists() async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query('checklists', orderBy: 'category, title');
    final maps = rows.map(ChecklistModel.fromDbRow).toList();
    return maps;
  }

  Future<ChecklistModel?> getById(String id) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query('checklists', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return ChecklistModel.fromDbRow(rows.first);
  }

  Future<List<ChecklistModel>> getByCategory(String category) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query('checklists',
        where: 'category = ?', whereArgs: [category], orderBy: 'title');
    return rows.map(ChecklistModel.fromDbRow).toList();
  }

  Future<int> countQuestions(String checklistId) async {
    final db = await AppDatabase.instance.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) AS c FROM checklist_questions WHERE checklist_id = ?',
        [checklistId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
