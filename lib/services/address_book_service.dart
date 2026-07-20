// lib/services/address_book_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';

part 'address_book_service.g.dart';

@Riverpod(keepAlive: true)
AddressBookService addressBookService(Ref ref) {
  return AddressBookService(ref);
}

@Riverpod(keepAlive: true)
List<AddressModel> userAddresses(Ref ref) {
  return ref.watch(addressNotifierProvider.select((s) => s.addresses));
}

class AddressBookService {
  const AddressBookService(this._ref);

  final Ref _ref;

  List<AddressModel> get addresses => _ref.read(userAddressesProvider);

  Future<void> fetchAddresses() {
    return _ref.read(addressNotifierProvider.notifier).fetchAddresses();
  }
}
