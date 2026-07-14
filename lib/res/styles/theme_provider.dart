import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeKey = 'app_theme_mode';

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    return _loadFromPrefs();
  }

  Future<ThemeMode> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeKey);
    return switch (saved) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      // Migrate legacy system preference to light.
      _ => ThemeMode.light,
    };
  }

  Future<void> _saveToPrefs(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kThemeKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final resolved = mode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light;
    await _saveToPrefs(resolved);
    state = AsyncData(resolved);
  }

  Future<void> toggleTheme() async {
    final current = state.valueOrNull ?? ThemeMode.light;
    final next =
        current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }

  bool get isDark => state.valueOrNull == ThemeMode.dark;
  bool get isLight => state.valueOrNull != ThemeMode.dark;
}

final themeNotifierProvider =
    AsyncNotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
