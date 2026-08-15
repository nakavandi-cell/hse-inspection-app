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
    // جدول تجهیزات
    await db.execute('''
      CREATE TABLE equipments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL,
        name TEXT NOT NULL,
        location TEXT,
        type TEXT NOT NULL -- مثلاً Firebox, Extinguisher, Panel
      )
    ''');

    // جدول بازرسی‌های ثبت شده
    await db.execute('''
      CREATE TABLE inspections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        equipment_id INTEGER,
        inspector_name TEXT,
        inspection_date TEXT,
        status TEXT, -- کامل شده یا ناقص
        FOREIGN KEY (equipment_id) REFERENCES equipments (id)
      )
    ''');

    // جدول پاسخ سؤالات
    await db.execute('''
      CREATE TABLE inspection_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        inspection_id INTEGER,
        question_id TEXT,
        answer TEXT, -- بله، خیر، N/A
        comments TEXT,
        FOREIGN KEY (inspection_id) REFERENCES inspections (id)
      )
    ''');
  }
}
