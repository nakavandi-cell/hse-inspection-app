import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/inspection_model.dart';
import '../models/answer_model.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  String get inspectionsTable => 'inspections';
  String get answersTable => 'answers';

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
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE inspections (
        id TEXT PRIMARY KEY,
        title TEXT,
        checklistId TEXT,
        checklistTitle TEXT,
        checklistCode TEXT,
        checklistCategory TEXT,
        status TEXT,
        createdAt TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE answers (
        id TEXT PRIMARY KEY,
        inspectionId TEXT,
        questionId TEXT,
        status TEXT,
        note TEXT,
        answeredAt TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS inspections');
      await db.execute('DROP TABLE IF EXISTS answers');
      await _createDB(db, newVersion);
    }
  }

  Future<List<InspectionModel>> getAllInspections() async {
    final db = await database;
    final inspectionMaps = await db.query('inspections', orderBy: 'createdAt DESC');
    
    final List<InspectionModel> results = [];
    for (var map in inspectionMaps) {
      final id = map['id'].toString();
      final answerMaps = await db.query(
        'answers',
        where: 'inspectionId = ?',
        whereArgs: [id],
      );
      final answers = answerMaps.map((a) => AnswerModel.fromDbMap(a)).toList();
      results.add(InspectionModel.fromDbMap(map, answers: answers));
    }
    return results;
  }

  Future<int> deleteInspection(String id) async {
    final db = await database;
    await db.delete('answers', where: 'inspectionId = ?', whereArgs: [id]);
    return await db.delete('inspections', where: 'id = ?', whereArgs: [id]);
  }
}
