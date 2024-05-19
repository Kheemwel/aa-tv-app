import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/database/announcements_dao.dart';
import 'package:flutter_android_tv_box/data/database/events_dao.dart';
import 'package:flutter_android_tv_box/data/database/shared_preferences.dart';
import 'package:flutter_android_tv_box/data/database/sqlite_database_helper.dart';
import 'package:flutter_android_tv_box/data/database/video_categories_dao.dart';
import 'package:flutter_android_tv_box/data/database/videos_dao.dart';
import 'package:flutter_android_tv_box/screens/home/home_screen.dart';

/// Main entry of the app
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize sqlite database
  SQLiteDatabaseHelper().initDatabase();
  VideoCategoriesDAO.fetchVideoCategories();
  VideosDAO.fetchVideos();
  AnnouncementsDAO.fetchAnnouncements();
  EventsDAO.fetchEvents();

  // Initialize shared preferences
  SharedPref.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent> {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: MaterialApp(
          title: 'AA TV',
          theme: themeData,
          home: const HomeScreen()),
    );
  }
}
