// lib/src/product_detail/view/widget/product_detail_sticky_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/services/cart_facade_service.dart';
import 'package:tsuite/src/main/notifier/main_shell_notifier.dart';
import 'package:tsuite/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_sticky_bottom_bar.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/extensions/context_extensions.dart';
import 'package:tsuite/utils/extensions/num_extensions.dart';
import 'package:tuple/tuple.dart';

class ProductDetailStickyFooter extends ConsumerWidget {
  const ProductDetailStickyFooter({super.key});

  static const int _cartTabIndex = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailData = ref.watch(
      productDetailNotifierProvider.select(
        (s) => Tuple3(
          s.detail?.product.id,
          s.detail?.product.price,
          s.quantity,
        ),
      ),
    );
    final productId = detailData.item1;
    final unitPrice = detailData.item2;
    final localQuantity = detailData.item3;
    final cartQuantity = productId == null
        ? 0
        : ref.watch(cartProductQuantityProvider(productId));
    final isInCart = cartQuantity > 0;
    final notifier = ref.read(productDetailNotifierProvider.notifier);

    if (isInCart) {
      return CommonStickyBottomBar(
        child: PrimaryButton(
          text: Strings.goToCart,
          height: 48,
          onPressed: () => _goToCart(context, ref),
        ),
      );
    }

    final lineTotal = (unitPrice ?? 0) * localQuantity;
    final ctaLabel = unitPrice != null && unitPrice > 0
        ? '${Strings.addToCart} · ${lineTotal.toCurrency(decimalDigits: 0)}'
        : Strings.addToCart;

    return CommonStickyBottomBar(
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: ctaLabel,
              height: 48,
              onPressed: notifier.addToCart,
            ),
          ),
          12.horizontalSpace,
          _GoToCartButton(onTap: () => _goToCart(context, ref)),
        ],
      ),
    );
  }

  void _goToCart(BuildContext context, WidgetRef ref) {
    ref.read(mainShellNotifierProvider.notifier).setTab(_cartTabIndex);
    context.popUntilFirst();
  }
}

class _GoToCartButton extends StatelessWidget {
  const _GoToCartButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: Strings.goToCart,
      child: Material(
        color: ColorPalette.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Ink(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPalette.productAccentTeal.withValues(alpha: 0.12),
              border: Border.all(
                color: ColorPalette.productAccentTeal.withValues(alpha: 0.28),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                MedpikSvgAssets.shopping,
                width: 22.r,
                height: 22.r,
                colorFilter: const ColorFilter.mode(
                  ColorPalette.productAccentTeal,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
