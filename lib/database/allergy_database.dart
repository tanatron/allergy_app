import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/allergy.dart';

class AllergyDatabase {
  static final AllergyDatabase instance = AllergyDatabase._init();
  static Database? _database;

  AllergyDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('allergies.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE allergies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        allergen_name TEXT NOT NULL,
        allergy_type TEXT NOT NULL,
        severity TEXT NOT NULL,
        symptoms TEXT NOT NULL,
        treatment TEXT,
        diagnosed_date TEXT NOT NULL,
        notes TEXT,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  Future<Allergy> create(Allergy allergy) async {
    final db = await instance.database;
    final id = await db.insert('allergies', allergy.toMap());
    return allergy.copyWith(id: id);
  }

  Future<List<Allergy>> readAll() async {
    final db = await instance.database;
    final result = await db.query(
      'allergies',
      orderBy: 'diagnosed_date DESC',
    );
    return result.map((map) => Allergy.fromMap(map)).toList();
  }

  Future<Allergy?> readById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'allergies',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Allergy.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(Allergy allergy) async {
    final db = await instance.database;
    return db.update(
      'allergies',
      allergy.toMap(),
      where: 'id = ?',
      whereArgs: [allergy.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'allergies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Allergy>> filterByType(String type) async {
    final db = await instance.database;
    final result = await db.query(
      'allergies',
      where: 'allergy_type = ?',
      whereArgs: [type],
      orderBy: 'diagnosed_date DESC',
    );
    return result.map((map) => Allergy.fromMap(map)).toList();
  }

  Future<List<Allergy>> filterBySeverity(String severity) async {
    final db = await instance.database;
    final result = await db.query(
      'allergies',
      where: 'severity = ?',
      whereArgs: [severity],
      orderBy: 'diagnosed_date DESC',
    );
    return result.map((map) => Allergy.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}