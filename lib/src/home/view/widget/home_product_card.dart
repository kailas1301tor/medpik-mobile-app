// // lib/src/home/view/widget/home_product_card.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:smooth_corner/smooth_corner.dart';
// import 'package:tsuite/data/models/product_model.dart';
// import 'package:tsuite/res/constants/string_constants.dart';
// import 'package:tsuite/res/styles/color_palette.dart';
// import 'package:tsuite/res/styles/font_palette.dart';
// import 'package:tsuite/utils/common_widgets/common_container.dart';

// class HomeProductCard extends StatelessWidget {
//   const HomeProductCard({super.key, this.product, this.onTap});

//   final ProductModel? product;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.appColors;
//     final hasDiscount = (product?.discountPercent ?? 0) > 0;
//     final hasMrp = (product?.mrp ?? 0) > (product?.price ?? 0);

//     return GestureDetector(
//       onTap: onTap,
//       child: CommonContainer(
//         // padding: EdgeInsets.all(12.r),
//         borderRadius: 16.r,
//         color: colors.surface,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 // Container(
//                 //   height: 100.h,
//                 //   width: double.infinity,
//                 //   decoration: BoxDecoration(
//                 //     color: colors.inputBorder.withValues(alpha: 0.2),
//                 //     borderRadius: BorderRadius.circular(12.r),
//                 //   ),
//                 //   child: Icon(
//                 //     Icons.medication_outlined,
//                 //     size: 36.r,
//                 //     color: colors.primary,
//                 //   ),
//                 // ),
//                 // if (hasDiscount)
//                 //   Positioned(
//                 //     top: 6.h,
//                 //     left: 6.w,
//                 //     child: SmoothContainer(
//                 //       smoothness: 2,
//                 //       padding: EdgeInsets.symmetric(
//                 //         horizontal: 6.w,
//                 //         vertical: 3.h,
//                 //       ),
//                 //       color: colors.primary,
//                 //       borderRadius: BorderRadius.circular(6.r),
//                 //       child: Text(
//                 //         '${product?.discountPercent}${Strings.percentOff}',
//                 //         style: FontPalette.base500(
//                 //           8,
//                 //           color: ColorPalette.white,
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 Positioned(
//                   top: 6.h,
//                   right: 6.w,
//                   child: Icon(
//                     Icons.favorite_border_rounded,
//                     size: 18.r,
//                     color: colors.secondaryText,
//                   ),
//                 ),
//               ],
//             ),
//             10.verticalSpace,
//             Text(
//               product?.name ?? '',
//               style: FontPalette.base600(13, color: colors.primaryText),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             if (product?.packSize.isNotEmpty ?? false) ...[
//               2.verticalSpace,
//               Text(
//                 product?.packSize ?? '',
//                 style: FontPalette.base400(11, color: colors.secondaryText),
//               ),
//             ],
//             6.verticalSpace,
//             Row(
//               children: [
//                 Text(
//                   '₹${product?.price.toStringAsFixed(0) ?? ''}',
//                   style: FontPalette.base700(15, color: colors.primaryText),
//                 ),
//                 if (hasMrp) ...[
//                   6.horizontalSpace,
//                   Text(
//                     '₹${product?.mrp?.toStringAsFixed(0) ?? ''}',
//                     style: FontPalette.base400(
//                       12,
//                       color: colors.secondaryText,
//                     ).copyWith(decoration: TextDecoration.lineThrough),
//                   ),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
