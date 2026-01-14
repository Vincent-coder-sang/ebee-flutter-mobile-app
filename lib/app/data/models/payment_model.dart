// app/data/models/payment_model.dart
class Payment {
  final String id;
  final double? amount;
  final String? phoneNumber;
  final String? status;
  final bool isApproved;
  final String? reference;
  final String? checkoutRequestId;
  final String? mpesaReceiptNumber;
  final String userId;
  final String? orderId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    this.amount,
    this.phoneNumber,
    this.status,
    required this.isApproved,
    this.reference,
    this.checkoutRequestId,
    this.mpesaReceiptNumber,
    required this.userId,
    this.orderId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    // Safe amount parsing
    double? parseAmount(dynamic amountValue) {
      if (amountValue == null) return null;
      if (amountValue is num) return amountValue.toDouble();
      if (amountValue is String) {
        return double.tryParse(amountValue);
      }
      return null;
    }

    // Safe date parsing
    DateTime parseDate(dynamic dateValue) {
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) {
        return DateTime.tryParse(dateValue) ?? DateTime.now();
      }
      return DateTime.now();
    }

    // Safe boolean parsing
    bool parseBool(dynamic boolValue) {
      if (boolValue is bool) return boolValue;
      if (boolValue is num) return boolValue == 1;
      if (boolValue is String) {
        return boolValue.toLowerCase() == 'true' || boolValue == '1';
      }
      return false;
    }

    return Payment(
      id: json['id']?.toString() ?? '',
      amount: parseAmount(json['amount']),
      phoneNumber: json['phoneNumber']?.toString(),
      status: json['status']?.toString(),
      isApproved: parseBool(json['isApproved']),
      reference: json['reference']?.toString(),
      checkoutRequestId: json['checkoutRequestId']?.toString(),
      mpesaReceiptNumber: json['mpesaReceiptNumber']?.toString(),
      userId: json['userId']?.toString() ?? '',
      orderId: json['orderId']?.toString(),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  bool get isMpesaPayment => mpesaReceiptNumber != null;

  bool get isPaid =>
      status?.toLowerCase() == 'paid' ||
      status?.toLowerCase() == 'success' ||
      mpesaReceiptNumber != null;
}
