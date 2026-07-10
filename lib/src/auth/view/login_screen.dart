// lib/src/auth/view/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'widget/login_form_widget.dart';
import 'widget/login_header_widget.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    return CommonScaffold(
      backgroundColor: colors.background,

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  100.verticalSpace,
                  const LoginHeaderWidget(),
                  30.verticalSpace,
                  const LoginFormWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
