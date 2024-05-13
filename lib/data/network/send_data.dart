import 'dart:convert';
import 'package:flutter_android_tv_box/core/constants.dart';
import 'package:flutter_android_tv_box/data/database/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

/// Utility class for sending data to back-end
class SendData {
  static String _getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
  }

  /// Send game result to back-end
  static Future<http.Response> sendGameResult(
      {required String gameName, required String description}) async {
    try {
      final response = await http.post(
        Uri.parse(urlSaveData),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer $apiToken",
        },
        body: jsonEncode(<String, String>{
          'username': SharedPref.getUsername(),
          'game_name': gameName,
          'description': description,
          'date_time': _getCurrentDateTime(),
        }),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to save data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to save data: $error');
    }
  }
}
