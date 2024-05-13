import 'package:shared_preferences/shared_preferences.dart';

/// Collection of functions for handling SharedPreferences
class SharedPref {
  static late SharedPreferences _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save username to SharedPreferences
  static void setUsername(String username) {
    // Save the inputted username to 'userName' key
    _prefs.setString('userName', username);
  }

  /// Retrieve username from SharedPreferences
  /// Default value is 'AA TV User'
  static String getUsername() {
    // Try reading data from the 'userName' key. If it doesn't exist, returns a default value.
    return _prefs.getString('userName') ?? 'AA TV User';
  }
}
