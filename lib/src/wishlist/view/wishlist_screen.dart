// lib/src/wishlist/view/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/constants/assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/wishlist/notifier/wishlist_notifier.dart';
import 'package:tsuite/src/wishlist/view/widget/wishlist_content_widget.dart';
import 'package:tsuite/src/wishlist/view/widget/wishlist_screen_header.dart';
import 'package:tsuite/src/wishlist/view/widget/wishlist_shimmer_widget.dart';
import 'package:tsuite/utils/common_widgets/common_refresh_indicator.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!AppConstants.hasSession) return;
      ref.read(wishlistNotifierProvider.notifier).fetchWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final loaderState = ref.watch(
      wishlistNotifierProvider.select((s) => s.loaderState),
    );
    final items = ref.watch(wishlistNotifierProvider.select((s) => s.items));
    final notifier = ref.read(wishlistNotifierProvider.notifier);

    return CommonScaffold(
      backgroundColor: colors.background,
      body: CommonRefreshIndicator(
        onRefresh: () async {
          if (!AppConstants.hasSession) return;
          await notifier.fetchWishlist();
        },
        child: Column(
          children: [
            const WishlistScreenHeader(),
            Expanded(
              child: CommonSwitchState(
                loaderState: loaderState,
                reload: () {
                  if (!AppConstants.hasSession) return;
                  notifier.fetchWishlist();
                },
                loader: const WishlistShimmerWidget(),
                buttonText: Strings.refresh,
                emptyScreenTitle: Strings.noFavoriteProducts,
                emptyScreenDescription: Strings.noFavoriteProductsDesc,
                emptyScreenImage: Assets.lottieEmptyHeart,
                child: WishlistContentWidget(items: items),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
