// lib/src/notifications/model/notification_model.dart
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    this.type = NotificationType.system,
  });

  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final NotificationType type;

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: convertToInt(json['id']),
        title: convertToString(json['title']),
        body: convertToString(json['body']),
        createdAt: DateTime.tryParse(convertToString(json['created_at'])) ??
            DateTime.now(),
        isRead: convertToBool(json['is_read']),
        type: _typeFromString(convertToString(json['type'])),
      );

  static NotificationType _typeFromString(String value) {
    return switch (value.toLowerCase()) {
      'order' => NotificationType.order,
      'prescription' => NotificationType.prescription,
      'offer' => NotificationType.offer,
      _ => NotificationType.system,
    };
  }
}
