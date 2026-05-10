import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dental_ai.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE xrays (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imagePath TEXT NOT NULL,
        resultImagePath TEXT,
        notes TEXT,
        uploadDate TEXT NOT NULL,
        status TEXT DEFAULT 'done'
      )
    ''');

    await db.execute('''
      CREATE TABLE predictions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        xrayId INTEGER NOT NULL,
        disease TEXT NOT NULL,
        confidence REAL NOT NULL,
        x1 REAL, y1 REAL, x2 REAL, y2 REAL,
        FOREIGN KEY (xrayId) REFERENCES xrays(id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL UNIQUE,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          createdAt TEXT NOT NULL
        )
      ''');
    }
  }

  // USER AUTH
  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final db = await database;
    try {
      await db.insert('users', {
        'username': username,
        'email': email,
        'password': password,
        'createdAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginUser({
    required String username,
    required String password,
  }) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<bool> isUsernameTaken(String username) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty;
  }

  Future<bool> isEmailTaken(String email) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty;
  }

  // XRAY CRUD
  Future<int> insertXray(Map<String, dynamic> xray) async {
    final db = await database;
    return await db.insert('xrays', xray);
  }

  Future<List<Map<String, dynamic>>> getAllXrays() async {
    final db = await database;
    return await db.query('xrays', orderBy: 'id DESC');
  }

  Future<Map<String, dynamic>?> getXrayById(int id) async {
    final db = await database;
    final results = await db.query(
      'xrays',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateXray(int id, Map<String, dynamic> xray) async {
    final db = await database;
    return await db.update(
      'xrays',
      xray,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // PREDICTION CRUD
  Future<int> insertPrediction(Map<String, dynamic> prediction) async {
    final db = await database;
    return await db.insert('predictions', prediction);
  }

  Future<List<Map<String, dynamic>>> getPredictionsByXrayId(int xrayId) async {
    final db = await database;
    return await db.query(
      'predictions',
      where: 'xrayId = ?',
      whereArgs: [xrayId],
      orderBy: 'confidence DESC',
    );
  }

  Future<void> deletePredictionsByXrayId(int xrayId) async {
    final db = await database;
    await db.delete(
      'predictions',
      where: 'xrayId = ?',
      whereArgs: [xrayId],
    );
  }
}