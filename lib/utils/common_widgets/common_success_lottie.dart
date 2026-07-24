// lib/utils/common_widgets/common_success_lottie.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:medpik/res/constants/assets.dart';

class CommonSuccessLottie extends StatefulWidget {
  const CommonSuccessLottie({super.key, this.size});

  final double? size;

  @override
  State<CommonSuccessLottie> createState() => _CommonSuccessLottieState();
}

class _CommonSuccessLottieState extends State<CommonSuccessLottie>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size ?? 250.w,
      child: Lottie.asset(
        Assets.lottieSuccess,
        controller: _controller,
        repeat: false,
        fit: BoxFit.contain,
        onLoaded: (_) => _controller.forward(from: 0),
      ),
    );
  }
}
