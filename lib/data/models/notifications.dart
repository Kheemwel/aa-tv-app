import 'package:flutter_android_tv_box/data/models/model.dart';

/// Model class for notifications in database
class Notifications extends Model {
  final int? id;
  final String title;
  final String message;
  final String datetime;

  Notifications({
    this.id,
    required this.title,
    required this.message,
    required this.datetime,
  });

  factory Notifications.fromMap(Map<String, dynamic> map) {
    return Notifications(
        id: map['id'] as int,
        title: map['title'] as String,
        message: map['message'] as String,
        datetime: map['datetime'] as String,
      );
  }
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'datetime': datetime
    };
  }
}
