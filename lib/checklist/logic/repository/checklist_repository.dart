import 'package:smart_day/checklist/logic/dao/checklist_dao.dart';
import 'package:smart_day/checklist/logic/entities/checklist_task.dart';

class ChecklistRepository {
  final ChecklistDao _dao;

  ChecklistRepository(this._dao);

  Future<List<ChecklistTask>> getTasks() async {
    return _dao.getAllTasks();
  }

  Future<int> addTask(ChecklistTask task) async {
    return await _dao.addTask(task);
  }

  Future<void> removeTask(int id) async {
    await _dao.removeTask(id);
  }

  Future<void> updateTask(ChecklistTask task) async {
    await _dao.updateTask(task);
  }

  Future<void> toggleTask(int id) async {
    await _dao.toggleTask(id);
  }
}
