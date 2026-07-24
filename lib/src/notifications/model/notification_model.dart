// lib/src/notifications/model/notification_model.dart
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class NotificationPayloadData {
  const NotificationPayloadData({
    this.type = '',
    this.screen = '',
    this.status = '',
    this.orderId = 0,
  });

  final String type;
  final String screen;
  final String status;
  final int orderId;

  factory NotificationPayloadData.fromJson(Map<String, dynamic> json) =>
      NotificationPayloadData(
        type: convertToString(json['type']),
        screen: convertToString(json['screen']),
        status: convertToString(json['status']),
        orderId: convertToInt(json['order_id']),
      );
}

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    this.type = NotificationType.system,
    this.image,
    this.data,
  });

  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final NotificationType type;
  final String? image;
  final NotificationPayloadData? data;

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    NotificationType? type,
    String? image,
    NotificationPayloadData? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      image: image ?? this.image,
      data: data ?? this.data,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final payloadData = json['data'] == null
        ? null
        : NotificationPayloadData.fromJson(convertToMap(json['data']));
    final message = convertToString(json['message']);
    final body = message.isNotEmpty
        ? message
        : convertToString(json['body']);
    final typeSource = payloadData?.type.isNotEmpty == true
        ? payloadData!.type
        : convertToString(json['type']);

    return NotificationModel(
      id: convertToInt(json['id']),
      title: convertToString(json['title']),
      body: body,
      createdAt: DateTime.tryParse(convertToString(json['created_at'])) ??
          DateTime.now(),
      isRead: convertToBool(json['is_read']),
      type: _typeFromString(typeSource),
      image: convertToString(json['image']).isEmpty
          ? null
          : convertToString(json['image']),
      data: payloadData,
    );
  }

  static NotificationType _typeFromString(String value) {
    return switch (value.toLowerCase()) {
      'order' => NotificationType.order,
      'prescription' => NotificationType.prescription,
      'offer' => NotificationType.offer,
      _ => NotificationType.system,
    };
  }
}

class NotificationsResponse {
  const NotificationsResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final NotificationsResults results;
  final String message;
  final bool status;

  List<NotificationModel> get notifications => results.data;
  int get currentPage => results.currentPage;
  int get totalPages => results.totalPages;
  int get totalCount => results.totalCount;
  int get itemPerPage => results.itemPerPage;

  bool get hasMore {
    if (totalPages > 0) return currentPage < totalPages;
    return data.length >= (itemPerPage > 0 ? itemPerPage : 10);
  }

  List<NotificationModel> get data => results.data;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return NotificationsResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: NotificationsResults.fromJson(
        convertToMap(json['results']),
      ),
    );
  }
}

class NotificationsResults {
  const NotificationsResults({
    this.totalCount = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.itemPerPage = 10,
    this.data = const [],
  });

  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int itemPerPage;
  final List<NotificationModel> data;

  factory NotificationsResults.fromJson(Map<String, dynamic> json) {
    final data = convertToList(json['data'])
        .map((e) => NotificationModel.fromJson(convertToMap(e)))
        .toList();
    final itemPerPage = convertToInt(json['item_per_page'], defValue: 10);
    final currentPage = convertToInt(json['current_page'], defValue: 1);
    var totalPages = convertToInt(json['total_pages']);
    var totalCount = convertToInt(json['total_count']);

    if (totalPages <= 0 && data.isNotEmpty) {
      if (data.length >= itemPerPage) {
        totalPages = currentPage + 1;
      } else {
        totalPages = currentPage;
      }
    }
    if (totalCount <= 0) {
      totalCount = data.length;
    }

    return NotificationsResults(
      totalCount: totalCount,
      totalPages: totalPages,
      currentPage: currentPage,
      itemPerPage: itemPerPage > 0 ? itemPerPage : 10,
      data: data,
    );
  }
}
