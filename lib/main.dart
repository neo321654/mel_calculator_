import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  //строка ниже помогает убрать ошибку подгрузки
  //todo сделать заставку без букв только лейбл
  //todo сделать ярлыки для айос и андроид и поменять название для айсос
  //todo убрать лишние экраны и сделать возможность убрать рекламу для димки и связать её с shared pref
  //todo благодарности написать в о приложении , там же сделать убрать рекламу
//

  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
