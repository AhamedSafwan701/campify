import 'package:camify_travel_app/model/dark_light/dark_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String _themeBox = 'THEME_BOX';

class ThemeManager {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.light,
  );
  Future<void> init() async {
    if (!Hive.isBoxOpen(_themeBox)) {
      await Hive.openBox<ThemeModeModel>(_themeBox);
    }
    await loadTheme();
  }

  Future<void> loadTheme() async {
    final box = Hive.box<ThemeModeModel>(_themeBox);
    final themeData = box.get('currentTheme');
    themeNotifier.value =
        (themeData?.isDarkMode ?? false) ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> toggleTheme(bool isDark) async {
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
    final box = Hive.box<ThemeModeModel>(_themeBox);
    await box.put('currentTheme', ThemeModeModel(isDarkMode: isDark));
  }
}
