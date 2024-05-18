import 'package:flutter_android_tv_box/data/models/model.dart';
import 'package:intl/intl.dart';

/// Model class for events from back-end
class Events extends Model {
  final int? id;
  final String title;
  final String description;
  final String eventStart;
  final String eventEnd;

  Events(
      {this.id,
      required this.title,
      required this.description,
      required this.eventStart,
      required this.eventEnd});

  factory Events.fromMap(Map<String, dynamic> map) {
    return Events(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      eventStart: getFormattedDate(map['event_start']),
      eventEnd: getFormattedDate(map['event_end']),
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
      'event_start': eventStart,
      'event_end': eventEnd,
    };
  }
}
