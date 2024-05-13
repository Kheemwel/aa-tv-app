import 'package:intl/intl.dart';

/// Model class for events from back-end
class Events {
  final int id;
  final String title;
  final String description;
  final DateTime eventStart;
  final DateTime eventEnd;

  Events(
      {required this.id,
      required this.title,
      required this.description,
      required this.eventStart,
      required this.eventEnd});

  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      eventStart: DateTime.parse(json['event_start'] as String),
      eventEnd: DateTime.parse(json['event_end'] as String),
    );
  }

  String getEventStart() {
    return DateFormat('MMMM d, yyyy (hh:mm a)').format(eventStart);
  }

  String getEventEnd() {
    return DateFormat('MMMM d, yyyy (hh:mm a)').format(eventEnd);
  }
}