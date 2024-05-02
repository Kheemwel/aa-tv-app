import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_android_tv_box/about/about_page.dart';
import 'package:flutter_android_tv_box/custom_widgets/focus_border.dart';
import 'package:flutter_android_tv_box/games/games_page.dart';
import 'package:flutter_android_tv_box/home/announcements_tab.dart';
import 'package:flutter_android_tv_box/home/events_tab.dart';
import 'package:flutter_android_tv_box/home/videos_tab.dart';
import 'package:flutter_android_tv_box/notifications/notifications_page.dart';
import 'package:flutter_android_tv_box/settings/settings_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final TabBar _tabBar = const TabBar(
    indicatorWeight: 0.01,
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
                FocusBorder(
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search))),
                const SizedBox(
                  width: 15,
                ),
                FocusBorder(
                  child: Builder(
                    builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        icon: const Icon(Icons.menu)),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
              bottom: PreferredSize(
                preferredSize: _tabBar.preferredSize,
                child: Container(
                  color: Colors.grey[800]!.withOpacity(0.5),
                  padding: const EdgeInsets.all(5),
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
          endDrawer: Drawer(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Menu',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _drawerTile(
                    context: context,
                    icon: Icons.games,
                    title: 'Games',
                    page: const GamesPage(),
                  ),
                  _drawerTile(
                    context: context,
                    icon: Icons.notifications,
                    title: 'Notifications',
                    page: const NotificationsPage(),
                  ),
                  _drawerTile(
                      context: context,
                      icon: Icons.settings,
                      title: 'Settings',
                      page: const SettingsPage()),
                  _drawerTile(
                      context: context,
                      icon: Icons.info,
                      title: 'About',
                      page: const AboutPage()),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _drawerTile(
      {required BuildContext context,
      required IconData icon,
      required String title,
      required Widget page}) {
    return ListTile(
      focusColor: Colors.green[900],
      iconColor: Colors.blue,
      tileColor: Colors.transparent,
      titleTextStyle: const TextStyle(color: Colors.white),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      leading: Icon(icon),
      title: Text(title),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  const CustomTab(
      {super.key,
      this.autofocus = false,
      required this.text,
      required this.icon});

  final String text;
  final IconData icon;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return FocusBorder(
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
