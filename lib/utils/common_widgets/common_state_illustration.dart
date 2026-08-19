// lib/utils/common_widgets/common_state_illustration.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:medpik/res/styles/color_palette.dart';

class CommonStateIllustration extends StatelessWidget {
  const CommonStateIllustration({
    super.key,
    required this.assetPath,
    required this.fallbackIcon,
    this.dimension = 210,
    this.lottieRepeat = true,
  });

  final String? assetPath;
  final IconData fallbackIcon;
  final double dimension;
  final bool lottieRepeat;

  @override
  Widget build(BuildContext context) {
    final path = assetPath;
    if (path == null || path.isEmpty) {
      return _FallbackIcon(icon: fallbackIcon);
    }

    final lowerPath = path.toLowerCase();
    if (lowerPath.endsWith('.json')) {
      return SizedBox.square(
        dimension: dimension.r,
        child: Lottie.asset(
          path,
          repeat: lottieRepeat,
          errorBuilder: (_, __, ___) => _FallbackIcon(icon: fallbackIcon),
        ),
      );
    }

    if (lowerPath.endsWith('.svg')) {
      return SizedBox.square(
        dimension: dimension.r,
        child: SvgPicture.asset(
          path,
          placeholderBuilder: (_) => const CupertinoActivityIndicator(),
        ),
      );
    }

    return SizedBox.square(
      dimension: dimension.r,
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _FallbackIcon(icon: fallbackIcon),
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 82.r, color: context.appColors.secondaryText);
  }
}
