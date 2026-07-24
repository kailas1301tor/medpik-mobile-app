// lib/utils/helpers/order_payment_request_helper.dart

abstract final class OrderPaymentMethods {
  static const String razorpay = 'Razorpay';
  static const String cod = 'COD';
}

abstract final class OrderPaymentStatuses {
  static const String success = 'Success';
  static const String failed = 'Failed';
  static const String pending = 'Pending';
}

Map<String, dynamic> buildPaymentInitBody({required int orderId}) => {
      'order_id': orderId,
      'payment_method': OrderPaymentMethods.razorpay,
    };

Map<String, dynamic> buildCodPaymentBody({required int orderId}) => {
      'order_id': orderId,
      'payment_method': OrderPaymentMethods.cod,
      'payment_status': OrderPaymentStatuses.pending,
    };

Map<String, dynamic> buildRazorpaySuccessPaymentBody({
  required int orderId,
  required String razorpayOrderId,
  required String razorpayPaymentId,
  required String razorpaySignature,
  Map<String, dynamic> paymentResponseData = const {},
}) =>
    {
      'order_id': orderId,
      'payment_method': OrderPaymentMethods.razorpay,
      'payment_status': OrderPaymentStatuses.success,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature': razorpaySignature,
      'payment_response_data': paymentResponseData,
    };

Map<String, dynamic> buildRazorpayFailedPaymentBody({
  required int orderId,
  required String razorpayOrderId,
  Map<String, dynamic> paymentResponseData = const {},
}) =>
    {
      'order_id': orderId,
      'payment_method': OrderPaymentMethods.razorpay,
      'payment_status': OrderPaymentStatuses.failed,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': '',
      'razorpay_signature': '',
      'payment_response_data': paymentResponseData,
    };
