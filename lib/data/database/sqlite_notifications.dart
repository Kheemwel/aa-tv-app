import 'package:flutter_android_tv_box/data/models/notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteNotifications {
  late Database _database;
  bool _isInitialized = false;

  SQLiteNotifications() {
    _initDatabase().then((_) {
      _isInitialized = true;
    });
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'android_tv_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notification('
          'id INTEGER PRIMARY KEY, '
          'title TEXT, '
          'message TEXT, '
          'datetime TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertNotification(
      String title, String message, String datetime) async {
    if (!_isInitialized) {
      await _initDatabase();
    }
    await _database.insert(
      'notification',
      {
        'title': title,
        'message': message,
        'datetime': datetime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Notifications>> queryNotifications() async {
    if (!_isInitialized) {
      await _initDatabase();
    }
    final List<Map<String, dynamic>> results =
        await _database.query('notification');
    return results.map((map) {
      return Notifications(
        id: map['id'] as int,
        title: map['title'] as String,
        message: map['message'] as String,
        datetime: map['datetime'] as String,
      );
    }).toList();
  }

  Future<void> updateNotification(Notifications notification) async {
    if (!_isInitialized) {
      await _initDatabase();
    }
    await _database.update(
      'notification',
      {
        'title': notification.title,
        'message': notification.message,
        'datetime': notification.datetime,
      },
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  Future<void> deleteNotification(int id) async {
    if (!_isInitialized) {
      await _initDatabase();
    }
    await _database.delete(
      'notification',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearNotifications() async {
    if (!_isInitialized) {
      await _initDatabase();
    }
    await _database.delete('notification');
  }

  void dispose() {
    _database.close();
  }
}

