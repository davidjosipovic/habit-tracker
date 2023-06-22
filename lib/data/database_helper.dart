import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'habit.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<void> initializeDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'habit_tracker.db');
    _database = await openDatabase(path, version: 2, onCreate: _createDb); // Change the version number if needed
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'habit_tracker.db');
    return openDatabase(
      path,
      version: 2, // Change the version number if needed
      onCreate: _createDb,
      onUpgrade: _onUpgrade, // Add the onUpgrade callback
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE habits (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      isCompleted INTEGER,
      reminder INTEGER
    )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE habits ADD COLUMN reminder INTEGER');
    }
    // Add upgrade scripts for other versions if needed
  }

  Future<List<Habit>> getHabits() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) {
      return Habit.fromMap(maps[i]);
    });
  }

  Future<int> insertHabit(Habit habit) async {
    final db = await instance.database;
    return await db.insert('habits', habit.toMap());
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await instance.database;
    return await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await instance.database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleHabitCompletion(Habit habit) async {
    final db = await instance.database;
    habit.isCompleted = !habit.isCompleted; // Toggle the completion state
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> editHabit(Habit habit) async {
    final db = await instance.database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }
}
