// lib/src/product_detail/view/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_content_widget.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_floating_action.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_hero_image.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_shimmer_widget.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_sticky_footer.dart';
import 'package:medpik/utils/common_widgets/cart_mutation_overlay.dart';
import 'package:medpik/utils/common_widgets/common_empty_state.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:medpik/utils/common_widgets/common_wishlist_button.dart';
import 'package:medpik/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(productDetailNotifierProvider.notifier)
          .loadProduct(widget.productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final notifier = ref.read(productDetailNotifierProvider.notifier);
    final screenData = ref.watch(
      productDetailNotifierProvider.select(
        (s) => Tuple2(s.loaderState, s.detail),
      ),
    );
    final loaderState = screenData.item1;
    final detail = screenData.item2;
    final topInset = MediaQuery.paddingOf(context).top;

    return CommonScaffold(
      safeAreaTop: false,
      safeAreaBottom: false,
      statusBarColor: ColorPalette.transparent,
      statusBarIconBrightness: Brightness.dark,
      backgroundColor: colors.background,
      body: CommonSwitchState(
        loaderState: loaderState,
        reload: () => notifier.loadProduct(widget.productId),
        loader: const ProductDetailShimmerWidget(),
        buttonText: Strings.refresh,
        noData: const CommonEmptyState(
          title: Strings.noDataFound,
          message: Strings.noDataAvailableDesc,
        ),
        child: detail == null
            ? const SizedBox.shrink()
            : Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: ProductDetailHeroImage.heightFor(context),
                    child: RepaintBoundary(
                      child: ProductDetailHeroImage(
                        key: ValueKey(detail.product.imageUrl),
                        imageUrl: detail.product.imageUrl,
                      ),
                    ),
                  ),
                  CartMutationOverlay(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ProductDetailContentWidget(
                          detail: detail,
                          scrollController: notifier.scrollController,
                        ),
                        Positioned(
                          top: topInset + 8.h,
                          left: 16.w,
                          right: 16.w,
                          child: Row(
                            children: [
                              ProductDetailFloatingAction(
                                icon: Icons.arrow_back_ios_new_rounded,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              const Spacer(),
                              _ProductDetailWishlistButton(
                                onToggle: notifier.toggleWishlist,
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: ProductDetailStickyFooter(),
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

class _ProductDetailWishlistButton extends ConsumerWidget {
  const _ProductDetailWishlistButton({required this.onToggle});

  final Future<void> Function() onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWishlisted = ref.watch(
      productDetailNotifierProvider.select((s) => s.isWishlisted),
    );

    return CommonWishlistButton(
      isWishlisted: isWishlisted,
      onTap: () {
        if (!AppConstants.hasSession) {
          Navigator.pushNamed(context, RouteConstants.routeLoginScreen);
          return;
        }
        onToggle();
      },
      overlayStyle: true,
    );
  }
}
