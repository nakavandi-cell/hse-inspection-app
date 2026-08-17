// lib/core/db/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

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
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // ایجاد جدول بازرسی‌ها
    await db.execute('''
      CREATE TABLE inspections (
        id TEXT PRIMARY KEY,
        title TEXT,
        date TEXT,
        status TEXT
      )
    ''');

    // ایجاد جدول پاسخ‌ها (برای ذخیره جواب سوالات هر بازرسی)
    await db.execute('''
      CREATE TABLE answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        inspection_id TEXT,
        question_id TEXT,
        answer_value TEXT,
        FOREIGN KEY(inspection_id) REFERENCES inspections(id)
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
