// lib/src/address/view/widget/address_book_shimmer_widget.dart
//
// ? Loading placeholder for [AddressBookScreen] list (4 skeleton tiles).
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class AddressBookShimmerWidget extends StatelessWidget {
  const AddressBookShimmerWidget({super.key});

  static const int _itemCount = 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        return CommonContainer(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.r),
          borderRadius: 16.r,
          color: colors.surface,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonShimmerBox(
                height: 22.r,
                width: 22.r,
                borderRadius: 11.r,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonShimmerBox(
                      height: 16.h,
                      width: 120.w,
                      borderRadius: 6.r,
                    ),
                    8.verticalSpace,
                    CommonShimmerBox(
                      height: 12.h,
                      width: double.infinity,
                      borderRadius: 6.r,
                    ),
                    6.verticalSpace,
                    CommonShimmerBox(
                      height: 12.h,
                      width: 180.w,
                      borderRadius: 6.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
