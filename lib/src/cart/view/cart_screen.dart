// lib/src/cart/view/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/generated/assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final items = ref.watch(cartNotifierProvider.select((s) => s.items));
    final notifier = ref.read(cartNotifierProvider.notifier);

    return CommonScaffold(
      safeAreaBottom: false,
      appBar: const CommonAppBar(title: Strings.cartTitle, showBackButton: false),
      backgroundColor: colors.background,
      body: items.isEmpty
          ? const CommonEmptyState(
              title: Strings.cartTitle,
              message: Strings.cartEmptyMessage,
              imageAsset: Assets.iconsProductNavIcon,
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(20.r),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CommonContainer(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.r),
                        borderRadius: 16.r,
                        color: colors.surface,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: FontPalette.base600(
                                      15,
                                      color: colors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                _CartQtyButton(
                                  icon: Icons.remove,
                                  onTap: () =>
                                      notifier.decrementItem(item.product.id),
                                ),
                                12.horizontalSpace,
                                Text(
                                  '${item.quantity}',
                                  style: FontPalette.base600(
                                    15,
                                    color: colors.primaryText,
                                  ),
                                ),
                                12.horizontalSpace,
                                _CartQtyButton(
                                  icon: Icons.add,
                                  onTap: () =>
                                      notifier.incrementItem(item.product.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                CommonContainer(
                  margin: EdgeInsets.all(20.r),
                  padding: EdgeInsets.all(16.r),
                  borderRadius: 16.r,
                  color: colors.surface,
                  child: PrimaryButton(
                    text: Strings.proceedToCheckout,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RouteConstants.routeCheckoutScreen,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartQtyButton extends StatelessWidget {
  const _CartQtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: colors.inputBorder.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 18.r, color: colors.primary),
      ),
    );
  }
}
