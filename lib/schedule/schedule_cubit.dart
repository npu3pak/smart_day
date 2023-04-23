import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_day/schedule/schedule.dart';
import 'package:smart_day/schedule/schedule_event.dart';
import 'package:smart_day/schedule/schedule_repository.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final DateTime date;
  final ScheduleRepository repository;

  ScheduleCubit({
    required this.date,
    required this.repository,
  }) : super(ScheduleInitial());

  Future<void> start() async {
    emit(ScheduleLoading());

    Schedule? schedule = await repository.getScheduleForDate(date);

    if (schedule == null) {
      schedule = Schedule(id: null, date: date, events: const []);
      int id = await repository.addSchedule(schedule);
      schedule = schedule.copyWith(id: id);
    }

    emit(ScheduleLoaded(schedule));
  }

  Future<void> addEvent(ScheduleEvent event) async {
    final currentState = state;

    if (currentState is ScheduleLoaded) {
      final updatedEvents = List.of(currentState.schedule.events)..add(event);
      final updatedSchedule =
          currentState.schedule.copyWith(events: updatedEvents);

      await repository.updateSchedule(updatedSchedule);

      emit(ScheduleLoaded(updatedSchedule));
    }
  }

  Future<void> updateEvent(ScheduleEvent event) async {
    final currentState = state;

    if (currentState is ScheduleLoaded) {
      final updatedEvents = List.of(currentState.schedule.events);
      final index = updatedEvents.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        updatedEvents[index] = event;
        final updatedSchedule =
            currentState.schedule.copyWith(events: updatedEvents);
        await repository.updateSchedule(updatedSchedule);

        emit(ScheduleLoaded(updatedSchedule));
      }
    }
  }

  Future<void> deleteEvent(int eventId) async {
    final currentState = state;

    if (currentState is ScheduleLoaded) {
      final updatedEvents = List.of(currentState.schedule.events)
        ..removeWhere((e) => e.id == eventId);
      final updatedSchedule =
          currentState.schedule.copyWith(events: updatedEvents);
      await repository.updateSchedule(updatedSchedule);

      emit(ScheduleLoaded(updatedSchedule));
    }
  }
}
