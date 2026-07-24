// lib/utils/helpers/address_resolution_helper.dart
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/constants/string_constants.dart';

AddressModel? resolveDefaultAddress(List<AddressModel> addresses) {
  for (final address in addresses) {
    if (address.isDefault) return address;
  }
  return addresses.isNotEmpty ? addresses.first : null;
}

AddressModel? resolveSelectedAddress(
  List<AddressModel> addresses, {
  AddressModel? current,
}) {
  final selectedId = current?.id;
  if (selectedId != null) {
    for (final address in addresses) {
      if (address.id == selectedId) return address;
    }
  }
  return resolveDefaultAddress(addresses);
}

String deliveryHintFromAddresses(List<AddressModel> addresses) {
  final selected = resolveDefaultAddress(addresses);
  return selected?.deliveryHint ?? Strings.selectDeliveryAddress;
}
