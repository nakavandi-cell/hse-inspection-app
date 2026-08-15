import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'hse_inspection.db');
    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE equipments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        location TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE checklists (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        code TEXT,
        version TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE checklist_questions (
        id TEXT PRIMARY KEY,
        checklist_id TEXT NOT NULL,
        text TEXT NOT NULL,
        type TEXT NOT NULL,
        required_field INTEGER NOT NULL DEFAULT 1,
        position INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (checklist_id) REFERENCES checklists (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE inspections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        checklist_id TEXT NOT NULL,
        section_key TEXT NOT NULL,
        title TEXT NOT NULL,
        status TEXT NOT NULL,
        started_at TEXT,
        completed_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE inspection_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        inspection_id INTEGER NOT NULL,
        question_id TEXT NOT NULL,
        answer TEXT NOT NULL,
        note TEXT,
        corrective_action TEXT,
        FOREIGN KEY (inspection_id) REFERENCES inspections (id),
        FOREIGN KEY (question_id) REFERENCES checklist_questions (id)
      )
    ''');
  }
}
