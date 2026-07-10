// lib/src/auth/view/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_avatar.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tsuite/utils/helpers/validators.dart';
import '../notifier/auth_notifier.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final notifier = ref.read(authNotifierProvider.notifier);
    final state = ref.watch(authNotifierProvider);

    return CommonScaffold(
      appBar: const CommonAppBar(title: "Registration"),
      // backgroundColor: colors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Interactive Profile Photo Section
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Tapping cycles through a couple of beautiful mock profile photos
                          const photos = [
                            'https://i.pravatar.cc/150?img=33',
                            'https://i.pravatar.cc/150?img=47',
                            'https://i.pravatar.cc/150?img=12',
                            'https://i.pravatar.cc/150?img=60',
                          ];
                          final currentIdx = photos.indexOf(
                            state.profilePhotoUrl ?? '',
                          );
                          final nextIdx = (currentIdx + 1) % photos.length;
                          notifier.setProfilePhoto(photos[nextIdx]);
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CommonAvatar(
                              imageUrl: state.profilePhotoUrl,
                              size: 100.r,
                              borderRadius: 50.r,
                            ),
                            Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.surface,
                                  width: 2.r,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 16.r,
                                color: ColorPalette.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        "Tap to set Profile Photo (Optional)",
                        style: FontPalette.base400(
                          12,
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                32.verticalSpace,

                // Full Name field
                CommonTextFormField(
                  controller: notifier.fullNameController,
                  title: "Full Name",
                  hintText: "Enter your full name",
                  filledColor: colors.surface,
                  borderRadius: 100,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                  validator: (val) => val.validateName,
                  textCapitalization: TextCapitalization.words,
                ),
                20.verticalSpace,

                // Phone Number field
                CommonTextFormField(
                  controller: notifier.registerPhoneController,
                  title: "Phone Number",
                  hintText: "Enter your 10-digit phone number",
                  filledColor: colors.surface,
                  borderRadius: 100,
                  inputType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (val) => val.validatePhone,
                ),
                20.verticalSpace,

                // Row for Age
                CommonTextFormField(
                  controller: notifier.ageController,
                  title: "Age",
                  hintText: "Enter your age",
                  filledColor: colors.surface,
                  borderRadius: 100,
                  inputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Age is required";
                    }
                    final ageNum = int.tryParse(val);
                    if (ageNum == null || ageNum <= 0 || ageNum > 120) {
                      return "Enter a valid age";
                    }
                    return null;
                  },
                ),
                20.verticalSpace,

                // Gender choice - Premium segmented options with validation
                FormField<String>(
                  initialValue: state.selectedGender,
                  validator: (value) {
                    if (state.selectedGender == null) {
                      return "Gender is required";
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> fieldState) {
                    final hasError = fieldState.hasError;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gender",
                          style: FontPalette.base500(
                            14,
                            color: hasError ? colors.errorText : colors.primaryText,
                          ),
                        ),
                        8.verticalSpace,
                        Row(
                          children: ['Male', 'Female', 'Other'].map((gender) {
                            final isSelected = state.selectedGender == gender;
                            IconData icon;
                            switch (gender) {
                              case 'Male':
                                icon = Icons.male_rounded;
                                break;
                              case 'Female':
                                icon = Icons.female_rounded;
                                break;
                              default:
                                icon = Icons.transgender_rounded;
                            }

                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: InkWell(
                                  onTap: () {
                                    notifier.setGender(gender);
                                    fieldState.didChange(gender);
                                  },
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? colors.primary.withValues(alpha: 0.1)
                                          : colors.surface,
                                      borderRadius: BorderRadius.circular(100.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? colors.primary
                                            : hasError
                                                ? colors.errorText
                                                : colors.inputBorder,
                                        width: isSelected ? 2.r : 1.r,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          icon,
                                          size: 18.r,
                                          color: isSelected
                                              ? colors.primary
                                              : colors.secondaryText,
                                        ),
                                        6.horizontalSpace,
                                        Text(
                                          gender,
                                          style: FontPalette.base600(
                                            14,
                                            color: isSelected
                                                ? colors.primary
                                                : colors.secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (hasError) ...[
                          6.verticalSpace,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              fieldState.errorText ?? "",
                              style: FontPalette.base400(
                                12,
                                color: colors.errorText,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                20.verticalSpace,

                // Address field
                CommonTextFormField(
                  controller: notifier.addressController,
                  title: "Address",
                  hintText: "Enter your full address",
                  filledColor: colors.surface,
                  borderRadius: 16, // rectangular but rounded for multi-line
                  minLines: 3,
                  maxLines: 5,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(200),
                  ],
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Address is required";
                    }
                    return null;
                  },
                ),
                32.verticalSpace,

                // Register Button
                Consumer(
                  builder: (context, ref, _) {
                    final isLoading = ref.watch(
                      authNotifierProvider.select(
                        (s) => s.loaderState == LoaderState.loading,
                      ),
                    );

                    return PrimaryButton(
                      text: "Register",
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () async {
                              // Force field validation check
                              if (_formKey.currentState?.validate() ?? false) {
                                final success = await notifier.registerUser();
                                if (success && context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteConstants.routeHomeScreen,
                                    (route) => false,
                                  );
                                }
                              }
                            },
                    );
                  },
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
