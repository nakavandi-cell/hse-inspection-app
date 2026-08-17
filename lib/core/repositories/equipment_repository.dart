import 'package:sqflite/sqflite.dart';

import '../core/db/database_helper.dart';
import '../models/equipment_model.dart';

class EquipmentRepository {
  EquipmentRepository._();
  static final EquipmentRepository instance = EquipmentRepository._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<int> insertEquipment(EquipmentModel equipment) async {
    final db = await _db;
    return db.insert(
      'equipments',
      equipment.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<EquipmentModel>> getAllEquipments() async {
    final db = await _db;
    final rows = await db.query('equipments', orderBy: 'name ASC');
    return rows.map((e) => EquipmentModel.fromJson(e)).toList();
  }

  Future<int> deleteEquipment(String id) async {
    final db = await _db;
    return db.delete('equipments', where: 'id = ?', whereArgs: [id]);
  }
}
