import 'package:equatable/equatable.dart';

import 'schedule_event.dart';

class Schedule extends Equatable {
  final int? id;
  final DateTime date;
  final List<ScheduleEvent> events;

  const Schedule({
    required this.id,
    required this.date,
    required this.events,
  });

  Schedule copyWith({
    int? id,
    DateTime? date,
    List<ScheduleEvent>? events,
  }) {
    return Schedule(
      id: id ?? this.id,
      date: date ?? this.date,
      events: events ?? List.from(this.events),
    );
  }

  @override
  List<Object?> get props => [id, date, events];
}
