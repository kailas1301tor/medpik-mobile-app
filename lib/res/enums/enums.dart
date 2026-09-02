enum LoaderState {
  loaded,
  loading,
  error,
  networkError,
  noData,
  serverError,
  noSearchData,
}

enum UserAccountStatus {
  active,
  suspended,
}

enum AuthOtpFlow {
  login,
  deleteAccount,
}

enum OrderStatus {
  prescriptionUploaded,
  underReview,
  prescriptionAccepted,
  prescriptionRejected,
  billGenerated,
  awaitingBillApproval,
  billAccepted,
  billRejected,
  paymentPending,
  paymentCompleted,
  cashOnDelivery,
  orderConfirmed,
  preparingOrder,
  packed,
  deliveryPartnerAssigned,
  outForDelivery,
  delivered,
  cancelled,
}

enum OrderStatusTone {
  warning,
  info,
  success,
  error,
  neutral,
}

enum OrderPaymentMethod {
  online,
  cashOnDelivery,
}

enum OrderStepperNodeState {
  completed,
  current,
  pending,
  failed,
}

enum OrderDetailCtaAction {
  none,
  reviewBill,
  reviewPay,
  trackOrder,
  uploadPrescription,
}

enum OrderStatusBannerType {
  none,
  delivery,
  rejection,
  billGenerated,
  billReview,
  billAccepted,
  securePayment,
}

enum NotificationType {
  order,
  prescription,
  offer,
  system,
}

enum OrderSubmissionSource {
  medicineCart,
  prescription,
}
