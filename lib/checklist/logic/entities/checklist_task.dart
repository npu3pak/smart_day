class ChecklistTask {
  final int? id;
  final String title;
  final bool isComplete;

  ChecklistTask({this.id, required this.title, this.isComplete = false});

  ChecklistTask copyWith({int? id, String? title, bool? isComplete}) {
    return ChecklistTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'is_complete': isComplete ? 1 : 0,
    };
  }

  factory ChecklistTask.fromMap(Map<String, dynamic> map) {
    return ChecklistTask(
      id: map['id'],
      title: map['title'],
      isComplete: map['is_complete'] == 1,
    );
  }
}
