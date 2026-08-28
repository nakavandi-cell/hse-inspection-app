import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/inspection_model.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hse_inspection.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onConfigure: _onConfigure,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE inspections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        checklist_id TEXT NOT NULL,
        checklist_title TEXT NOT NULL,
        checklist_code TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        inspection_id INTEGER NOT NULL,
        question_id TEXT NOT NULL,
        status TEXT NOT NULL,
        comment TEXT,
        FOREIGN KEY (inspection_id) REFERENCES inspections (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE equipments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    await db.execute('CREATE INDEX idx_inspections_date ON inspections (date)');
    await db.execute('CREATE INDEX idx_answers_inspection ON answers (inspection_id)');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS answers');
      await db.execute('DROP TABLE IF EXISTS inspections');
      await db.execute('DROP TABLE IF EXISTS equipments');
      await _createDB(db, newVersion);
    }
  }

  // --- متدهای CRUD برای بازرسی‌ها (Inspections) ---

  Future<int> insertInspection(InspectionModel inspection) async {
    final db = await instance.database;
    return await db.insert('inspections', inspection.toDbMap());
  }

  Future<int> updateInspection(InspectionModel inspection) async {
    final db = await instance.database;
    return await db.update(
      'inspections',
      inspection.toDbMap(),
      where: 'id = ?',
      whereArgs: [inspection.id],
    );
  }

  Future<int> deleteInspection(int id) async {
    final db = await instance.database;
    return await db.delete(
      'inspections',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<InspectionModel>> getAllInspections() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'inspections',
      orderBy: 'id DESC',
    );

    return List.generate(maps.length, (i) {
      return InspectionModel.fromDbMap(maps[i]);
    });
  }

  Future<InspectionModel?> getInspectionById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'inspections',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return InspectionModel.fromDbMap(maps.first);
    } else {
      return null;
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
