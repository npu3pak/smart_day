import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'schedule.dart';
import 'schedule_event.dart';

class ScheduleDao {
  static const String _scheduleTable = 'schedule';
  static const String _scheduleEventTable = 'schedule_event';

  late final Database _db;

  ScheduleDao();

  Future<void> initDatabase() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'schedules_database.db'),
      onCreate: (db, version) {
        return createTables(db);
      },
      version: 1,
    );
  }

  Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE $_scheduleTable (
        id INTEGER PRIMARY KEY,
        date TEXT
      )
    ''');

    await _db.execute('''
      CREATE TABLE $_scheduleEventTable (
        id INTEGER PRIMARY KEY,
        schedule_id INTEGER,
        title TEXT,
        start_time INTEGER,
        FOREIGN KEY(schedule_id) REFERENCES $_scheduleTable(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertSchedule(Schedule schedule) async {
    final scheduleId = await _db.insert(_scheduleTable, {
      'date': schedule.date.toIso8601String(),
    });

    for (final event in schedule.events) {
      await _db.insert(_scheduleEventTable, {
        'schedule_id': scheduleId,
        'title': event.title,
        'start_time': event.startTime.millisecondsSinceEpoch,
      });
    }
    return scheduleId;
  }

  Future<Schedule?> getScheduleForDate(DateTime date) async {
    final schedulesData = await _db.query(_scheduleTable,
        where: 'date = ?', whereArgs: [date.toIso8601String()]);
    if (schedulesData.isEmpty) {
      return null;
    }

    final scheduleId = schedulesData.first['id'] as int;

    final eventsData = await _db.query(
      _scheduleEventTable,
      where: 'schedule_id = ?',
      whereArgs: [scheduleId],
    );

    final events = eventsData.map((eventData) {
      return ScheduleEvent(
        id: eventData['id'] as int,
        title: eventData['title'] as String,
        startTime: DateTime.fromMillisecondsSinceEpoch(
          eventData['start_time'] as int,
        ),
      );
    }).toList();

    return Schedule(id: scheduleId, date: date, events: events);
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final scheduleId = await _db.update(
        _scheduleTable,
        {
          'date': schedule.date.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [schedule.id]);

    await _db.delete(_scheduleEventTable,
        where: 'schedule_id = ?', whereArgs: [scheduleId]);

    for (final event in schedule.events) {
      await _db.insert(_scheduleEventTable, {
        'schedule_id': scheduleId,
        'title': event.title,
        'start_time': event.startTime.millisecondsSinceEpoch,
      });
    }
  }

  Future<void> insertScheduleEvent(int scheduleId, ScheduleEvent event) async {
    await _db.insert(_scheduleEventTable, {
      'schedule_id': scheduleId,
      'title': event.title,
      'start_time': event.startTime.millisecondsSinceEpoch,
    });
  }

  Future<List<ScheduleEvent>> getScheduleEvents(int scheduleId) async {
    final eventsData = await _db.query(
      _scheduleEventTable,
      where: 'schedule_id = ?',
      whereArgs: [scheduleId],
    );

    return eventsData.map((eventData) {
      return ScheduleEvent(
        id: eventData['id'] as int,
        title: eventData['title'] as String,
        startTime: DateTime.fromMillisecondsSinceEpoch(
          eventData['start_time'] as int,
        ),
      );
    }).toList();
  }

  Future<void> updateScheduleEvent(ScheduleEvent event) async {
    await _db.update(
      _scheduleEventTable,
      {
        'title': event.title,
        'start_time': event.startTime.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteScheduleEvent(int eventId) async {
    await _db.delete(
      _scheduleEventTable,
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }
}
