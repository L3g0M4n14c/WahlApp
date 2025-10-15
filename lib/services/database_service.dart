import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/voter.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('voters.db');
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
      CREATE TABLE voters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pkNumber TEXT NOT NULL UNIQUE,
        lastName TEXT NOT NULL,
        firstName TEXT NOT NULL,
        hasVoted INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<Voter> createVoter(Voter voter) async {
    final db = await instance.database;
    final id = await db.insert('voters', voter.toMap());
    return voter.copyWith(id: id);
  }

  Future<List<Voter>> getAllVoters() async {
    final db = await instance.database;
    final result = await db.query(
      'voters',
      orderBy: 'lastName ASC, firstName ASC',
    );
    return result.map((map) => Voter.fromMap(map)).toList();
  }

  Future<List<Voter>> searchVoters(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'voters',
      where: 'pkNumber LIKE ? OR lastName LIKE ? OR firstName LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'lastName ASC, firstName ASC',
    );
    return result.map((map) => Voter.fromMap(map)).toList();
  }

  Future<int> updateVoter(Voter voter) async {
    final db = await instance.database;
    return db.update(
      'voters',
      voter.toMap(),
      where: 'id = ?',
      whereArgs: [voter.id],
    );
  }

  Future<int> deleteVoter(int id) async {
    final db = await instance.database;
    return await db.delete(
      'voters',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
