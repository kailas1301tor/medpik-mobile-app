// lib/utils/helpers/shell_insets_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Clearance below a docked tab CTA when the main shell uses [Scaffold.extendBody].
double dockedFooterInset(BuildContext context, {double gap = 8}) {
  return MediaQuery.paddingOf(context).bottom + gap.h;
}

/// Bottom padding for scrollable main-shell tabs so the last item clears the
/// floating bottom navigation bar.
double shellScrollBottomPadding(BuildContext context) => 100.h;
