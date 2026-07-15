// lib/src/home/notifier/home_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/home/repo/home_repository.dart';
import 'package:tsuite/src/home/state/home_state.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';
import 'package:tsuite/utils/helpers/time_of_day_greeting_helper.dart';
import 'package:tsuite/utils/helpers/toast_helper.dart';

part 'home_notifier.g.dart';

@Riverpod(keepAlive: false)
class HomeNotifier extends _$HomeNotifier {
  late final TextEditingController searchController;
  late final ScrollController scrollController;
  late HomeRepo homeRepo;

  static const double _compactThreshold = 72;
  static const double _compactFadeDistance = 56;

  @override
  HomeState build() {
    searchController = TextEditingController();
    scrollController = ScrollController()..addListener(_onScroll);

    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      searchController.dispose();
      scrollController.dispose();
    });

    ref.listen(
      addressNotifierProvider.select((s) => s.addresses),
      (previous, next) {
        final data = state.data;
        if (data == null) return;
        final deliveryHint = _deliveryHintFromAddresses(next);
        if (data.deliveryHint == deliveryHint) return;
        state = state.copyWith(
          data: data.copyWith(deliveryHint: deliveryHint),
        );
      },
    );

    homeRepo = ref.read(homeRepositoryProvider);
    Future.microtask(fetchHomeFeed);
    return const HomeState(loaderState: LoaderState.loading);
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
    state = state.copyWith(loaderState: LoaderState.loading);

    return await homeRepo
        .getHomeFeed()
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint('🔴 HOME ERROR: ${error.message}');
            showCustomErrorToast(
              message: error.message ?? Strings.somethingWentWrong,
            );
            state = state.copyWith(loaderState: loaderState);
          },
          (right) {
            final feed = right.copyWith(
              greeting: timeOfDayGreeting(),
              deliveryHint: _resolveDeliveryHint(),
            );
            debugPrint('🟢 HOME SUCCESS: categories=${feed.categories.length}');
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              data: feed,
            );
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED HOME ERROR: $error');
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  String _resolveDeliveryHint() {
    final addresses = ref.read(addressNotifierProvider).addresses;
    return _deliveryHintFromAddresses(addresses);
  }

  String _deliveryHintFromAddresses(List<AddressModel> addresses) {
    AddressModel? selected;
    for (final address in addresses) {
      if (address.isDefault) {
        selected = address;
        break;
      }
    }
    selected ??= addresses.isEmpty ? null : addresses.first;
    return selected?.deliveryHint ?? Strings.selectDeliveryAddress;
  }
}
