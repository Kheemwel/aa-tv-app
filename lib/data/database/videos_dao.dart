import 'package:flutter_android_tv_box/data/database/sqlite_database_helper.dart';
import 'package:flutter_android_tv_box/data/models/videos.dart';
import 'package:flutter_android_tv_box/data/network/fetch_data.dart';

/// Utility class for handling videos in database
class VideosDAO {
  static const String tableName = 'videos';

  static final SQLiteDatabaseHelper sqLiteDatabaseHelper = SQLiteDatabaseHelper();

  /// Insert video
  Future<void> insertVideo(String title, String description, String category,
      String thumbnailPath, String videoPath, String createdAt) async {
    await sqLiteDatabaseHelper.insert(tableName, {
      'title': title,
      'description': description,
      'category': category,
      'thumbnail_path': thumbnailPath,
      'video_path': videoPath,
      'created_at': createdAt,
    });
  }

  /// Get the list of all videos
  Future<List<Videos>> queryVideos(String category) async {
    final List<Map<String, dynamic>> results =
        await sqLiteDatabaseHelper.getAll(tableName, where: 'category = ?', whereArgs: [category]);
    return results.map((map) {
      return Videos(
        id: map['id'] as int,
        title: map['title'] as String,
        description: map['description'] as String,
        category: map['category'] as String,
        thumbnailPath: map['thumbnail_path'] as String,
        videoPath: map['video_path'] as String,
        createdAt: map['created_at'] as String,
      );
    }).toList();
  }

  /// Save the data from back-end to the database
  static Future<void> fetchVideos() async {
    List<Videos> videos;
    try {
      videos = await FetchData.getVideos();
    } catch (e) {
      rethrow;
    }
    await sqLiteDatabaseHelper.clear(tableName);
    await sqLiteDatabaseHelper.batchInsert(tableName, videos);
  }

  /// Update video
  Future<void> updateVideo(Videos video) async {
    await sqLiteDatabaseHelper.update(
      tableName,
      {
        'title': video.title,
        'description': video.description,
        'category': video.category,
        'thumbnail_path': video.thumbnailPath,
        'video_path': video.videoPath,
        'created_at': video.createdAt,
      },
      'id = ?',
      [video.id],
    );
  }

  /// Delete video by its id
  Future<void> deleteVideo(int id) async {
    await sqLiteDatabaseHelper.delete(
      tableName,
      'id = ?',
      [id],
    );
  }

  /// Clear all videos in the database
  Future<void> clearVideos() async {
    await sqLiteDatabaseHelper.clear(tableName);
  }
}
