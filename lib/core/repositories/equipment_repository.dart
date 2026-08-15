import '../db/app_database.dart';
import '../models/equipment_model.dart';

class EquipmentRepository {
  Future<int> insert(EquipmentModel e) async {
    final db = await AppDatabase.instance.database;
    return db.insert('equipments', e.toMap());
  }

  Future<int> update(EquipmentModel e) async {
    final db = await AppDatabase.instance.database;
    if (e.id == null) return 0;
    return db.update('equipments', e.toMap(),
        where: 'id = ?', whereArgs: [e.id]);
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return db.delete('equipments', where: 'id = ?', whereArgs: [id]);
  }

  Future<EquipmentModel?> getById(int id) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query('equipments', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return EquipmentModel.fromMap(rows.first);
  }

  Future<List<EquipmentModel>> getAll() async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query('equipments',
        orderBy: 'category ASC, code ASC');
    return rows.map(EquipmentModel.fromMap).toList();
  }

  Future<List<EquipmentModel>> search(String query) async {
    final db = await AppDatabase.instance.database;
    final like = '%$query%';
    return db.query('equipments',
        where: 'name LIKE ? OR code LIKE ? OR location LIKE ?',
        whereArgs: [like, like, like],
        orderBy: 'name').map(EquipmentModel.fromMap).toList();
  }
}
