import 'dart:convert';
import 'dart:io';
import 'package:flutter_android_tv_box/core/constants.dart';
import 'package:flutter_android_tv_box/data/models/announcements.dart';
import 'package:flutter_android_tv_box/data/models/events.dart';
import 'package:flutter_android_tv_box/data/models/video_categories.dart';
import 'package:flutter_android_tv_box/data/models/videos.dart';
import 'package:http/http.dart' as http;

/// Collection of functions for fetching data from back-end
class FetchData {
  /// Base function of fetching data
  static Future<List<T>> _fetchData<T>({
    required String apiUrl,
    required T Function(Map<String, dynamic>) parser,
  }) async {
    final Uri url = Uri.parse(apiUrl);

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => parser(data)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on SocketException {
      // Pass the exception to the caller
      rethrow;
    } catch (error) {
      // Handle other types of errors (e.g., parsing error)
      throw Exception('Failed to fetch data: $error');
    }
  }

  /// Fetch announcements from back-end
  static Future<List<Announcements>> getAnnouncements() async {
    return _fetchData<Announcements>(
        apiUrl: urlAnnouncements,
        parser: (data) => Announcements.fromMap(data));
  }

  /// Fetch events from back-end
  static Future<List<Events>> getEvents() async {
    return _fetchData<Events>(
        apiUrl: urlEvents, parser: (data) => Events.fromMap(data));
  }

  /// Fetch video categories from back-end
  static Future<List<VideoCategories>> getVideoCategories() async {
    return _fetchData<VideoCategories>(
        apiUrl: urlVideoCategories,
        parser: (data) => VideoCategories.fromMap(data));
  }

  /// Fetch videos from back-end
  static Future<List<Videos>> getVideos() async {
    return _fetchData<Videos>(
        apiUrl: urlVideos, parser: (data) => Videos.fromMap(data));
  }
}
