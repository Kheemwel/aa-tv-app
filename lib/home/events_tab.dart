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
      return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
          itemBuilder: (BuildContext context, int index) {
            final event = _events[index];
            return ListTile(
              focusColor: Colors.green[900],
              tileColor: Colors.grey[800],
              textColor: Colors.white,
              title: Text(
                event.title,
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: SizedBox(
                height: 100,
                child: Text(
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    event.description),
              ),
              trailing: Column(
                children: [
                  Text('Start: ${event.getEventStart()}'),
                  Text('End: ${event.getEventEnd()}')
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: _events.length);
    }

    return const CircularProgressIndicator();
  }
}
