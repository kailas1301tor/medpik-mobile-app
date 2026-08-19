// lib/src/home/view/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/home/notifier/home_notifier.dart';
import 'package:medpik/src/home/view/widget/home_content_widget.dart';
import 'package:medpik/src/home/view/widget/home_shimmer_widget.dart';
import 'package:medpik/utils/common_widgets/common_refresh_indicator.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:tuple/tuple.dart';

import '../../../res/enums/enums.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final feed = ref.watch(
      homeNotifierProvider.select((s) => Tuple2(s.loaderState, s.data)),
    );
    final loaderState = feed.item1;
    final data = feed.item2;
    final notifier = ref.read(homeNotifierProvider.notifier);

    return CommonScaffold(
      backgroundColor: colors.background,
      safeAreaTop: false,
      safeAreaBottom: false,
      statusBarColor: ColorPalette.transparent,
      statusBarIconBrightness: Brightness.light,
      enableFadeIn: false,
      body: CommonRefreshIndicator(
        onRefresh: () =>
            ref.read(homeNotifierProvider.notifier).fetchHomeFeed(),
        child: CommonSwitchState(
          loaderState: loaderState,
          reload: () => ref.read(homeNotifierProvider.notifier).fetchHomeFeed(),
          loader: const HomeShimmerWidget(),
          buttonText: Strings.refresh,
          child: HomeContentWidget(
            data: data,
            scrollController: notifier.scrollController,
          ),
        ),
      ),
    );
  }
}
