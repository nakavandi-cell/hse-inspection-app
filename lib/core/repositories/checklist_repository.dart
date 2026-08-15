import 'package:sqflite/sqflite.dart';

import '../../utils/seed_loader.dart';
import '../db/app_database.dart';
import '../models/checklist_model.dart';

class ChecklistRepository {
  ChecklistRepository(this._db);
  final AppDatabase _db;

  /// فقط وقتی جدول چک‌لیست‌ها خالی است، seed را در SQLite می‌ریزد.
  Future<void> seedIfNeeded() async {
    final db = await _db.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM checklists'),
    );
    if (count != null && count > 0) return;

    final checklists = await SeedLoader.load();
    final batch = db.batch();
    for (final c in checklists) {
      batch.insert(
        'checklists',
        c.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      for (var i = 0; i < c.questions.length; i++) {
        final qMap = c.questions[i].toMap();
        qMap['position'] = i;
        batch.insert(
          'checklist_questions',
          qMap,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    await batch.commit(noResult: true);
  }

  Future<List<ChecklistModel>> getAll() async {
    await seedIfNeeded();
    final db = await _db.database;
    final rows = await db.query('checklists', orderBy: 'category');
    final result = <ChecklistModel>[];
    for (final row in rows) {
      final qRows = await db.query(
        'checklist_questions',
        where: 'checklist_id = ?',
        whereArgs: [row['id']],
        orderBy: 'position ASC, id ASC',
      );
      result.add(ChecklistModel.fromMap(row, qRows));
    }
    return result;
  }

  /// با `sectionKey` منو (مثل `electrical_general`) چک‌لیست را پیدا می‌کند.
  Future<ChecklistModel?> getByKey(String key) async {
    final all = await getAll();
    for (final c in all) {
      if (c.id == key || c.category == key) return c;
    }
    return null;
  }
}
