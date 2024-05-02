import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<List<Events>> getEvents() async {
  final Uri url = Uri.parse('https://android-tv.loca.lt/api/get-events');
  const String token = 'e94061b3-bc9f-489d-99ce-ef9e8c9058ce';

  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((data) => Events.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

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

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  late List<Events> _events = [];
  bool _isContentEmpty = false;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final events = await getEvents();
      setState(() {
        _events = events;
        _isContentEmpty = _events.isEmpty;
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: _content());
  }

  Widget _content() {
    if (_events.isEmpty && _isContentEmpty) {
      return const Text('No Content');
    }

    if (_events.isNotEmpty) {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final announcement = _events[index];
          return ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            focusColor: Colors.green[900],
            tileColor: Colors.grey[800],
            textColor: Colors.white,
            title: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Start: ${announcement.getEventStart()}',
                    style: TextStyle(color: Colors.grey[300], fontSize: 12),
                  ),
                  Text(
                    'End: ${announcement.getEventEnd()}',
                    style: TextStyle(color: Colors.grey[300], fontSize: 12),
                  ),
                ],
              ),
            ),
            subtitle: Text(
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                announcement.description),
          );
        },
      );
    }

    return const CircularProgressIndicator();
  }
}
