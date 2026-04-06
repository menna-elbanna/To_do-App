import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class sqlsafe1 {
  static Database? _dbb;

  Future<Database?> get db async {
    if (_dbb == null) {
      _dbb = await intialdbb();
    }
    return _dbb;
  }

  Future<Database?> intialdbb() async {
    String databasepathh = await getDatabasesPath();
    String path = join(databasepathh, 'todo.db');
    return await openDatabase(path, version: 1, onCreate: _oncreate);
  }

  Future _oncreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todolist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskName TEXT NOT NULL,
        isDone INTEGER NOT NULL
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> readData() async {
    Database? myDBB = await db;
    return await myDBB!.query('todolist');
  }

  Future<int> insertData(String taskName) async {
    Database? myDBB = await db;
    return await myDBB!.insert('todolist', {
      'taskName': taskName,
      'isDone': 0, // Default to not done
    });
  }

  Future<int> updateStatus(int id, int isDone) async {
    Database? myDBB = await db;
    return await myDBB!.update(
      'todolist',
      {'isDone': isDone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteData(int id) async {
    Database? myDBB = await db;
    return await myDBB!.delete('todolist', where: 'id = ?', whereArgs: [id]);
  }
}