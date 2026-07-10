// lib/utils/extensions/datetime_extensions.dart
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  String format([String pattern = 'dd MMM yyyy']) =>
      DateFormat(pattern).format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());

  String get chatLabel {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    return format('dd MMM yyyy');
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
}

extension NullableDateTimeExtension on DateTime? {
  bool get isNullOrPast =>
      this == null || this!.isBefore(DateTime.now());

  String orDefault([String fallback = '—']) =>
      this == null ? fallback : this!.toLocal().toString().split(' ')[0];

  DateTime get orNow => this ?? DateTime.now();
}
