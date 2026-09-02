// lib/src/profile/view/help_and_support_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/profile/notifier/profile_notifier.dart';
import 'package:medpik/src/profile/view/widget/support_contact_content_widget.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_refresh_indicator.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:tuple/tuple.dart';

class HelpAndSupportScreen extends ConsumerWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportData = ref.watch(
      profileNotifierProvider.select(
        (state) => Tuple2(state.supportLoaderState, state.storeProfile),
      ),
    );
    final notifier = ref.read(profileNotifierProvider.notifier);

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.helpAndSupport),
      body: CommonRefreshIndicator(
        onRefresh: notifier.fetchStoreProfile,
        child: CommonSwitchState(
          loaderState: supportData.item1,
          reload: notifier.fetchStoreProfile,
          buttonText: Strings.refresh,
          emptyScreenTitle: Strings.noSupportContacts,
          emptyScreenDescription: Strings.noSupportContactsDescription,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            children: [
              SupportContactContentWidget(storeProfile: supportData.item2),
            ],
          ),
        ),
      ),
    );
  }
}
