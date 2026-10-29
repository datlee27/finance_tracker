import 'package:flutter/material.dart';

/// Provider quản lý chế độ giao diện (Sáng, Tối, Theo thiết bị)
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  String _themeSetting = 'dark'; // 'light', 'dark', 'system'

  ThemeMode get themeMode => _themeMode;
  String get themeSetting => _themeSetting;

  /// Đặt chế độ giao diện: 'light' | 'dark' | 'system'
  void setTheme(String setting) {
    if (_themeSetting == setting) return;

    _themeSetting = setting;
    switch (setting) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'system':
      default:
        _themeMode = ThemeMode.system;
        break;
    }

    notifyListeners();
  }
}
