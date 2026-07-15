// lib/src/wishlist/view/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/res/constants/assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/wishlist/notifier/wishlist_notifier.dart';
import 'package:tsuite/src/wishlist/view/widget/wishlist_content_widget.dart';
import 'package:tsuite/src/wishlist/view/widget/wishlist_screen_header.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final items = ref.watch(wishlistNotifierProvider.select((s) => s.items));
    final loaderState =
        items.isEmpty ? LoaderState.noData : LoaderState.loaded;

    return CommonScaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          const WishlistScreenHeader(),
          Expanded(
            child: CommonSwitchState(
              loaderState: loaderState,
              buttonText: Strings.goBackButton,
              customButtonFunction: () => Navigator.of(context).maybePop(),
              emptyScreenTitle: Strings.noFavoriteProducts,
              emptyScreenDescription: Strings.noFavoriteProductsDesc,
              emptyScreenImage: Assets.lottieEmptyHeart,
              child: WishlistContentWidget(items: items),
            ),
          ),
        ],
      ),
    );
  }
}
