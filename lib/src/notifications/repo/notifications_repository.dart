// lib/src/notifications/repo/notifications_repository.dart
import 'package:either_dart/either.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/notifications/model/notification_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class NotificationsRepo {
  Future<Either<ResponseError, NotificationsResponse>> getNotifications({
    required int page,
    int pageSize = 10,
  });

  Future<Either<ResponseError, bool>> markAllAsRead();
}

class NotificationsRepoImpl implements NotificationsRepo {
  NotificationsRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, NotificationsResponse>> getNotifications({
    required int page,
    int pageSize = 10,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: AppConstants.notificationsInApp,
            queryParameters: {
              'page': page,
              'page_size': pageSize,
            },
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => NotificationsResponse.fromJson(convertToMap(right)),
        );
  }

  @override
  Future<Either<ResponseError, bool>> markAllAsRead() async {
    return await _networkServices
        .safe(
          _networkServices.putRequest(
            endPoint: AppConstants.notificationsInApp,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((_) => true);
  }
}
