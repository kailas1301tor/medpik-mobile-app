// lib/src/orders/view/widget/order_detail_prescriptions_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';

class OrderDetailPrescriptionsSection extends StatelessWidget {
  const OrderDetailPrescriptionsSection({
    super.key,
    required this.imageUrls,
  });

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final urls = imageUrls
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList(growable: false);
    if (urls.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.attachedPrescriptionsTitle,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        10.verticalSpace,
        SizedBox(
          height: 88.r,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: urls.length,
            separatorBuilder: (_, __) => 10.horizontalSpace,
            itemBuilder: (context, index) {
              final url = urls[index];
              return GestureDetector(
                onTap: () => _OrderPrescriptionPreview.show(context, url),
                child: CommonCachedNetworkImage(
                  imageUrl: url,
                  width: 88.r,
                  height: 88.r,
                  borderRadius: 12.r,
                  fit: BoxFit.cover,
                  errorWidget: CommonNetworkImageIconFallback(
                    width: 88.r,
                    height: 88.r,
                    borderRadius: 12.r,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OrderPrescriptionPreview {
  _OrderPrescriptionPreview._();

  static Future<void> show(BuildContext context, String imageUrl) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _OrderPrescriptionPreviewScreen(imageUrl: imageUrl),
      ),
    );
  }
}

class _OrderPrescriptionPreviewScreen extends StatelessWidget {
  const _OrderPrescriptionPreviewScreen({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      backgroundColor: ColorPalette.black,
      enableFadeIn: false,
      appBar: CommonAppBar(
        title: '',
        backgroundColor: ColorPalette.black,
        iconColor: ColorPalette.white,
        showBackButton: false,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 24.r,
            color: ColorPalette.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: Center(
          child: CommonCachedNetworkImage(
            imageUrl: imageUrl,
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.7,
            fit: BoxFit.contain,
            borderRadius: 0,
            memCacheMax: 1200,
            errorWidget: CommonNetworkImageIconFallback(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.7,
              borderRadius: 0,
            ),
          ),
        ),
      ),
    );
  }
}
