import 'dart:convert';
import 'package:flutter_android_tv_box/core/constants.dart';
import 'package:flutter_android_tv_box/data/database/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Utility class for sending data to back-end
class SendData {
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
