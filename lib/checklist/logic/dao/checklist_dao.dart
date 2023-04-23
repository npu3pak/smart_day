import 'package:smart_day/checklist/logic/entities/checklist_task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChecklistDao {
  static const String _tableName = 'checklist';
  static const String _columnId = 'id';
  static const String _columnTitle = 'title';
  static const String _columnIsComplete = 'is_complete';

  late final Database _database;

  ChecklistDao();

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'checklist_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName($_columnId INTEGER PRIMARY KEY AUTOINCREMENT, $_columnTitle TEXT, $_columnIsComplete INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<List<ChecklistTask>> getAllTasks() async {
    final List<Map<String, dynamic>> maps = await _database.query(_tableName);

    return List.generate(maps.length, (i) {
      return ChecklistTask(
        id: maps[i][_columnId],
        title: maps[i][_columnTitle],
        isComplete: maps[i][_columnIsComplete] == 1,
      );
    });
  }

  Future<int> addTask(ChecklistTask task) async {
    return await _database.insert(
      _tableName,
      {
        _columnTitle: task.title,
        _columnIsComplete: task.isComplete ? 1 : 0,
      },
    );
  }

  Future<void> removeTask(int id) async {
    await _database.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTask(ChecklistTask task) async {
    await _database.update(
      _tableName,
      {
        _columnTitle: task.title,
        _columnIsComplete: task.isComplete ? 1 : 0,
      },
      where: '$_columnId = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> toggleTask(int id) async {
    final task = await getTask(id);
    await updateTask(task.copyWith(isComplete: !task.isComplete));
  }

  Future<ChecklistTask> getTask(int id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );

    return ChecklistTask(
      id: maps[0][_columnId],
      title: maps[0][_columnTitle],
      isComplete: maps[0][_columnIsComplete] == 1,
    );
  }
}
