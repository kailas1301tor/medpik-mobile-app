// lib/utils/helpers/razorpay_checkout_options_helper.dart
import 'package:medpik/src/orders/model/order_payment_create_response_model.dart';

Map<String, dynamic> buildRazorpayCheckoutOptions(
  OrderPaymentCheckoutData data,
) {
  final options = <String, dynamic>{
    'key': data.razorpayKey,
    'amount': data.amount,
    'currency': data.currency,
    'order_id': data.razorpayOrderId,
    'name': data.name,
    'description': data.description,
  };

  final prefill = <String, String>{};
  if (data.prefill.name.trim().isNotEmpty) {
    prefill['name'] = data.prefill.name.trim();
  }
  if (data.prefill.contact.trim().isNotEmpty) {
    prefill['contact'] = data.prefill.contact.trim();
  }
  final email = data.prefill.email.trim();
  prefill['email'] = email.isNotEmpty ? email : 'customer@medpik.app';
  if (prefill.isNotEmpty) {
    options['prefill'] = prefill;
  }

  // Restrict checkout to card + UPI only (hides EMI, netbanking, wallet, pay later).
  options['method'] = <String, bool>{
    'card': true,
    'upi': true,
    'netbanking': false,
    'wallet': false,
    'emi': false,
    'paylater': false,
  };

  return options;
}
