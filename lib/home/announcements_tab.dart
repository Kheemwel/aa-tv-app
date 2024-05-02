import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          final announcement = _announcements[index];
          return ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            focusColor: Colors.green[900],
            tileColor: Colors.grey[800],
            textColor: Colors.white,
            title: SizedBox(
              height: 75,
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
                    announcement.getFormattedDate(),
                    style: TextStyle(color: Colors.grey[300], fontSize: 12),
                  ),
                ],
              ),
            ),
            subtitle: Text(
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                announcement.message),
            onTap: () => _viewAnnouncement(
                context, announcement.title, announcement.message),
          );
        },
      );
    }

    return const CircularProgressIndicator();
  }

  void _viewAnnouncement(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Row(
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[900],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20)),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          message,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
            SizedBox(
                width: 100,
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
        ),
      ),
    );
  }
}
