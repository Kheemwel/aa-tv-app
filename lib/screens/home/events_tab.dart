import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/database/events_dao.dart';
import 'package:flutter_android_tv_box/data/models/events.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  late final EventsDAO _eventsDAO = EventsDAO();
  static List<Events> _events = [];
  bool _isContentEmpty = false;
  bool _noInternetConnection = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      EventsDAO.fetchEvents();
      _fetchEvents();
    });
  }

  Future<void> _fetchEvents() async {
    try {
      final events = await _eventsDAO.queryEvents();
      setState(() {
        _events = events;
        _isContentEmpty = _events.isEmpty;
      });
    } on SocketException {
      setState(() {
        _noInternetConnection = true;
      });
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: _content());
  }

  Widget _content() {
    if (_events.isEmpty && _isContentEmpty) {
      return const Text('No Content Available');
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
            focusColor: Palette.getColor('secondary'),
            tileColor: Palette.getColor('secondary-background'),
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
                    'Start: ${announcement.eventStart}',
                    style: TextStyle(color: Palette.getColor('text-dark'), fontSize: 12),
                  ),
                  Text(
                    'End: ${announcement.eventEnd}',
                    style: TextStyle(color: Palette.getColor('text-dark'), fontSize: 12),
                  ),
                ],
              ),
            ),
            subtitle: Text(
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                announcement.description),
                onTap: () {},
          );
        },
      );
    }
    
    if (_noInternetConnection) {
      return const Text('No Internet Connection');
    }

    return const CircularProgressIndicator();
  }
  
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
