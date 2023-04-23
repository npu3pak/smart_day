import 'package:smart_day/checklist/logic/entities/checklist_task.dart';

abstract class ChecklistState {
  final List<ChecklistTask> tasks;

  ChecklistState({required this.tasks});
}

class ChecklistLoading extends ChecklistState {
  ChecklistLoading() : super(tasks: []);
}

class ChecklistLoaded extends ChecklistState {
  ChecklistLoaded({required List<ChecklistTask> tasks}) : super(tasks: tasks);
}

class ChecklistSaving extends ChecklistState {
  ChecklistSaving({required List<ChecklistTask> tasks}) : super(tasks: tasks);
}

class ChecklistError extends ChecklistState {
  final dynamic error;

  ChecklistError({required this.error, required List<ChecklistTask> tasks})
      : super(tasks: tasks);
}
