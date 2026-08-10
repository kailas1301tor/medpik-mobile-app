// lib/src/product_detail/view/widget/product_detail_sticky_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/providers/cart_providers.dart';
import 'package:medpik/providers/shell_providers.dart';
import 'package:medpik/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:medpik/utils/helpers/cart_quantity_helper.dart';
import 'package:medpik/utils/common_widgets/common_sticky_bottom_bar.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:medpik/utils/extensions/context_extensions.dart';
import 'package:medpik/utils/extensions/num_extensions.dart';
import 'package:tuple/tuple.dart';

class ProductDetailStickyFooter extends ConsumerStatefulWidget {
  const ProductDetailStickyFooter({super.key});

  @override
  ConsumerState<ProductDetailStickyFooter> createState() =>
      _ProductDetailStickyFooterState();
}

class _ProductDetailStickyFooterState extends ConsumerState<ProductDetailStickyFooter>
    with SingleTickerProviderStateMixin {
  static const int _cartTabIndex = 2;
  static const Duration _morphDuration = Duration(milliseconds: 340);

  late final AnimationController _morphController;
  late final Animation<double> _morph;
  bool? _wasInCart;
  bool _wasMutating = false;
  bool _morphInitialized = false;

  @override
  void initState() {
    super.initState();
    _morphController = AnimationController(
      vsync: this,
      duration: _morphDuration,
    );
    _morph = CurvedAnimation(
      parent: _morphController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _morphController.dispose();
    super.dispose();
  }

  void _syncMorphAnimation({
    required bool isInCart,
    required bool isCartMutating,
  }) {
    if (!_morphInitialized) {
      _morphInitialized = true;
      _morphController.value = isInCart ? 1 : 0;
      _wasInCart = isInCart;
      return;
    }

    if (isCartMutating) {
      _wasMutating = true;
      return;
    }

    if (_wasMutating) {
      _wasMutating = false;
      if (isInCart) {
        _morphController.forward(from: _morphController.value);
      } else {
        _morphController.reverse(from: _morphController.value);
      }
    } else if (_wasInCart != isInCart) {
      if (isInCart) {
        _morphController.forward(from: _morphController.value);
      } else {
        _morphController.reverse(from: _morphController.value);
      }
    }

    _wasInCart = isInCart;
  }

  @override
  Widget build(BuildContext context) {
    final isFromUploadPrescription = ref.watch(
      productDetailNotifierProvider.select((s) => s.isFromUploadPrescription),
    );
    if (isFromUploadPrescription) {
      final notifier = ref.read(productDetailNotifierProvider.notifier);
      return CommonStickyBottomBar(
        child: PrimaryButton(
          text: Strings.add,
          height: 48,
          onPressed: () async {
            final ok = await notifier.addToPrescription();
            if (ok && context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      );
    }

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
        : ref.watch(
            cartNotifierProvider.select(
              (s) => cartQuantityForProduct(s.items, productId),
            ),
          );
    final isInCart = cartQuantity > 0;
    final isCartMutating = ref.watch(
      cartNotifierProvider.select((s) => s.isMutating),
    );
    _syncMorphAnimation(isInCart: isInCart, isCartMutating: isCartMutating);

    final notifier = ref.read(productDetailNotifierProvider.notifier);
    final lineTotal = (unitPrice ?? 0) * localQuantity;
    final ctaLabel = unitPrice != null && unitPrice > 0
        ? '${Strings.addToCart} · ${lineTotal.toCurrency(decimalDigits: 0)}'
        : Strings.addToCart;

    return CommonStickyBottomBar(
      child: AnimatedBuilder(
        animation: _morph,
        builder: (context, _) {
          final morph = _morph.value;

          return Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      IgnorePointer(
                        ignoring: morph > 0.5,
                        child: Opacity(
                          opacity: 1 - morph,
                          child: PrimaryButton(
                            text: ctaLabel,
                            height: 48,
                            onPressed: notifier.addToCart,
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: morph < 0.5,
                        child: Opacity(
                          opacity: morph,
                          child: PrimaryButton(
                            text: Strings.goToCart,
                            height: 48,
                            onPressed: () => _goToCart(context, ref),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: 1 - morph,
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: _GoToCartButton(
                      onTap: () => _goToCart(context, ref),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
