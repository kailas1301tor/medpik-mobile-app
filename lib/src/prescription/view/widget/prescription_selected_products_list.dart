// lib/src/prescription/view/widget/prescription_selected_products_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/prescription_selected_product_model.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_product_quantity_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';
import 'package:tsuite/utils/common_widgets/common_delete_icon.dart';

class PrescriptionSelectedProductsList extends ConsumerWidget {
  const PrescriptionSelectedProductsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProducts = ref.watch(
      prescriptionNotifierProvider.select((s) => s.selectedProducts),
    );

    if (selectedProducts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        children: List.generate(selectedProducts.length, (index) {
          final item = selectedProducts[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == selectedProducts.length - 1 ? 0 : 8.h,
            ),
            child: _SelectedProductCard(
              item: item,
              onTap: () => PrescriptionProductQuantitySheet.show(
                context,
                ref,
                product: item.product,
              ),
              onRemove: () => ref
                  .read(prescriptionNotifierProvider.notifier)
                  .removeSelectedProduct(item.product.id),
            ),
          );
        }),
      ),
    );
  }
}

class _SelectedProductCard extends StatelessWidget {
  const _SelectedProductCard({
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  final PrescriptionSelectedProductModel item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = item.product;
    final imageSize = 44.r;

    return Material(
      color: ColorPalette.productCardBg,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: ColorPalette.productCardBorder, width: 1.w),
          ),
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
                      style: FontPalette.base600(14, color: colors.primaryText),
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
              8.horizontalSpace,
              Column(
                children: [
                  Text(
                    '×${item.quantity}',
                    style: FontPalette.base700(14, color: ColorPalette.productAccentTeal),
                  ),
                  8.verticalSpace,
                  GestureDetector(
                    onTap: onRemove,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.all(2.r),
                      child: CommonDeleteIcon(size: 18.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
