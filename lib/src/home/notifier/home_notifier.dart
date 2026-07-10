// lib/src/home/notifier/home_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/home/repo/home_repository.dart';
import 'package:tsuite/src/home/state/home_state.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

part 'home_notifier.g.dart';

@Riverpod(keepAlive: false)
class HomeNotifier extends _$HomeNotifier {
  late final TextEditingController searchController;
  late final ScrollController scrollController;
  late PageController popularProductsPageController;
  late HomeRepo homeRepo;

  static const double _compactThreshold = 72;
  static const double _compactFadeDistance = 56;

  @override
  HomeState build() {
    searchController = TextEditingController();
    scrollController = ScrollController()..addListener(_onScroll);
    popularProductsPageController = PageController(viewportFraction: 0.48);

    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      searchController.dispose();
      scrollController.dispose();
      popularProductsPageController.dispose();
    });

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
    state = state.copyWith(loaderState: LoaderState.loading, errorMessage: null);

    return await homeRepo
        .getHomeFeed()
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 HOME ERROR: ${error.message}");
            state = state.copyWith(
              loaderState: loaderState,
              errorMessage: error.message,
            );
          },
          (right) {
            debugPrint("🟢 HOME SUCCESS: ${right.userName}");
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              data: right,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED HOME ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }
}
