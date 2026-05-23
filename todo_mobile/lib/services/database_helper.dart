import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // 获取数据库实例（单例模式）
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // 创建表 (注意：没有 user_id 字段，因为是设备级共享)
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      content TEXT NOT NULL, 
      summary TEXT,
      updated_at TEXT NOT NULL,
      created_at TEXT NOT NULL,  -- (新增)
      type TEXT NOT NULL         -- (新增)
    )
    ''');


    // --- (新增) 刷题历史表 ---
    await db.execute('''
    CREATE TABLE practice_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      type TEXT NOT NULL,
      options TEXT,
      explanation TEXT,
      user_answer TEXT,
      user_thought TEXT,
      score INTEGER,
      comment TEXT,
      improvement TEXT,
      reference_answer TEXT,
      created_at TEXT NOT NULL
    )
    ''');


  }

  // --- CRUD 操作 ---

  Future<int> create(Map<String, dynamic> json) async {
    final db = await database;
    return await db.insert('notes', json);
  }

  Future<List<Map<String, dynamic>>> readAllNotes() async {
    final db = await database;
    // 按更新时间倒序排列
    return await db.query('notes', orderBy: 'updated_at DESC');
  }

  Future<int> update(Map<String, dynamic> json) async {
    final db = await database;
    final id = json['id'];
    return await db.update(
      'notes',
      json,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertPracticeRecord(Map<String, dynamic> json) async {
    final db = await database;
    return await db.insert('practice_history', json);
  }

  // (新增) 获取所有历史
  Future<List<Map<String, dynamic>>> getPracticeHistory() async {
    final db = await database;
    return await db.query('practice_history', orderBy: 'created_at DESC');
  }

}