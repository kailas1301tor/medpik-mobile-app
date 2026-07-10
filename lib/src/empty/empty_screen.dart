// /Users/wac/Documents/wac projects/tsuite/lib/src/empty/empty_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_avatar.dart';
import 'package:tsuite/utils/common_widgets/common_bottom_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_dialog_box.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_list_tile_item.dart';
import 'package:tsuite/utils/common_widgets/common_nav_bar_button.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_section_header.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonScaffold(
      backgroundColor: colors.background,
      safeAreaBottom: false,
      appBar: CommonAppBar(
        title: Strings.sharedWidgets,
        showBackButton: false,
        actions: [
          CommonNavBarButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              size: 18.r,
              color: colors.primaryText,
            ),
            badgeCount: 2,
            onTap: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 120.h),
        children: [
          CommonSectionHeader(
            title: Strings.sharedWidgets,
            subtitle: Strings.sharedWidgetsSubtitle,
          ),
          20.verticalSpace,
          CommonContainer(
            child: Column(
              children: [
                CommonListTileItem(
                  title: Strings.sampleTileTitle,
                  subtitle: Strings.sampleTileSubtitle,
                  leading: const CommonAvatar(initials: 'WP'),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16.r,
                    color: colors.secondaryText,
                  ),
                  showDivider: true,
                ),
                16.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: Strings.openDialog,
                        onPressed: () {
                          CommonDialogBox.show(
                            context: context,
                            title: Strings.componentDialogTitle,
                            message: Strings.componentDialogMessage,
                            primaryLabel: Strings.confirm,
                            secondaryLabel: Strings.cancel,
                            onPrimary: () {},
                          );
                        },
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: PrimaryButton(
                        text: Strings.openSheet,
                        onPressed: () {
                          CommonBottomSheet.show(
                            context: context,
                            title: Strings.componentBottomSheetTitle,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Text(
                                Strings.componentBottomSheetMessage,
                                style: FontPalette.base400(
                                  14,
                                  color: colors.secondaryText,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          20.verticalSpace,
          CommonContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonSectionHeader(
                  title: Strings.previewCardTitle,
                  subtitle: Strings.previewCardSubtitle,
                  actionText: Strings.seeDetails,
                  onActionTap: () {},
                ),
                16.verticalSpace,
                CommonEmptyState(
                  title: Strings.noDataTitle,
                  message: Strings.sampleEmptyMessage,
                  fillAvailableSpace: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
