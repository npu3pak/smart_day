import 'package:smart_day/schedule/schedule.dart';
import 'package:smart_day/schedule/schedule_dao.dart';
import 'package:smart_day/schedule/schedule_event.dart';

class ScheduleRepository {
  final ScheduleDao _scheduleDao;

  ScheduleRepository(this._scheduleDao);

  Future<void> init() async {
    await _scheduleDao.initDatabase();
  }

  Future<int> addSchedule(Schedule schedule) async {
    return await _scheduleDao.insertSchedule(schedule);
  }

  Future<Schedule?> getScheduleForDate(DateTime date) async {
    return await _scheduleDao.getScheduleForDate(date);
  }

  Future<void> updateSchedule(Schedule schedule) async {
    await _scheduleDao.updateSchedule(schedule);
  }

  Future<void> addScheduleEvent(int scheduleId, ScheduleEvent event) async {
    await _scheduleDao.insertScheduleEvent(scheduleId, event);
  }

  Future<List<ScheduleEvent>> getScheduleEvents(int scheduleId) async {
    return await _scheduleDao.getScheduleEvents(scheduleId);
  }

  Future<void> updateScheduleEvent(ScheduleEvent event) async {
    await _scheduleDao.updateScheduleEvent(event);
  }

  Future<void> deleteScheduleEvent(int eventId) async {
    await _scheduleDao.deleteScheduleEvent(eventId);
  }
}
