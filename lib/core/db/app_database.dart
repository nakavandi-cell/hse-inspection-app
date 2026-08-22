import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const String _dbName = 'hse_inspection.db';

  // Version 2:
  // افزودن ستون‌های comment و answered_at به جدول answers
  static const int _dbVersion = 2;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// فعال‌سازی Foreign Key در SQLite.
  /// بدون این بخش، ON DELETE CASCADE ممکن است اجرا نشود.
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE inspections (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        checklist_id TEXT,
        checklist_title TEXT,
        checklist_code TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE answers (
        id TEXT PRIMARY KEY,
        inspection_id TEXT NOT NULL,
        question_id TEXT NOT NULL,
        answer_value TEXT NOT NULL,
        comment TEXT,
        answered_at TEXT,
        FOREIGN KEY (inspection_id)
          REFERENCES inspections (id)
          ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE equipments (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        location TEXT,
        is_active INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_answers_inspection_id
      ON answers (inspection_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_answers_question_id
      ON answers (question_id)
    ''');
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE answers
        ADD COLUMN comment TEXT
      ''');

      await db.execute('''
        ALTER TABLE answers
        ADD COLUMN answered_at TEXT
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_answers_inspection_id
        ON answers (inspection_id)
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_answers_question_id
        ON answers (question_id)
      ''');
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
