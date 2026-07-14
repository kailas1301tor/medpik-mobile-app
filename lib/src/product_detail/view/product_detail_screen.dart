// lib/src/product_detail/view/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_content_widget.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_floating_action.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_sticky_footer.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';

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
    final loaderState = ref.watch(
      productDetailNotifierProvider.select((s) => s.loaderState),
    );
    final detail = ref.watch(
      productDetailNotifierProvider.select((s) => s.detail),
    );
    final isWishlisted = ref.watch(
      productDetailNotifierProvider.select((s) => s.isWishlisted),
    );
    final topInset = MediaQuery.paddingOf(context).top;

    return CommonScaffold(
      safeAreaTop: false,
      safeAreaBottom: false,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      backgroundColor: colors.background,
      body: CommonSwitchState(
        loaderState: loaderState,
        reload: () => notifier.loadProduct(widget.productId),
        loader: const Center(child: CommonLoader()),
        buttonText: Strings.refresh,
        noData: const CommonEmptyState(
          title: Strings.noDataFound,
          message: Strings.noDataAvailableDesc,
        ),
        child: detail == null
            ? const SizedBox.shrink()
            : Stack(
                children: [
                  ProductDetailContentWidget(detail: detail),
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
                        ProductDetailFloatingAction(
                          icon: isWishlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          iconColor: isWishlisted ? colors.primary : null,
                          onTap: notifier.toggleWishlist,
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
    );
  }
}
