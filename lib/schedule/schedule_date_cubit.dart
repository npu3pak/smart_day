import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'schedule_date_state.dart';

class ScheduleDateCubit extends Cubit<ScheduleDateState> {
  ScheduleDateCubit(DateTime initialDate)
      : super(ScheduleDateSelected(initialDate));

  void selectDate(DateTime date) {
    emit(ScheduleDateSelected(date));
  }

  void nextDay() {
    final currentState = state;

    if (currentState is ScheduleDateSelected) {
      final nextDate = currentState.date.add(const Duration(days: 1));
      emit(ScheduleDateSelected(nextDate));
    }
  }

  void previousDay() {
    final currentState = state;

    if (currentState is ScheduleDateSelected) {
      final previousDate = currentState.date.subtract(const Duration(days: 1));
      emit(ScheduleDateSelected(previousDate));
    }
  }
}
