import 'package:flutter_android_tv_box/data/database/sqlite_database_helper.dart';
import 'package:flutter_android_tv_box/data/models/events.dart';
import 'package:flutter_android_tv_box/data/network/fetch_data.dart';

/// Utility class for handling events in database
class EventsDAO {
  static const String tableName = 'events';

  static final SQLiteDatabaseHelper sqLiteDatabaseHelper = SQLiteDatabaseHelper();

  /// Insert event
  Future<void> insertEvent(String title, String description, String eventStart,
      String eventEnd) async {
    await sqLiteDatabaseHelper.insert(tableName, {
      'title': title,
      'description': description,
      'event_start': eventStart,
      'event_end': eventEnd,
    });
  }

  /// Get the list of all events
  Future<List<Events>> queryEvents() async {
    final List<Map<String, dynamic>> results =
        await sqLiteDatabaseHelper.getAll(tableName);
    return results.map((map) {
      return Events(
        id: map['id'] as int,
        title: map['title'] as String,
        description: map['description'] as String,
        eventStart: map['event_start'] as String,
        eventEnd: map['event_end'] as String,
      );
    }).toList();
  }

  /// Save the data from back-end to the database
  static Future<void> fetchEvents() async {
    List<Events> events;
    try {
      events = await FetchData.getEvents();
    } catch (e) {
      rethrow;
    }
    await sqLiteDatabaseHelper.clear(tableName);
    await sqLiteDatabaseHelper.batchInsert(tableName, events);
  }

  /// Update event
  Future<void> updateEvent(Events event) async {
    await sqLiteDatabaseHelper.update(
      tableName,
      {
        'title': event.title,
        'description': event.description,
        'event_start': event.eventStart,
        'event_end': event.eventEnd,
      },
      'id = ?',
      [event.id],
    );
  }

  /// Delete event by its id
  Future<void> deleteEvent(int id) async {
    await sqLiteDatabaseHelper.delete(
      tableName,
      'id = ?',
      [id],
    );
  }

  /// Clear all events in the database
  Future<void> clearEvents() async {
    await sqLiteDatabaseHelper.clear(tableName);
  }
}
