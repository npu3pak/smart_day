part of 'schedule_date_cubit.dart';

abstract class ScheduleDateState extends Equatable {
  const ScheduleDateState();

  @override
  List<Object?> get props => [];
}

class ScheduleDateInitial extends ScheduleDateState {}

class ScheduleDateSelected extends ScheduleDateState {
  final DateTime date;

  const ScheduleDateSelected(this.date);

  @override
  List<Object?> get props => [date];
}
