import 'package:flutter_android_tv_box/data/database/sqlite_database_helper.dart';
import 'package:flutter_android_tv_box/data/models/announcements.dart';
import 'package:flutter_android_tv_box/data/network/fetch_data.dart';

/// Utility class for handling announcements in database
class AnnouncementsDAO {
  static const String tableName = 'announcements';

  static final SQLiteDatabaseHelper sqLiteDatabaseHelper = SQLiteDatabaseHelper();

  /// Insert announcement
  Future<void> insertAnnouncement(
      String title, String message, String createdAt) async {
    await sqLiteDatabaseHelper.insert(tableName, {
      'title': title,
      'message': message,
      'created_at': createdAt,
    });
  }

  /// Get the list of all announcements
  Future<List<Announcements>> queryAnnouncements() async {
    final List<Map<String, dynamic>> results =
        await sqLiteDatabaseHelper.getAll(tableName);
    return results.map((map) {
      return Announcements(
        id: map['id'] as int,
        title: map['title'] as String,
        message: map['message'] as String,
        createdAt: map['created_at'] as String,
      );
    }).toList();
  }

  /// Save the data from back-end to the database
  static Future<void> fetchAnnouncements() async {
    List<Announcements> announcements;
    try {
      announcements = await FetchData.getAnnouncements();
    } catch (e) {
      rethrow;
    }
    await sqLiteDatabaseHelper.clear(tableName);
    await sqLiteDatabaseHelper.batchInsert(tableName, announcements);
  }

  /// Update announcement
  Future<void> updateAnnouncement(Announcements announcement) async {
    await sqLiteDatabaseHelper.update(
      tableName,
      {
        'title': announcement.title,
        'message': announcement.message,
        'created_at': announcement.createdAt,
      },
      'id = ?',
      [announcement.id],
    );
  }

  /// Delete announcement by its id
  Future<void> deleteAnnouncement(int id) async {
    await sqLiteDatabaseHelper.delete(
      tableName,
      'id = ?',
      [id],
    );
  }

  /// Clear all announcements in the database
  Future<void> clearAnnouncements() async {
    await sqLiteDatabaseHelper.clear(tableName);
  }
}
