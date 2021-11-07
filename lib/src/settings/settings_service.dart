import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late final _counter = _prefs.then((SharedPreferences prefs) {
    return  (prefs.getString('ThemeMode') ?? 'dark');
  });

  Future<ThemeMode> themeMode() async {
    switch (await _counter) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
   String newTheme = 'light';
     switch (theme) {
       case ThemeMode.dark:
         newTheme = 'dark';
         break;
       case ThemeMode.light:
         newTheme = 'light';
         break;
       case ThemeMode.system:
         newTheme='light';
         break;
   }

    _prefs.then((SharedPreferences prefs) {
        prefs.setString('ThemeMode',newTheme);
    });
  }
}
