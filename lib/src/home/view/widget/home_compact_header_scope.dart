// lib/src/home/view/widget/home_compact_header_scope.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/home/notifier/home_notifier.dart';
import 'package:medpik/src/home/view/widget/home_compact_header.dart';
import 'package:medpik/utils/extensions/context_extensions.dart';

class HomeCompactHeaderScope extends ConsumerWidget {
  const HomeCompactHeaderScope({
    super.key,
    required this.topInset,
    required this.deliveryHint,
    required this.onSearchTap,
  });

  final double topInset;
  final String deliveryHint;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compactProgress = ref.watch(
      homeNotifierProvider.select((s) => s.compactHeaderProgress),
    );
    final useDarkStatusIcons = compactProgress > 0.5 && !context.isDarkMode;

    final colors = context.appColors;
    final navBarIconBrightness = colors.background.computeLuminance() > 0.179
        ? Brightness.dark
        : Brightness.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: ColorPalette.transparent,
        statusBarIconBrightness: useDarkStatusIcons
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: useDarkStatusIcons
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: colors.background,
        systemNavigationBarIconBrightness: navBarIconBrightness,
        systemNavigationBarContrastEnforced: true,
      ),
      child: HomeCompactHeader(
        progress: compactProgress,
        topInset: topInset,
        deliveryHint: deliveryHint,
        onSearchTap: onSearchTap,
      ),
    );
  }
}
