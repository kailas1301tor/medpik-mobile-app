// lib/src/orders/view/widget/order_tile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/medpik_image_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/orders/view/widget/order_status_badge.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderTileHeader extends StatelessWidget {
  const OrderTileHeader({super.key, required this.order});

  final OrderModel order;

  static double get productTileSize => 48.r;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final displayId = order.displayOrderId.isNotEmpty
        ? order.displayOrderId
        : Strings.emDash;
    final imageUrls = order.previewImageUrls;
    final itemCount = orderItemCount(order);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Strings.orderIdLabel,
                    style: FontPalette.base400(11, color: colors.secondaryText),
                  ),
                  4.verticalSpace,
                  Text(
                    displayId,
                    style: FontPalette.base700(15, color: colors.primaryText),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            8.horizontalSpace,
            OrderStatusBadge(
              status: order.status,
              label: order.displayStatus.isNotEmpty
                  ? order.displayStatus
                  : null,
              showLeadingIcon: true,
            ),
          ],
        ),
        12.verticalSpace,
        _OrderProductTilesRow(
          imageUrls: imageUrls,
          itemCount: itemCount,
        ),
      ],
    );
  }
}

/// Separate small squircle product tiles (same style as product cards).
class _OrderProductTilesRow extends StatelessWidget {
  const _OrderProductTilesRow({
    required this.imageUrls,
    required this.itemCount,
  });

  final List<String> imageUrls;
  final int itemCount;

  static const int _maxVisible = 4;

  @override
  Widget build(BuildContext context) {
    final size = OrderTileHeader.productTileSize;
    final urls = imageUrls;

    if (urls.isEmpty) {
      return _ProductSquircleTile.asset(
        assetPath: MedpikImageAssets.orderProductPlaceholder,
        size: size,
      );
    }

    final needsOverflow = urls.length > _maxVisible;
    final photoCount = needsOverflow ? _maxVisible - 1 : urls.length;
    final overflowFromUrls = urls.length - photoCount;
    final overflowFromItems =
        itemCount > photoCount ? itemCount - photoCount : 0;
    final overflow =
        overflowFromItems > overflowFromUrls
            ? overflowFromItems
            : overflowFromUrls;
    final showOverflow = overflow > 0 && (needsOverflow || itemCount > urls.length);

    return SizedBox(
      height: size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: photoCount + (showOverflow ? 1 : 0),
        separatorBuilder: (_, _) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          if (showOverflow && index == photoCount) {
            return _ProductSquircleTile.overflow(count: overflow, size: size);
          }
          return _ProductSquircleTile.network(
            imageUrl: urls[index],
            size: size,
          );
        },
      ),
    );
  }
}

class _ProductSquircleTile extends StatelessWidget {
  const _ProductSquircleTile._({
    required this.size,
    this.imageUrl,
    this.assetPath,
    this.overflowCount,
  });

  factory _ProductSquircleTile.network({
    required String imageUrl,
    required double size,
  }) =>
      _ProductSquircleTile._(size: size, imageUrl: imageUrl);

  factory _ProductSquircleTile.asset({
    required String assetPath,
    required double size,
  }) =>
      _ProductSquircleTile._(size: size, assetPath: assetPath);

  factory _ProductSquircleTile.overflow({
    required int count,
    required double size,
  }) =>
      _ProductSquircleTile._(size: size, overflowCount: count);

  final double size;
  final String? imageUrl;
  final String? assetPath;
  final int? overflowCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = 14.r;

    if (overflowCount != null) {
      return SmoothContainer(
        width: size,
        height: size,
        smoothness: 2,
        color: colors.background.withValues(alpha: 0.9),
        side: BorderSide(
          color: colors.cardBorder.withValues(alpha: 0.5),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(radius),
        child: Center(
          child: Text(
            '+$overflowCount',
            style: FontPalette.base700(12, color: colors.primaryText),
          ),
        ),
      );
    }

    if (assetPath != null) {
      return SmoothClipRRect(
        smoothness: 2,
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: colors.cardBorder.withValues(alpha: 0.45),
          width: 1.w,
        ),
        child: Image.asset(
          assetPath!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return CommonCachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: radius,
      fit: BoxFit.cover,
      memCacheMax: 160,
    );
  }
}
