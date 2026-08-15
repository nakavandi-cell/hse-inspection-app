import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../utils/seed_loader.dart';
import '../models/checklist_model.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _db;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hse_inspection.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) async {
        await _ensureSeedData(db);
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE equipments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        location TEXT NOT NULL,
        description TEXT,
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
        required INTEGER NOT NULL,
        sort_order INTEGER,
        FOREIGN KEY (checklist_id) REFERENCES checklists (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE inspections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        equipment_id INTEGER NOT NULL,
        checklist_id TEXT NOT NULL,
        inspector_name TEXT NOT NULL,
        inspection_date TEXT NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT,
        FOREIGN KEY (equipment_id) REFERENCES equipments (id),
        FOREIGN KEY (checklist_id) REFERENCES checklists (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE inspection_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        inspection_id INTEGER NOT NULL,
        question_id TEXT NOT NULL,
        answer TEXT NOT NULL,
        comment TEXT,
        corrective_action TEXT,
        corrective_owner TEXT,
        due_date TEXT,
        status TEXT,
        FOREIGN KEY (inspection_id) REFERENCES inspections (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_equipments_code ON equipments(code)');
    await db.execute('CREATE INDEX idx_equipments_name ON equipments(name)');
    await db.execute('CREATE INDEX idx_equipments_location ON equipments(location)');
    await db.execute('CREATE INDEX idx_inspections_date ON inspections(inspection_date)');
    await db.execute('CREATE INDEX idx_inspections_status ON inspections(status)');
    await db.execute('CREATE INDEX idx_answers_inspection_id ON inspection_answers(inspection_id)');
    await db.execute('CREATE INDEX idx_questions_checklist_id ON checklist_questions(checklist_id)');
  }

  Future<void> _ensureSeedData(Database db) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM checklists'),
    );

    if ((count ?? 0) > 0) return;

    final List<ChecklistModel> checklists = await SeedLoader.loadChecklists();

    final batch = db.batch();

    for (final checklist in checklists) {
      batch.insert(
        'checklists',
        {
          'id': checklist.id,
          'title': checklist.title,
          'category': checklist.category,
          'code': checklist.code,
          'version': checklist.version,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (int i = 0; i < checklist.questions.length; i++) {
        final question = checklist.questions[i];
        batch.insert(
          'checklist_questions',
          {
            'id': question.id,
            'checklist_id': checklist.id,
            'text': question.text,
            'type': question.type,
            'required': question.requiredField ? 1 : 0,
            'sort_order': i + 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    await batch.commit(noResult: true);
  }
}
