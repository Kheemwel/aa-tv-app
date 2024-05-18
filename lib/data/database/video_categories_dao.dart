import 'dart:async';

import 'package:flutter_android_tv_box/data/database/sqlite_database_helper.dart';
import 'package:flutter_android_tv_box/data/models/video_categories.dart';
import 'package:flutter_android_tv_box/data/network/fetch_data.dart';

/// Utility class for handling video categories in database
class VideoCategoriesDAO {
  static const String tableName = 'video_categories';

  static final SQLiteDatabaseHelper sqLiteDatabaseHelper =
      SQLiteDatabaseHelper();

  /// Insert video category
  Future<void> insertVideoCategory(String title, String categoryName) async {
    await sqLiteDatabaseHelper
        .insert(tableName, {'category_name': categoryName});
  }

  /// Get the list of all video categories
  Future<List<VideoCategories>> queryVideoCategories() async {
    final List<Map<String, dynamic>> results =
        await sqLiteDatabaseHelper.getAll(tableName);
    return results.map((map) {
      return VideoCategories(
        id: map['id'] as int,
        category: map['category_name'] as String,
      );
    }).toList();
  }

  /// Save the data from back-end to the database
  static Future<void> fetchVideoCategories() async {
    List<VideoCategories> categories;
    try {
      categories = await FetchData.getVideoCategories();
    } catch (e) {
      rethrow;
    }
    await sqLiteDatabaseHelper.clear(tableName);
    await sqLiteDatabaseHelper.batchInsert(tableName, categories);
  }

  /// Update video category
  Future<void> updateVideoCategory(VideoCategories videoCategory) async {
    await sqLiteDatabaseHelper.update(
      tableName,
      {
        'category_name': videoCategory.category,
      },
      'id = ?',
      [videoCategory.id],
    );
  }

  /// Delete video category by its id
  Future<void> deleteVideoCategory(int id) async {
    await sqLiteDatabaseHelper.delete(
      tableName,
      'id = ?',
      [id],
    );
  }

  /// Clear all video categories in the database
  Future<void> clearVideoCategories() async {
    await sqLiteDatabaseHelper.clear(tableName);
  }
}
