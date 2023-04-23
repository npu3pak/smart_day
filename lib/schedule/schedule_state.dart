part of 'schedule_cubit.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final Schedule schedule;

  const ScheduleLoaded(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class ScheduleLoadError extends ScheduleState {
  final String message;

  const ScheduleLoadError(this.message);

  @override
  List<Object?> get props => [message];
}
