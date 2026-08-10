// lib/src/address/view/address_book_screen.dart
//
// * Saved addresses list — two modes via [AddressBookArgs].
//
// ? Manage mode (selectMode: false, default):
// ? - App bar + → map picker → form sheet → create address
// ? - Tile edit → form sheet with [AddressNotifier.startEdit]
// ? - Tile delete → confirmation dialog
//
// ? Select mode (selectMode: true):
// ? Used by checkout / prescription checkout. Tap tile → Navigator.pop(address).
// ? Edit/delete actions are hidden.
//
// * Entry points: home header, checkout, prescription checkout.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/data/models/address_book_args.dart';
import 'package:medpik/src/address/model/picked_location_model.dart';
import 'package:medpik/src/address/notifier/address_notifier.dart';
import 'package:medpik/src/address/view/widget/address_book_shimmer_widget.dart';
import 'package:medpik/src/address/view/widget/address_book_tile.dart';
import 'package:medpik/src/address/view/widget/address_form_sheet.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_dialog_box.dart';
import 'package:medpik/utils/common_widgets/common_nav_bar_button.dart';
import 'package:medpik/utils/common_widgets/common_refresh_indicator.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:medpik/utils/routes/route_constants.dart';
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
      body: CommonRefreshIndicator(
        onRefresh: notifier.fetchAddresses,
        child: CommonSwitchState(
          loaderState: loaderState,
          reload: notifier.fetchAddresses,
          loader: const AddressBookShimmerWidget(),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return AddressBookTile(
                address: address,
                isSelectable: args.selectMode,
                isSelected: args.selectedAddressId == address.id,
                onTap: args.selectMode
                    ? () => Navigator.pop(context, address)
                    : null,
                onEdit: args.selectMode
                    ? null
                    : () => _openEditFlow(context, ref, address),
                onDelete: args.selectMode
                    ? null
                    : () => _confirmDelete(context, ref, address),
              );
            },
          ),
        ),
      ),
    );
  }

  // ? Add flow always starts on the map so every new address has coordinates.
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
    ref.read(addressNotifierProvider.notifier).startEdit(address);
    await AddressFormSheet.show(context: context, title: Strings.editAddress);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AddressModel address,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, _) {
          final isDeleting = ref.watch(
            addressNotifierProvider.select((s) => s.isDeletingAddress),
          );

          return CommonDialogBox(
            title: Strings.deleteAddressTitle,
            message: Strings.deleteAddressMessage,
            primaryLabel: Strings.confirm,
            isLoading: isDeleting,
            onPrimaryAsync: () => ref
                .read(addressNotifierProvider.notifier)
                .deleteAddress(address.id),
            secondaryLabel: Strings.cancel,
          );
        },
      ),
    );
  }
}
