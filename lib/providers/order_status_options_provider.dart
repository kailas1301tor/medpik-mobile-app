// lib/providers/order_status_options_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/order_status_option_model.dart';
import 'package:medpik/src/profile/customer_general_providers.dart';

part 'order_status_options_provider.g.dart';

@Riverpod(keepAlive: true)
List<OrderStatusOptionModel> orderStatusOptions(Ref ref) {
  return ref.watch(
    customerGeneralNotifierProvider.select(
      (s) => s.data?.orderStatuses ?? const <OrderStatusOptionModel>[],
    ),
  );
}
