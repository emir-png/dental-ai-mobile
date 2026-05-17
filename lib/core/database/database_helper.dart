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

    final db = await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    await _seedAdmin(db);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'user',
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE xrays (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        imagePath TEXT NOT NULL,
        resultImagePath TEXT,
        notes TEXT,
        uploadDate TEXT NOT NULL,
        status TEXT DEFAULT 'done',
        FOREIGN KEY (userId) REFERENCES users(id)
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
          role TEXT NOT NULL DEFAULT 'user',
          createdAt TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      // Add role column to existing users
      try {
        await db.execute(
            "ALTER TABLE users ADD COLUMN role TEXT NOT NULL DEFAULT 'user'");
      } catch (_) {}
      // Add userId column to existing xrays
      try {
        await db.execute(
            'ALTER TABLE xrays ADD COLUMN userId INTEGER');
      } catch (_) {}
    }
  }

  Future<void> _seedAdmin(Database db) async {
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: ['admin'],
    );
    if (results.isEmpty) {
      await db.insert('users', {
        'username': 'admin',
        'email': 'admin@dentalai.com',
        'password': 'admin123',
        'role': 'admin',
        'createdAt': DateTime.now().toIso8601String(),
      });
    } else {
      // Ensure existing admin has correct role
      final existing = results.first;
      if (existing['role'] != 'admin') {
        await db.update(
          'users',
          {'role': 'admin'},
          where: 'username = ?',
          whereArgs: ['admin'],
        );
      }
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
        'role': 'user',
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

  // USER MANAGEMENT (Admin)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users', orderBy: 'id ASC');
  }

  Future<bool> updateUserRole(int userId, String role) async {
    final db = await database;
    try {
      await db.update(
        'users',
        {'role': role},
        where: 'id = ?',
        whereArgs: [userId],
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<int> getUserXrayCount(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM xrays WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // XRAY CRUD
  Future<int> insertXray(Map<String, dynamic> xray) async {
    final db = await database;
    return await db.insert('xrays', xray);
  }

  /// Returns all xrays joined with username — for admin use
  Future<List<Map<String, dynamic>>> getAllXrays() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT x.*, u.username as ownerUsername
      FROM xrays x
      LEFT JOIN users u ON x.userId = u.id
      ORDER BY x.id DESC
    ''');
  }

  /// Returns xrays belonging to a specific user
  Future<List<Map<String, dynamic>>> getXraysByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'xrays',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
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

  Future<void> deletePrediction(int id) async {
    final db = await database;
    await db.delete(
      'predictions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Deletes an xray and all its related predictions
  Future<void> deleteXray(int id) async {
    final db = await database;
    // First delete all predictions for this xray
    await deletePredictionsByXrayId(id);
    // Then delete the xray itself
    await db.delete(
      'xrays',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
