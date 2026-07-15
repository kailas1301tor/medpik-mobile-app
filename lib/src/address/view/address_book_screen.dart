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
import 'package:tsuite/src/address/model/location_picker_args.dart';
import 'package:tsuite/src/address/model/picked_location_model.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/address/view/widget/address_form_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_delete_icon.dart';
import 'package:tsuite/utils/common_widgets/common_dialog_box.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_nav_bar_button.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class AddressBookScreen extends ConsumerWidget {
  const AddressBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final loaderState = ref.watch(
      addressNotifierProvider.select((s) => s.loaderState),
    );
    final addresses = ref.watch(
      addressNotifierProvider.select((s) => s.addresses),
    );
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
        LoaderState.loading => const Center(child: CommonLoader()),
        LoaderState.noData => CommonEmptyState(
            title: Strings.noAddressSaved,
            message: Strings.addAddressToContinue,
            buttonText: Strings.addAddress,
            onPressed: () => _openAddFlow(context, ref),
          ),
        LoaderState.loaded => ListView.builder(
            padding: EdgeInsets.all(20.r),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return _AddressTile(
                address: address,
                onEdit: () => _openEditFlow(context, ref, address),
                onDelete: () => CommonDialogBox.show(
                  context: context,
                  title: Strings.deleteAddressTitle,
                  message: Strings.deleteAddressMessage,
                  primaryLabel: Strings.delete,
                  onPrimary: () => notifier.deleteAddress(address.id),
                  secondaryLabel: Strings.cancel,
                ),
                onSetDefault: () => notifier.setDefault(address.id),
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

  Future<void> _openEditFlow(
    BuildContext context,
    WidgetRef ref,
    AddressModel address,
  ) async {
    final notifier = ref.read(addressNotifierProvider.notifier);

    if (address.hasCoordinates) {
      final pick = await Navigator.pushNamed<PickedLocationModel>(
        context,
        RouteConstants.routeLocationPickerScreen,
        arguments: LocationPickerArgs(
          initialLatitude: address.latitude,
          initialLongitude: address.longitude,
        ),
      );
      if (!context.mounted) return;
      notifier.startEdit(address);
      if (pick != null) {
        notifier.applyPickedLocation(pick);
      }
    } else {
      notifier.startEdit(address);
    }

    if (!context.mounted) return;
    await AddressFormSheet.show(
      context: context,
      title: Strings.editAddress,
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonContainer(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      borderRadius: 16.r,
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                MedpikSvgAssets.location,
                width: 22.r,
                height: 22.r,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.label,
                          style: FontPalette.base700(
                            16,
                            color: colors.primaryText,
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
                              style: FontPalette.base600(
                                11,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    8.verticalSpace,
                    Text(
                      address.fullAddress,
                      style: FontPalette.base400(
                        14,
                        color: colors.secondaryText,
                      ),
                    ),
                    if (!address.isDefault) ...[
                      12.verticalSpace,
                      GestureDetector(
                        onTap: onSetDefault,
                        child: Text(
                          Strings.setAsDefault,
                          style: FontPalette.base600(
                            13,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20.r,
                  color: colors.primary,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: CommonDeleteIcon(size: 20.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
