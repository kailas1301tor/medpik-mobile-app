// lib/data/models/address_book_args.dart
class AddressBookArgs {
  const AddressBookArgs({
    this.selectMode = false,
    this.selectedAddressId,
  });

  final bool selectMode;
  final int? selectedAddressId;
}
