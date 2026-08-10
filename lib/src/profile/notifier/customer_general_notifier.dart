// lib/src/profile/notifier/customer_general_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/category_model.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/home/repo/home_repository.dart';
import 'package:medpik/src/profile/state/customer_general_state.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';

part 'customer_general_notifier.g.dart';

@Riverpod(keepAlive: true)
class CustomerGeneralNotifier extends _$CustomerGeneralNotifier {
  late HomeRepo homeRepo;

  @override
  CustomerGeneralState build() {
    homeRepo = ref.read(homeRepositoryProvider);
    Future.microtask(fetchCustomerGeneralData);
    return const CustomerGeneralState(loaderState: LoaderState.loading);
  }

  Future<void> fetchCustomerGeneralData() async {
    state = state.copyWith(loaderState: LoaderState.loading);

    return await homeRepo
        .getCustomerGeneralData()
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint('🔴 CUSTOMER GENERAL ERROR: ${error.message}');
            state = state.copyWith(loaderState: loaderState);
          },
          (right) {
            final generalData = right.data;
            if (generalData == null) {
              state = state.copyWith(loaderState: LoaderState.noData);
              return;
            }
            debugPrint(
              '🟢 CUSTOMER GENERAL SUCCESS: '
              'categories=${generalData.categories.length}',
            );
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              data: generalData,
            );
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED CUSTOMER GENERAL ERROR: $error');
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  List<CategoryModel> get categories => state.data?.categories ?? const [];
}
