import 'package:intl/intl.dart';

/// Model class for videos from back-end
class Videos {
  final int id;
  final String title;
  final String description;
  final String category;
  final String thumbnailPath;
  final String videoPath;
  final DateTime createdAt;

  Videos({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnailPath,
    required this.videoPath,
    required this.createdAt,
  });

  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      thumbnailPath: json['thumbnail_path'] as String,
      videoPath: json['video_path'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  
  String getFormattedDate() {
    return DateFormat('MMMM d, yyyy   hh:mm a').format(createdAt);
  }
}
