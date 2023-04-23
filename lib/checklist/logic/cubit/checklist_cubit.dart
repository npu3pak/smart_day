import 'package:bloc/bloc.dart';
import 'package:smart_day/checklist/logic/cubit/checklist_state.dart';
import 'package:smart_day/checklist/logic/entities/checklist_task.dart';
import 'package:smart_day/checklist/logic/repository/checklist_repository.dart';

class ChecklistCubit extends Cubit<ChecklistState> {
  final ChecklistRepository _repository;

  ChecklistCubit(this._repository) : super(ChecklistLoading());

  Future<void> loadTasks() async {
    emit(ChecklistLoading());

    try {
      final tasks = await _repository.getTasks();
      emit(ChecklistLoaded(tasks: tasks));
    } on Exception catch (e) {
      emit(ChecklistError(error: e, tasks: []));
    }
  }

  Future<void> addTask(String title) async {
    final task = ChecklistTask(title: title);
    emit(ChecklistSaving(tasks: state.tasks));

    try {
      int id = await _repository.addTask(task);
      final tasks = [...state.tasks, task.copyWith(id: id)];
      emit(ChecklistLoaded(tasks: tasks));
    } on Exception catch (e) {
      emit(ChecklistError(error: e, tasks: state.tasks));
    }
  }

  Future<void> removeTask(int id) async {
    emit(ChecklistSaving(tasks: state.tasks));

    try {
      await _repository.removeTask(id);
      final tasks = state.tasks.where((task) => task.id != id).toList();
      emit(ChecklistLoaded(tasks: tasks));
    } on Exception catch (e) {
      emit(ChecklistError(error: e, tasks: state.tasks));
    }
  }

  Future<void> updateTask(ChecklistTask task) async {
    emit(ChecklistSaving(tasks: state.tasks));

    try {
      await _repository.updateTask(task);
      final tasks = state.tasks.map((t) => t.id == task.id ? task : t).toList();
      emit(ChecklistLoaded(tasks: tasks));
    } on Exception catch (e) {
      emit(ChecklistError(error: e, tasks: state.tasks));
    }
  }

  Future<void> toggleTask(int id) async {
    emit(ChecklistSaving(tasks: state.tasks));

    try {
      final tasks = state.tasks.map((t) {
        if (t.id == id) {
          final toggledTask = t.copyWith(isComplete: !t.isComplete);
          _repository.updateTask(toggledTask);
          return toggledTask;
        } else {
          return t;
        }
      }).toList();

      emit(ChecklistLoaded(tasks: tasks));
    } on Exception catch (e) {
      emit(ChecklistError(error: e, tasks: state.tasks));
    }
  }
}
