import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'assignment.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

   Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      contactNumber TEXT,
      email TEXT,
      startDate TEXT,
      submissionDate TEXT
    )
  ''');
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        imageUrl TEXT,
        timeAdded TEXT,
        rating INTEGER,
        numberOfViews INTEGER
      )
    ''');
  }
      Future<int> createUser(String username, String password, String contactNumber, String email, String startDate, String submissionDate) async {
    final db = await instance.database;
    final id = await db.insert('users', {
      'username': username,
      'password': password,
      'contactNumber': contactNumber,
      'email': email,
      'startDate': startDate,
      'submissionDate': submissionDate,
    });
    return id;
  }
   Future<int> changePassword(String username, String newPassword) async {
    final db = await instance.database;
    return await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [username],
    );
  }
  Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await instance.database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [username]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
 

   Future<List<Item>> getItems() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');

    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
        timeAdded: maps[i]['timeAdded'],
        rating: maps[i]['rating'],
        numberOfViews: maps[i]['numberOfViews'],
      );
    });
  }

  Future<int> insertItem(Item item) async {
    Database db = await database;
    return await db.insert('items', item.toMap());
  }
  Future<int> updateItem(Item item) async {
    Database db = await database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

}
