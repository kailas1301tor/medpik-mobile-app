import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeKey = 'app_theme_mode';

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    return _loadFromPrefs();
  }

  // ✅ Persists across app restarts
  Future<ThemeMode> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeKey);
    return switch (saved) {
      'light'  => ThemeMode.light,
      'dark'   => ThemeMode.dark,
      _        => ThemeMode.system, // default
    };
  }

  Future<void> _saveToPrefs(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, mode.name);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _saveToPrefs(mode);
    state = AsyncData(mode);
  }

  // ✅ Handles system mode correctly
  Future<void> toggleTheme() async {
    final current = state.valueOrNull ?? ThemeMode.system;
    final next = current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(next);
  }

  bool get isDark => state.valueOrNull == ThemeMode.dark;
  bool get isLight => state.valueOrNull == ThemeMode.light;
  bool get isSystem => state.valueOrNull == ThemeMode.system;
}

final themeNotifierProvider =
    AsyncNotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);