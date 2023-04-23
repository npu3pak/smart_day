import 'package:equatable/equatable.dart';

class ScheduleEvent extends Equatable {
  final int id;
  final String title;
  final DateTime startTime;

  const ScheduleEvent({
    required this.id,
    required this.title,
    required this.startTime,
  });

  ScheduleEvent copyWith({
    int? id,
    String? title,
    DateTime? startTime,
  }) {
    return ScheduleEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
    );
  }

  @override
  List<Object> get props => [id, title, startTime];
}
