// lib/src/notifications/repo/notifications_repository_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/notifications/model/notification_model.dart';
import 'package:tsuite/src/notifications/repo/notifications_repository.dart';

class NotificationsRepoMock implements NotificationsRepo {
  static final List<NotificationModel> _notifications = [];

  void _seedIfEmpty() {
    if (_notifications.isNotEmpty) return;
    final now = DateTime.now();
    _notifications.addAll([
      NotificationModel(
        id: 1,
        title: Strings.notificationOrderOutForDeliveryTitle,
        body: Strings.notificationOrderOutForDeliveryBody,
        createdAt: now.subtract(const Duration(minutes: 25)),
        isRead: false,
        type: NotificationType.order,
      ),
      NotificationModel(
        id: 2,
        title: Strings.notificationPrescriptionReviewedTitle,
        body: Strings.notificationPrescriptionReviewedBody,
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: false,
        type: NotificationType.prescription,
      ),
      NotificationModel(
        id: 3,
        title: Strings.notificationOfferTitle,
        body: Strings.notificationOfferBody,
        createdAt: now.subtract(const Duration(hours: 8)),
        isRead: true,
        type: NotificationType.offer,
      ),
      NotificationModel(
        id: 4,
        title: Strings.notificationBillReadyTitle,
        body: Strings.notificationBillReadyBody,
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: false,
        type: NotificationType.order,
      ),
      NotificationModel(
        id: 5,
        title: Strings.notificationWelcomeTitle,
        body: Strings.notificationWelcomeBody,
        createdAt: now.subtract(const Duration(days: 3)),
        isRead: true,
        type: NotificationType.system,
      ),
    ]);
  }

  @override
  Future<Either<ResponseError, List<NotificationModel>>>
      getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 350));
    _seedIfEmpty();
    final sorted = List<NotificationModel>.from(_notifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Right(sorted);
  }

  @override
  Future<Either<ResponseError, bool>> markAsRead(int id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _seedIfEmpty();
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index < 0) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.notFound,
          message: Strings.noDataFound,
        ),
      );
    }
    _notifications[index] = _notifications[index].copyWith(isRead: true);
    return const Right(true);
  }

  @override
  Future<Either<ResponseError, bool>> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _seedIfEmpty();
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    return const Right(true);
  }
}
