// lib/src/home/view/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/home/notifier/home_notifier.dart';
import 'package:tsuite/src/home/view/widget/home_content_widget.dart';
import 'package:tsuite/src/home/view/widget/home_shimmer_widget.dart';
import 'package:tsuite/utils/common_widgets/common_refresh_indicator.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final loaderState = ref.watch(
      homeNotifierProvider.select((s) => s.loaderState),
    );
    final data = ref.watch(homeNotifierProvider.select((s) => s.data));
    final compactProgress = ref.watch(
      homeNotifierProvider.select((s) => s.compactHeaderProgress),
    );
    final notifier = ref.read(homeNotifierProvider.notifier);
    final useDarkStatusIcons = compactProgress > 0.5;

    return CommonScaffold(
      backgroundColor: colors.background,
      safeAreaTop: false,
      safeAreaBottom: false,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: useDarkStatusIcons
          ? Brightness.dark
          : Brightness.light,
      enableFadeIn: false,
      body: CommonRefreshIndicator(
        onRefresh: () =>
            ref.read(homeNotifierProvider.notifier).fetchHomeFeed(),
        child: CommonSwitchState(
          loaderState: loaderState,
          reload: () =>
              ref.read(homeNotifierProvider.notifier).fetchHomeFeed(),
          loader: const HomeShimmerWidget(),
          buttonText: Strings.refresh,
          child: HomeContentWidget(
            data: data,
            searchController: notifier.searchController,
          ),
        ),
      ),
    );
  }
}
