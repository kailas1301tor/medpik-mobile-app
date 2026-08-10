// lib/src/wishlist/view/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/constants/assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/wishlist/notifier/wishlist_notifier.dart';
import 'package:medpik/src/wishlist/view/widget/wishlist_content_widget.dart';
import 'package:medpik/src/wishlist/view/widget/wishlist_screen_header.dart';
import 'package:medpik/src/wishlist/view/widget/wishlist_shimmer_widget.dart';
import 'package:medpik/utils/common_widgets/common_loader.dart';
import 'package:medpik/utils/common_widgets/common_refresh_indicator.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wishlistScreenOpenedProvider);

    final colors = context.appColors;
    final loaderState = ref.watch(
      wishlistNotifierProvider.select((s) => s.loaderState),
    );
    final isTogglePending = ref.watch(
      wishlistNotifierProvider.select((s) => s.pendingToggleIds.isNotEmpty),
    );
    final notifier = ref.read(wishlistNotifierProvider.notifier);

    Future<void> refreshWishlist({required bool showLoader}) async {
      if (!AppConstants.hasSession) return;
      await notifier.fetchWishlist(showLoader: showLoader);
    }

    return CommonScaffold(
      backgroundColor: colors.background,
      body: CommonRefreshIndicator(
        onRefresh: () async {
          final itemsEmpty = ref.read(wishlistNotifierProvider).items.isEmpty;
          await refreshWishlist(showLoader: itemsEmpty);
        },
        child: Column(
          children: [
            const WishlistScreenHeader(),
            Expanded(
              child: Stack(
                children: [
                  CommonSwitchState(
                    loaderState: loaderState,
                    reload: () {
                      final itemsEmpty =
                          ref.read(wishlistNotifierProvider).items.isEmpty;
                      refreshWishlist(showLoader: itemsEmpty);
                    },
                    loader: const WishlistShimmerWidget(),
                    buttonText: Strings.refresh,
                    emptyScreenTitle: Strings.noFavoriteProducts,
                    emptyScreenDescription: Strings.noFavoriteProductsDesc,
                    emptyScreenImage: Assets.lottieEmptyHeart,
                    child: const WishlistContentWidget(),
                  ),
                  if (isTogglePending)
                    Positioned.fill(
                      child: ColoredBox(
                        color: colors.background.withValues(alpha: 0.55),
                        child: const Center(child: CommonLoader()),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
