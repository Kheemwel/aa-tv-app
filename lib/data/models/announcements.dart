import 'package:intl/intl.dart';

/// Model class for announcements from back-end
class Announcements {
  final int id;
  final String title;
  final String message;
  final DateTime createdAt;

  Announcements({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory Announcements.fromJson(Map<String, dynamic> json) {
    return Announcements(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  String getFormattedDate() {
    return DateFormat('MMMM d, yyyy   hh:mm a').format(createdAt);
  }
}