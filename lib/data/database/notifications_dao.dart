import 'package:flutter_android_tv_box/data/database/sqlite_database_helper.dart';
import 'package:flutter_android_tv_box/data/models/notifications.dart';

/// Utility class for handling notifications in database
class NotificationsDAO {
  final String tableName = 'notifications';

  final SQLiteDatabaseHelper sqLiteDatabaseHelper = SQLiteDatabaseHelper();

  /// Insert notification
  Future<void> insertNotification(Notifications notification) async {
    await sqLiteDatabaseHelper.insert(tableName, notification.toMap());
  }

  /// Get the list of all notifications
  Future<List<Notifications>> queryNotifications() async {
    final List<Map<String, dynamic>> results =
        await sqLiteDatabaseHelper.getAll(tableName);
    return results.map((map) {
      return Notifications.fromMap(map);
    }).toList();
  }

  /// Update notification
  Future<void> updateNotification(Notifications notification) async {
    await sqLiteDatabaseHelper.update(
      tableName,
      notification.toMap(),
      'id = ?',
      [notification.id],
    );
  }

  /// Delete notification by its id
  Future<void> deleteNotification(int id) async {
    await sqLiteDatabaseHelper.delete(
      tableName,
      'id = ?',
      [id],
    );
  }

  /// Clear all notifications in the database
  Future<void> clearNotifications() async {
    await sqLiteDatabaseHelper.clear(tableName);
  }
}
