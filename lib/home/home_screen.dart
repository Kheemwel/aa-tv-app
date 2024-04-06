import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/custom_widgets/focus_twinkling_border_button.dart';
import 'package:flutter_android_tv_box/home/announcements_tab.dart';
import 'package:flutter_android_tv_box/home/events_tab.dart';
import 'package:flutter_android_tv_box/home/menu_button.dart';
import 'package:flutter_android_tv_box/home/videos_tab.dart';
import 'package:flutter_android_tv_box/notifications/notifications_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final TabBar _tabBar = const TabBar.secondary(
    indicatorPadding: EdgeInsets.zero,
    tabs: <Widget>[
      CustomTab(autofocus: true, text: 'Videos', icon: Icons.video_collection),
      CustomTab(text: 'Announcements', icon: Icons.notifications),
      CustomTab(text: 'Events', icon: Icons.event_note),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            actions: [
              FocusTwinklingBorderContainer(child: IconButton(onPressed: () {}, icon: const Icon(Icons.search))),
              const SizedBox(
                width: 15,
              ),
              FocusTwinklingBorderContainer(child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsPage()),
                    );
                  },
                  icon: const Icon(Icons.notifications))),
              const SizedBox(
                width: 15,
              ),
              const FocusTwinklingBorderContainer(child: MenuButton()),
              const SizedBox(
                width: 15,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: ColoredBox(
                color: Color(Colors.grey[800]!.value),
                child: _tabBar,
              ),
            )),
        body: const TabBarView(
          children: <Widget>[
            VideosTab(),
            AnnouncementsTab(),
            EventsTab(),
          ],
        ),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  const CustomTab({super.key, this.autofocus = false, required this.text, required this.icon});

  final String text;
  final IconData icon;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return FocusTwinklingBorderContainer(
      autofocus: autofocus,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.blue,
            ),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
