// lib/src/home/notifier/home_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/providers/address_providers.dart';
import 'package:medpik/providers/auth_providers.dart';
import 'package:medpik/providers/wishlist_providers.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/home/model/home_model.dart';
import 'package:medpik/src/home/repo/home_repository.dart';
import 'package:medpik/src/home/state/home_state.dart';
import 'package:medpik/utils/helpers/address_resolution_helper.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';
import 'package:medpik/utils/helpers/time_of_day_greeting_helper.dart';

part 'home_notifier.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  late ScrollController scrollController;
  late HomeRepo homeRepo;
  bool _lifecycleInitialized = false;

  static const double _compactThreshold = 72;
  static const double _compactFadeDistance = 56;

  @override
  HomeState build() {
    if (_lifecycleInitialized) {
      return state;
    }

    scrollController = ScrollController()..addListener(_onScroll);
    _lifecycleInitialized = true;

    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
      _lifecycleInitialized = false;
    });

    ref.listen(
      addressNotifierProvider.select((s) => (s.addresses, s.loaderState)),
      (previous, next) {
        final data = state.data;
        if (data == null) return;
        final deliveryHint = _resolveDeliveryHint();
        if (data.deliveryHint == deliveryHint) return;
        state = state.copyWith(
          data: data.copyWith(deliveryHint: deliveryHint),
        );
      },
    );

    ref.listen(
      authNotifierProvider.select((s) => s.authModel?.name ?? ''),
      (previous, next) {
        _applyGreeting(next);
      },
    );

    homeRepo = ref.read(homeRepositoryProvider);
    // Paint greeting/name/delivery from local session immediately — don't wait
    // for the home API. Catalog sections still load behind body shimmers.
    return HomeState(
      loaderState: LoaderState.loading,
      data: _shellFeed(),
    );
  }

  Future<void> fetchCustomerGeneralData() async {
    state = state.copyWith(generalDataLoaderState: LoaderState.loading);

    return await homeRepo
        .getCustomerGeneralData()
        .fold(
          (error) {
            state = state.copyWith(generalDataLoaderState: LoaderState.error);
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
    // Keep a shell feed so the home header (and GIF) can mount immediately
    // while the API is in flight — without a separate shimmer tree.
    state = state.copyWith(
      loaderState: LoaderState.loading,
      data: state.data ?? _shellFeed(),
    );

    return await homeRepo
        .getHomeFeed()
        .fold(
          (error) {
            state = state.copyWith(
              loaderState: loaderStateForSessionAwareError(error.key),
            );
          },
          (right) {
            final displayName = _sessionDisplayName();
            final feed = right.copyWith(
              greeting: timeOfDayGreetingLabel(),
              userName: sessionFirstName(displayName),
              deliveryHint: _resolveDeliveryHint(),
            );
            state = state.copyWith(loaderState: LoaderState.loaded, data: feed);
            ref
                .read(wishlistNotifierProvider.notifier)
                .syncFromProducts(feed.featuredProducts);
          },
        )
        .catchError((error) {
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  HomeFeedModel _shellFeed() {
    return HomeFeedModel(
      results: const HomeResultsModel(data: HomeDataModel()),
      greeting: timeOfDayGreetingLabel(),
      userName: sessionFirstName(_sessionDisplayName()),
      deliveryHint: _resolveDeliveryHint(),
    );
  }

  String _resolveDeliveryHint() {
    final addressState = ref.read(addressNotifierProvider);
    final selected = resolveDefaultAddress(addressState.addresses);
    if (selected != null) {
      return selected.deliveryHint;
    }
    // Empty while addresses are still loading so the hero can shimmer that row.
    if (addressState.loaderState == LoaderState.loading) {
      return '';
    }
    return Strings.selectDeliveryAddress;
  }

  String _sessionDisplayName() {
    return ref.read(authNotifierProvider).authModel?.name ?? '';
  }

  void _applyGreeting(String rawName) {
    final data = state.data;
    if (data == null) return;
    final greeting = timeOfDayGreetingLabel();
    final userName = sessionFirstName(rawName);
    if (data.greeting == greeting && data.userName == userName) return;
    state = state.copyWith(
      data: data.copyWith(greeting: greeting, userName: userName),
    );
  }
}
