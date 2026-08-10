// lib/src/profile/view/personal_information_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/profile/notifier/profile_notifier.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_text_form_field.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:medpik/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class PersonalInformationScreen extends ConsumerWidget {
  const PersonalInformationScreen({super.key, this.isOnboarding = false});

  final bool isOnboarding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(profileNotifierProvider.notifier);

    ref.listen(
      profileNotifierProvider.select((s) => s.loaderState),
      (previous, next) {
        if (next == LoaderState.loaded && previous != LoaderState.loaded) {
          notifier.initEditForm();
        }
      },
    );

    final formData = ref.watch(
      profileNotifierProvider.select(
        (s) => Tuple5(
          s.profile?.phoneNumber ?? '',
          s.isSaving,
          s.isProfileFormValid,
          s.firstNameError,
          s.lastNameError,
        ),
      ),
    );
    final phoneNumber = formData.item1;
    final isSaving = formData.item2;
    final isFormValid = formData.item3;
    final firstNameError = formData.item4;
    final lastNameError = formData.item5;

    return PopScope(
      canPop: !isOnboarding,
      child: CommonScaffold(
        appBar: CommonAppBar(
          title: Strings.personalInformation,
          showBackButton: !isOnboarding,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isOnboarding) ...[
                          Text(
                            Strings.completeYourProfile,
                            style: FontPalette.base400(
                              14,
                              color: colors.secondaryText,
                            ),
                          ),
                          16.verticalSpace,
                        ],
                        CommonTextFormField(
                          controller: notifier.firstNameController,
                          title: Strings.firstName,
                          hintText: Strings.firstNameHint,
                          errorText: firstNameError,
                          textCapitalization: TextCapitalization.words,
                        ),
                        16.verticalSpace,
                        CommonTextFormField(
                          controller: notifier.lastNameController,
                          title: Strings.lastName,
                          hintText: Strings.lastNameHint,
                          errorText: lastNameError,
                          textCapitalization: TextCapitalization.words,
                        ),
                        16.verticalSpace,
                        CommonTextFormField(
                          title: Strings.phoneNumber,
                          hintText: phoneNumber,
                          readOnly: true,
                          filledColor: colors.surface,
                        ),
                        8.verticalSpace,
                        Text(
                          Strings.profilePhoneReadOnlyHint,
                          style: FontPalette.base400(
                            12,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                16.verticalSpace,
                PrimaryButton(
                  text: Strings.save,
                  isLoading: isSaving,
                  onPressed: isSaving || !isFormValid
                      ? null
                      : () async {
                          final success = await notifier.updateProfile();
                          if (!success || !context.mounted) return;

                          if (isOnboarding) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteConstants.mainScreen,
                              (_) => false,
                            );
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
