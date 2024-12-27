import 'package:sqflite/sqflite.dart';
import 'package:todo_list/repository/db_connection.dart';

class Repository {
  late DataBaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DataBaseConnection();
  }

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _databaseConnection.setDatabase();
    return _database!;
  }

  Future<int> insertData(String table, Map<String, dynamic> data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> readData(String table) async {
    var connection = await database;
    return await connection.query(table);
  }

  Future<Map<String, dynamic>?> readDataById(String table, int id) async {
    var connection = await database;
    var result = await connection.query(table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateData(String table, Map<String, dynamic> data, int id) async {
    var connection = await database;
    return await connection.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteData(String table, int id) async {
    var connection = await database;
    return await connection.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllData(String table) async {
    var connection = await database;
    return await connection.delete(table);
  }
}
