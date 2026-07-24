// lib/utils/helpers/time_of_day_greeting_helper.dart
import 'package:medpik/res/constants/string_constants.dart';

/// Returns a time-of-day greeting for the local clock.
String timeOfDayGreeting([DateTime? now]) {
  final hour = (now ?? DateTime.now()).hour;
  if (hour < 12) return Strings.goodMorning;
  if (hour < 17) return Strings.goodAfternoon;
  return Strings.goodEvening;
}
