import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<List<Announcement>> getAnnouncements() async {
  final Uri url = Uri.parse('https://android-tv.loca.lt/api/get-announcements');
  const String token = 'e94061b3-bc9f-489d-99ce-ef9e8c9058ce';

  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((data) => Announcement.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class Announcement {
  final int id;
  final String title;
  final String message;
  final DateTime createdAt;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
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

class AnnouncementsTab extends StatefulWidget {
  const AnnouncementsTab({super.key});

  @override
  State<AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<AnnouncementsTab> {
  late List<Announcement> _announcements = [];
  bool _isContentEmpty = false;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    try {
      final announcements = await getAnnouncements();
      setState(() {
        _announcements = announcements;
        _isContentEmpty = _announcements.isEmpty;
      });
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: _content());
  }

  Widget _content() {
    if (_announcements.isEmpty && _isContentEmpty) {
      return const Text('No Content');
    }

    if (_announcements.isNotEmpty) {
      return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
          itemBuilder: (BuildContext context, int index) {
            final announcement = _announcements[index];
            return ListTile(
              focusColor: Colors.green[900],
              tileColor: Colors.grey[800],
              textColor: Colors.white,
              title: Text(
                announcement.title,
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: SizedBox(
                height: 100,
                child: Text(
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    announcement.message),
              ),
              trailing: Text(announcement.getFormattedDate()),
              onTap: () => _viewAnnouncement(context, announcement.message),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: _announcements.length);
    }

    return const CircularProgressIndicator();
  }

  void _viewAnnouncement(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey[900],
                child: SingleChildScrollView(
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              )),
          Expanded(
              child: Center(
            child: TextButton(
              autofocus: true,
              onPressed: () {
                Navigator.pop(context);
              }, // Implement clear logic
              child: const Text(
                'Back',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ))
        ],
      )),
    );
  }
}
