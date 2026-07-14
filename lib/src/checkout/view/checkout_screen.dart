// lib/src/checkout/view/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/data/models/prescription_selected_product_model.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/checkout/notifier/checkout_notifier.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final loaderState = ref.watch(
      checkoutNotifierProvider.select((s) => s.loaderState),
    );
    final address = ref.watch(
      checkoutNotifierProvider.select((s) => s.selectedAddress),
    );
    final hasPrescription = ref.watch(
      checkoutNotifierProvider.select((s) => s.hasPrescription),
    );
    final cartItems = ref.watch(cartNotifierProvider.select((s) => s.items));
    final prescriptionDraft = ref.watch(
      prescriptionNotifierProvider.select((s) => s.draft),
    );
    final notifier = ref.read(checkoutNotifierProvider.notifier);

    if (loaderState == LoaderState.loading) {
      return CommonScaffold(
        appBar: const CommonAppBar(title: Strings.checkout),
        body: const Center(child: CommonLoader()),
      );
    }

    if (loaderState == LoaderState.error) {
      return CommonScaffold(
        appBar: const CommonAppBar(title: Strings.checkout),
        body: CommonEmptyState(
          title: Strings.errorTitle,
          message: Strings.cartAndPrescriptionEmpty,
          buttonText: Strings.goBackButton,
          onPressed: () => Navigator.pop(context),
        ),
      );
    }

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.checkout),
      backgroundColor: colors.background,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.r),
              children: [
                Text(
                  Strings.deliveryAddress,
                  style: FontPalette.base700(16, color: colors.primaryText),
                ),
                12.verticalSpace,
                CommonContainer(
                  padding: EdgeInsets.all(16.r),
                  borderRadius: 16.r,
                  color: colors.surface,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        MedpikSvgAssets.location,
                        width: 22.r,
                        height: 22.r,
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Text(
                          address?.fullAddress ?? Strings.noAddressSaved,
                          style: FontPalette.base400(
                            14,
                            color: colors.secondaryText,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouteConstants.routeAddressBookScreen,
                          );
                        },
                        child: Text(
                          Strings.changeAddress,
                          style: FontPalette.base600(13, color: colors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                24.verticalSpace,
                Text(
                  Strings.orderSummary,
                  style: FontPalette.base700(16, color: colors.primaryText),
                ),
                12.verticalSpace,
                if (hasPrescription)
                  CommonContainer(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.r),
                    borderRadius: 12.r,
                    color: colors.primary.withValues(alpha: 0.08),
                    child: Text(
                      Strings.prescriptionAttached,
                      style: FontPalette.base600(14, color: colors.primary),
                    ),
                  ),
                if ((prescriptionDraft?.selectedProducts.isNotEmpty ?? false)) ...[
                  Text(
                    Strings.prescriptionProducts,
                    style: FontPalette.base700(15, color: colors.primaryText),
                  ),
                  12.verticalSpace,
                  ...prescriptionDraft!.selectedProducts.map(
                    (item) => _PrescriptionSelectedProductTile(item: item),
                  ),
                  16.verticalSpace,
                ],
                ...cartItems.map(
                  (item) => CommonContainer(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(12.r),
                    borderRadius: 12.r,
                    color: colors.surface,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.product.name,
                            style: FontPalette.base500(
                              14,
                              color: colors.primaryText,
                            ),
                          ),
                        ),
                        Text(
                          'x${item.quantity}',
                          style: FontPalette.base400(
                            13,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          CommonContainer(
            margin: EdgeInsets.all(20.r),
            padding: EdgeInsets.all(16.r),
            borderRadius: 16.r,
            color: colors.surface,
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: Strings.placeOrder,
                onPressed: address == null
                    ? null
                    : () async {
                        final orderId = await notifier.placeOrder();
                        if (orderId != null && context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteConstants.routeConfirmationScreen,
                            (route) => route.settings.name == RouteConstants.mainScreen,
                            arguments: orderId,
                          );
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionSelectedProductTile extends StatelessWidget {
  const _PrescriptionSelectedProductTile({required this.item});

  final PrescriptionSelectedProductModel item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = item.product;
    final imageSize = 40.r;

    return CommonContainer(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.r),
      borderRadius: 12.r,
      color: colors.surface,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(imageSize / 2),
            child: CommonCachedNetworkImage(
              imageUrl: product.imageUrl,
              width: imageSize,
              height: imageSize,
              memCacheWidth: 100,
              memCacheHeight: 100,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: FontPalette.base500(14, color: colors.primaryText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (product.packSize.isNotEmpty) ...[
                  2.verticalSpace,
                  Text(
                    product.packSize,
                    style: FontPalette.base400(12, color: colors.secondaryText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'x${item.quantity}',
                style: FontPalette.base400(13, color: colors.secondaryText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
