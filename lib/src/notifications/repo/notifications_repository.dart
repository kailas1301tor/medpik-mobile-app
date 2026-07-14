// lib/src/notifications/repo/notifications_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/src/notifications/model/notification_model.dart';

abstract class NotificationsRepo {
  Future<Either<ResponseError, List<NotificationModel>>> getNotifications();

  Future<Either<ResponseError, bool>> markAsRead(int id);

  Future<Either<ResponseError, bool>> markAllAsRead();
}

class NotificationsRepoImpl implements NotificationsRepo {
  NotificationsRepoImpl(NetworkServices networkServices);

  @override
  Future<Either<ResponseError, List<NotificationModel>>>
      getNotifications() async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }

  @override
  Future<Either<ResponseError, bool>> markAsRead(int id) async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }

  @override
  Future<Either<ResponseError, bool>> markAllAsRead() async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }
}
