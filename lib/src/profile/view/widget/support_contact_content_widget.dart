// lib/src/profile/view/widget/support_contact_content_widget.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/profile/model/store_profile_model.dart';
import 'package:medpik/src/profile/view/widget/profile_menu_section.dart';
import 'package:medpik/src/profile/view/widget/profile_menu_tile.dart';
import 'package:medpik/utils/helpers/email_launch_helper.dart';
import 'package:medpik/utils/helpers/phone_launch_helper.dart';

class SupportContactContentWidget extends StatelessWidget {
  const SupportContactContentWidget({super.key, required this.storeProfile});

  final StoreProfileModel? storeProfile;

  @override
  Widget build(BuildContext context) {
    final supportPhone = storeProfile?.supportPhone.trim() ?? '';
    final supportEmail = storeProfile?.supportEmail.trim() ?? '';
    final hasPhone = supportPhone.isNotEmpty;
    final hasEmail = supportEmail.isNotEmpty;

    return ProfileMenuSection(
      title: Strings.contactSupport,
      children: [
        if (hasPhone)
          ProfileMenuTile(
            icon: Icons.phone_outlined,
            title: Strings.callSupport,
            subtitle: supportPhone,
            showDivider: hasEmail,
            onTap: () => launchPhoneCall(supportPhone),
          ),
        if (hasEmail)
          ProfileMenuTile(
            icon: Icons.email_outlined,
            title: Strings.emailSupport,
            subtitle: supportEmail,
            showDivider: false,
            onTap: () => launchSupportEmail(supportEmail),
          ),
      ],
    );
  }
}
