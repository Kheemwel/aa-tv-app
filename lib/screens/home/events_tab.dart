import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/models/events.dart';
import 'package:flutter_android_tv_box/data/network/fetch_data.dart';

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
      final events = await FetchData.getEvents();
      setState(() {
        _events = events;
        _isContentEmpty = _events.isEmpty;
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
                    'Start: ${announcement.getEventStart()}',
                    style: TextStyle(color: Palette.getColor('text-dark'), fontSize: 12),
                  ),
                  Text(
                    'End: ${announcement.getEventEnd()}',
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

    return const CircularProgressIndicator();
  }
}
