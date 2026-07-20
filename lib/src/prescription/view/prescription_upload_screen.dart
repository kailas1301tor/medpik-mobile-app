// lib/src/prescription/view/prescription_upload_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_file_grid.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_guidelines_sheet.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_products_section.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_selected_products_list.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_source_sheet.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_upload_area.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_nav_bar_button.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class PrescriptionUploadScreen extends ConsumerWidget {
  const PrescriptionUploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(prescriptionNotifierProvider.notifier);
    final uploadData = ref.watch(
      prescriptionNotifierProvider.select(
        (s) => Tuple2(s.pickedPaths, s.loaderState == LoaderState.loading),
      ),
    );
    final pickedPaths = uploadData.item1;
    final isLoading = uploadData.item2;
    final hasFiles = pickedPaths.isNotEmpty;

    return CommonScaffold(
      appBar: CommonAppBar(
        title: Strings.prescriptionUploadTitle,
        actions: [
          CommonNavBarButton(
            icon: Icon(
              Icons.info_outline_rounded,
              size: 22.r,
              color: colors.primaryText,
            ),
            onTap: () => PrescriptionGuidelinesSheet.show(context),
          ),
        ],
      ),
      backgroundColor: colors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    Strings.prescriptionReviewNote,
                    style: FontPalette.base400(14, color: colors.secondaryText),
                  ),
                  16.verticalSpace,
                  if (!hasFiles)
                    PrescriptionUploadArea(
                      onTap: () => PrescriptionSourceSheet.show(context, ref),
                    ),
                  const PrescriptionFileGrid(),
                  24.verticalSpace,
                  Text(
                    Strings.prescriptionDescription,
                    style: FontPalette.base600(14, color: colors.primaryText),
                  ),
                  8.verticalSpace,
                  CommonTextFormField(
                    controller: notifier.notesController,
                    hintText: Strings.prescriptionDescriptionHint,
                    maxLines: 4,
                    minLines: 4,
                    borderRadius: 16,
                  ),
                  const PrescriptionSelectedProductsList(),
                  24.verticalSpace,
                  const PrescriptionProductsSection(),
                  if (isLoading) ...[
                    24.verticalSpace,
                    const Center(child: CommonLoader()),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: Strings.submit,
                isLoading: isLoading,
                onPressed: !hasFiles || isLoading
                    ? null
                    : () async {
                        final ok = await notifier.submit();
                        if (ok && context.mounted) {
                          Navigator.pushNamed(
                            context,
                            RouteConstants.routePrescriptionCheckoutScreen,
                          );
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
