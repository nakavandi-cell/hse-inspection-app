import 'package:sqflite/sqflite.dart';

import '../core/db/database_helper.dart';
import '../models/inspection_model.dart';

class InspectionRepository {
  InspectionRepository._();
  static final InspectionRepository instance = InspectionRepository._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<int> insertInspection(InspectionModel inspection) async {
    final db = await _db;
    return db.insert(
      'inspections',
      inspection.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<InspectionModel>> getAllInspections() async {
    final db = await _db;
    final rows = await db.query('inspections', orderBy: 'date DESC');
    return rows.map((e) => InspectionModel.fromJson(e)).toList();
  }

  Future<InspectionModel?> getInspectionById(String id) async {
    final db = await _db;
    final rows = await db.query(
      'inspections',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return InspectionModel.fromJson(rows.first);
  }

  Future<int> deleteInspection(String id) async {
    final db = await _db;
    return db.delete('inspections', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateInspectionStatus({
    required String id,
    required String status,
  }) async {
    final db = await _db;
    return db.update(
      'inspections',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
