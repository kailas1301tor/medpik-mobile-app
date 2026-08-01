// lib/src/profile/view/widget/profile_user_card_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class ProfileUserCardShimmer extends StatelessWidget {
  const ProfileUserCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonShimmerBox(
      height: 116.h,
      width: double.infinity,
      borderRadius: 20.r,
    );
  }
}
