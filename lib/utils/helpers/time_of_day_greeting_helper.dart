// lib/utils/helpers/time_of_day_greeting_helper.dart
import 'package:medpik/res/constants/string_constants.dart';

/// Time-of-day label for the home hero, e.g. "Good Morning,".
String timeOfDayGreetingLabel([DateTime? now]) {
  final hour = (now ?? DateTime.now()).hour;
  if (hour < 12) return Strings.goodMorningGreeting;
  if (hour < 17) return Strings.goodAfternoonGreeting;
  return Strings.goodEveningGreeting;
}

/// First token of a display name, or empty when missing.
String sessionFirstName(String? rawName) {
  final name = (rawName ?? '').trim();
  if (name.isEmpty) return '';
  return name.split(RegExp(r'\s+')).first;
}

/// Returns "Hi, {firstName}" from a display name, or "Hi" when it is empty.
String personalGreeting(String? rawName) {
  final firstName = sessionFirstName(rawName);
  if (firstName.isEmpty) return Strings.hi;
  return Strings.hiWithName(firstName);
}
