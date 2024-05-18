import 'package:flutter_android_tv_box/data/models/model.dart';
import 'package:intl/intl.dart';

/// Model class for videos from back-end
class Videos extends Model {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String thumbnailPath;
  final String videoPath;
  final String createdAt;

  Videos({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnailPath,
    required this.videoPath,
    required this.createdAt,
  });

  factory Videos.fromMap(Map<String, dynamic> map) {
    return Videos(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      thumbnailPath: map['thumbnail_path'] as String,
      videoPath: map['video_path'] as String,
      createdAt: getFormattedDate(map['created_at']),
    );
  }

  static String getFormattedDate(String dateTime) {
    return DateFormat('MMMM d, yyyy   hh:mm a').format(DateTime.parse(dateTime));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'thumbnail_path': thumbnailPath,
      'video_path': videoPath,
      'created_at': createdAt,
    };
  }
}
