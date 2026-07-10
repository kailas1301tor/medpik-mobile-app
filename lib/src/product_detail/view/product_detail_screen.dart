// lib/src/product_detail/view/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(productDetailNotifierProvider.notifier);

    Future.microtask(() => notifier.loadProduct(productId));

    final loaderState = ref.watch(
      productDetailNotifierProvider.select((s) => s.loaderState),
    );
    final product = ref.watch(
      productDetailNotifierProvider.select((s) => s.product),
    );
    final quantity = ref.watch(
      productDetailNotifierProvider.select((s) => s.quantity),
    );

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.productDetails),
      backgroundColor: colors.background,
      body: CommonSwitchState(
        loaderState: loaderState,
        reload: () => notifier.loadProduct(productId),
        loader: const Center(child: CommonLoader()),
        buttonText: Strings.refresh,
        noData: const CommonEmptyState(
          title: Strings.noDataFound,
          message: Strings.noDataAvailableDesc,
        ),
        child: product == null
            ? const SizedBox.shrink()
            : SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonContainer(
                      width: double.infinity,
                      height: 220.h,
                      borderRadius: 20.r,
                      color: colors.surface,
                      child: Icon(
                        Icons.medication_outlined,
                        size: 72.r,
                        color: colors.primary,
                      ),
                    ),
                    20.verticalSpace,
                    Text(
                      product.name,
                      style: FontPalette.base700(24, color: colors.primaryText),
                    ),
                    8.verticalSpace,
                    Text(
                      product.category,
                      style: FontPalette.base400(14, color: colors.secondaryText),
                    ),
                    if (product.requiresPrescription) ...[
                      12.verticalSpace,
                      Text(
                        Strings.prescriptionRequired,
                        style: FontPalette.base600(14, color: colors.primary),
                      ),
                    ],
                    16.verticalSpace,
                    Text(
                      product.description,
                      style: FontPalette.base400(15, color: colors.primaryText),
                    ),
                    24.verticalSpace,
                    Row(
                      children: [
                        Text(
                          Strings.quantity,
                          style: FontPalette.base600(15, color: colors.primaryText),
                        ),
                        const Spacer(),
                        _QuantityButton(
                          icon: Icons.remove,
                          onTap: notifier.decrementQuantity,
                        ),
                        16.horizontalSpace,
                        Text(
                          '$quantity',
                          style: FontPalette.base700(18, color: colors.primaryText),
                        ),
                        16.horizontalSpace,
                        _QuantityButton(
                          icon: Icons.add,
                          onTap: notifier.incrementQuantity,
                        ),
                      ],
                    ),
                    32.verticalSpace,
                    PrimaryButton(
                      text: Strings.addToCart,
                      onPressed: () => notifier.addToCart(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: CommonContainer(
        padding: EdgeInsets.all(10.r),
        borderRadius: 12.r,
        color: colors.surface,
        child: Icon(icon, size: 20.r, color: colors.primary),
      ),
    );
  }
}
