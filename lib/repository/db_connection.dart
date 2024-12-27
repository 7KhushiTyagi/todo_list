import 'package:sqflite/sqflite.dart';
import 'dart:io'; // For Directory
import 'package:path_provider/path_provider.dart'; // For getApplicationDocumentsDirectory
import 'package:path/path.dart'; // For join()

class DataBaseConnection {
  Future<Database> setDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'db_todolist_sqflite.db');

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreatingDataBase,
    );

    return database;
  }

  Future<void> _onCreatingDataBase(Database database, int version) async {
    await database.execute('''
      CREATE TABLE Categories(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT
      )
    ''');

    await database.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        category TEXT,
        todoDate TEXT,
        isFinished INTEGER
      )
    ''');
  }
}
