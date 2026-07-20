// lib/src/address/view/address_book_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/address/model/address_book_args.dart';
import 'package:tsuite/src/address/model/picked_location_model.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/address/view/widget/address_book_shimmer_widget.dart';
import 'package:tsuite/src/address/view/widget/address_form_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_nav_bar_button.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class AddressBookScreen extends ConsumerWidget {
  const AddressBookScreen({super.key, this.args = const AddressBookArgs()});

  final AddressBookArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final data = ref.watch(
      addressNotifierProvider.select((s) => Tuple2(s.loaderState, s.addresses)),
    );
    final loaderState = data.item1;
    final addresses = data.item2;
    final notifier = ref.read(addressNotifierProvider.notifier);

    return CommonScaffold(
      appBar: CommonAppBar(
        title: Strings.addressBook,
        actions: [
          CommonNavBarButton(
            icon: Icon(Icons.add, size: 20.r, color: colors.primaryText),
            onTap: () => _openAddFlow(context, ref),
          ),
        ],
      ),
      backgroundColor: colors.background,
      body: switch (loaderState) {
        LoaderState.loading => const AddressBookShimmerWidget(),
        LoaderState.noData => CommonEmptyState(
          title: Strings.noAddressSaved,
          message: Strings.addAddressToContinue,
          buttonText: Strings.addAddress,
          onPressed: () => _openAddFlow(context, ref),
        ),
        LoaderState.loaded => ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            final address = addresses[index];
            return _AddressTile(
              address: address,
              isSelectable: args.selectMode,
              isSelected: args.selectedAddressId == address.id,
              onTap: args.selectMode
                  ? () => Navigator.pop(context, address)
                  : null,
            );
          },
        ),
        _ => CommonEmptyState(
          title: Strings.errorTitle,
          message: Strings.errorDescription,
          buttonText: Strings.refresh,
          onPressed: notifier.fetchAddresses,
        ),
      },
    );
  }

  Future<void> _openAddFlow(BuildContext context, WidgetRef ref) async {
    final pick = await Navigator.pushNamed<PickedLocationModel>(
      context,
      RouteConstants.routeLocationPickerScreen,
    );
    if (pick == null || !context.mounted) return;

    ref.read(addressNotifierProvider.notifier).startAdd(pick: pick);
    await AddressFormSheet.show(context: context);
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.address,
    this.isSelectable = false,
    this.isSelected = false,
    this.onTap,
  });

  final AddressModel address;
  final bool isSelectable;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final content = CommonContainer(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      borderRadius: 16.r,
      color: colors.surface,
      side: isSelected ? BorderSide(color: colors.primary, width: 1.5.w) : null,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(MedpikSvgAssets.location, width: 22.r, height: 22.r),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        address.label,
                        style: FontPalette.base700(
                          16,
                          color: colors.primaryText,
                        ),
                      ),
                    ),
                    if (address.isDefault) ...[
                      8.horizontalSpace,
                      CommonContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        borderRadius: 8.r,
                        color: colors.primary.withValues(alpha: 0.12),
                        child: Text(
                          Strings.defaultAddress,
                          style: FontPalette.base600(11, color: colors.primary),
                        ),
                      ),
                    ],
                  ],
                ),
                8.verticalSpace,
                Text(
                  address.fullAddress,
                  style: FontPalette.base400(14, color: colors.secondaryText),
                ),
              ],
            ),
          ),
          if (isSelectable) ...[
            8.horizontalSpace,
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 22.r,
              color: isSelected ? colors.primary : colors.secondaryText,
            ),
          ],
        ],
      ),
    );

    return content;
  }
}
