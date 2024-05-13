import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/models/announcements.dart';
import 'package:flutter_android_tv_box/data/network/fetch_data.dart';

class AnnouncementsTab extends StatefulWidget {
  const AnnouncementsTab({super.key});

  @override
  State<AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<AnnouncementsTab> {
  late List<Announcements> _announcements = [];
  bool _isContentEmpty = false;

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
                    style: TextStyle(color: Palette.getColor('text-dark'), fontSize: 12),
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
              color: Palette.getColor('primary-background'),
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
