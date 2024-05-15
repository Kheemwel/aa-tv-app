import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/models/announcements.dart';
import 'package:flutter_android_tv_box/data/network/fetch_data.dart';

class AnnouncementsTab extends StatefulWidget {
  const AnnouncementsTab({super.key});

  @override
  State<AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<AnnouncementsTab> {
  static List<Announcements> _announcements = [];
  bool _isContentEmpty = false;
  bool _noInternetConnection = false;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    try {
      final announcements = await FetchData.getAnnouncements();
      setState(() {
        _announcements = announcements;
        _isContentEmpty = _announcements.isEmpty;
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
    if (_announcements.isEmpty && _isContentEmpty) {
      return const Text('No Content Available');
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
            focusColor: Palette.getColor('secondary'),
            tileColor: Palette.getColor('secondary-background'),
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
                    style: TextStyle(
                        color: Palette.getColor('text-dark'), fontSize: 12),
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
    
    if (_noInternetConnection) {
      return const Text('No Internet Connection');
    }

    return const CircularProgressIndicator();
  }

  void _viewAnnouncement(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
          child: Container(
        padding: const EdgeInsets.all(20),
        color: Palette.getColor('primary-background'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            Expanded(
              child: Center(
                  child: ScrollableText(
                text: message,
              )),
            )
          ],
        ),
      )),
    );
  }
}

class ScrollableText extends StatefulWidget {
  final String text;
  const ScrollableText({super.key, required this.text});

  @override
  State<ScrollableText> createState() => _YourWidgetState();
}

class _YourWidgetState extends State<ScrollableText> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          _controller.animateTo(
            _controller.offset - 50.0, // Adjust scroll speed as needed
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          _controller.animateTo(
            _controller.offset + 50.0, // Adjust scroll speed as needed
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(10),
        child: Text(
          widget.text,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
