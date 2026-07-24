// lib/utils/helpers/notification_navigation_helper.dart
import 'package:flutter/material.dart';
import 'package:medpik/src/notifications/model/notification_model.dart';
import 'package:medpik/utils/routes/route_constants.dart';

void navigateFromNotificationPayload(
  BuildContext context,
  NotificationPayloadData data,
) {
  switch (data.screen) {
    case 'order_details':
      if (data.orderId > 0) {
        Navigator.pushNamed(
          context,
          RouteConstants.routeOrderDetailScreen,
          arguments: data.orderId.toString(),
        );
      }
    default:
      break;
  }
}
