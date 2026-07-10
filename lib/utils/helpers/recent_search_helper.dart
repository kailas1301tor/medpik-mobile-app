// lib/utils/helpers/recent_search_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

const _recentSearchesKey = 'recent_searches';
const _maxRecentSearches = 8;

Future<List<String>> getRecentSearches() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(_recentSearchesKey) ?? [];
}

Future<void> addRecentSearch(String query) async {
  final trimmed = query.trim();
  if (trimmed.isEmpty) return;

  final prefs = await SharedPreferences.getInstance();
  final current = prefs.getStringList(_recentSearchesKey) ?? [];
  final updated = [trimmed, ...current.where((e) => e != trimmed)]
      .take(_maxRecentSearches)
      .toList();
  await prefs.setStringList(_recentSearchesKey, updated);
}

Future<void> clearRecentSearches() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_recentSearchesKey);
}
