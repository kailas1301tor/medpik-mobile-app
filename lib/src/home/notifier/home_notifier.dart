// lib/src/home/notifier/home_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/providers/address_providers.dart';
import 'package:medpik/providers/wishlist_providers.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/home/repo/home_repository.dart';
import 'package:medpik/src/home/state/home_state.dart';
import 'package:medpik/utils/helpers/address_resolution_helper.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';
import 'package:medpik/utils/helpers/time_of_day_greeting_helper.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';

part 'home_notifier.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  late TextEditingController searchController;
  late ScrollController scrollController;
  late HomeRepo homeRepo;
  bool _lifecycleInitialized = false;
  int _feedRequestId = 0;

  static const double _compactThreshold = 72;
  static const double _compactFadeDistance = 56;

  @override
  HomeState build() {
    if (_lifecycleInitialized) {
      return state;
    }

    searchController = TextEditingController();
    scrollController = ScrollController()..addListener(_onScroll);
    _lifecycleInitialized = true;

    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      searchController.dispose();
      scrollController.dispose();
      _lifecycleInitialized = false;
      _feedRequestId = 0;
    });

    ref.listen(addressNotifierProvider.select((s) => s.addresses), (
      previous,
      next,
    ) {
      final data = state.data;
      if (data == null) return;
      final deliveryHint = deliveryHintFromAddresses(next);
      if (data.deliveryHint == deliveryHint) return;
      state = state.copyWith(data: data.copyWith(deliveryHint: deliveryHint));
    });

    homeRepo = ref.read(homeRepositoryProvider);
    // Initial load is owned by MainShellNotifier.bootstrapSessionData so
    // home does not race a second fetch and flash LoaderState.noData.
    return const HomeState(loaderState: LoaderState.loading);
  }

  Future<void> fetchCustomerGeneralData() async {
    state = state.copyWith(generalDataLoaderState: LoaderState.loading);

    return await homeRepo
        .getCustomerGeneralData()
        .fold(
          (error) {
            state = state.copyWith(
              generalDataLoaderState: loaderStateForSessionAwareError(
                error.key,
              ),
            );
            if (!shouldReportFetchError(error)) return;
          },
          (right) {
            final generalData = right.data;
            if (generalData == null) {
              state = state.copyWith(
                generalDataLoaderState: LoaderState.noData,
              );
              return;
            }
            state = state.copyWith(
              generalDataLoaderState: LoaderState.loaded,
              generalData: generalData,
            );
          },
        )
        .catchError((error) {
          state = state.copyWith(generalDataLoaderState: LoaderState.error);
        });
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final offset = scrollController.offset;
    final progress = ((offset - _compactThreshold) / _compactFadeDistance)
        .clamp(0.0, 1.0);

    if (state.compactHeaderProgress == progress) return;
    state = state.copyWith(compactHeaderProgress: progress);
  }

  Future<void> fetchHomeFeed() async {
    final requestId = ++_feedRequestId;

    if (state.generalData == null &&
        state.generalDataLoaderState != LoaderState.loading) {
      await fetchCustomerGeneralData();
      if (requestId != _feedRequestId) return;
    }

    state = state.copyWith(loaderState: LoaderState.loading);

    return await homeRepo
        .getHomeFeed()
        .fold(
          (error) {
            if (requestId != _feedRequestId) return;
            state = state.copyWith(
              loaderState: loaderStateForSessionAwareError(error.key),
            );
            if (!shouldReportFetchError(error)) return;
            showCustomErrorToast(
              message: error.message ?? Strings.somethingWentWrong,
            );
          },
          (right) {
            if (requestId != _feedRequestId) return;
            final feed = right.copyWith(
              greeting: timeOfDayGreeting(),
              deliveryHint: _resolveDeliveryHint(),
            );
            state = state.copyWith(loaderState: LoaderState.loaded, data: feed);
            ref
                .read(wishlistNotifierProvider.notifier)
                .syncFromProducts(feed.featuredProducts);
          },
        )
        .catchError((error) {
          if (requestId != _feedRequestId) return;
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  String _resolveDeliveryHint() {
    return deliveryHintFromAddresses(
      ref.read(addressNotifierProvider).addresses,
    );
  }
}
