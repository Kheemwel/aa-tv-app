import 'package:flutter_android_tv_box/data/models/model.dart';
import 'package:intl/intl.dart';

/// Model class for announcements from back-end
class Announcements extends Model {
  final int? id;
  final String title;
  final String message;
  final String createdAt;

  Announcements({
    this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory Announcements.fromMap(Map<String, dynamic> map) {
    return Announcements(
      id: map['id'] as int,
      title: map['title'] as String,
      message: map['message'] as String,
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
      'message': message,
      'created_at': createdAt
    };
  }
}
