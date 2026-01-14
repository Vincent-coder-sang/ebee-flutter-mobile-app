// app/data/repositories/payment_repository.dart
import 'package:ebee/app/data/models/payment_model.dart';
import 'package:ebee/app/data/providers/api_provider.dart';
import 'package:ebee/app/utils/constants.dart';
import 'package:get/get.dart';

class PaymentRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<Map<String, dynamic>> initiateSTKPush(
    String phone,
    double amount,
    String orderId,
  ) async {
    try {
      print('📱 Initiating STK Push for order: $orderId');

      final response = await _apiProvider.post(ApiEndpoints.stkPush, {
        'phone': phone,
        'amount': amount,
        'orderId': orderId,
      });

      print("📥 payment response: $response");
      return response;
    } catch (e) {
      print('❌ STK Push repository error: $e');
      rethrow;
    }
  }

  // Check payment status by checkoutRequestId
  Future<Payment?> checkPaymentByCheckoutId(String checkoutRequestId) async {
    try {
      final response = await _apiProvider.get(
        ApiEndpoints.paymentStatusByCheckoutId(checkoutRequestId),
      );

      print('📊 Payment status response: $response');

      if (response['success'] == true && response['data'] != null) {
        final paymentData = response['data'];

        // Debug the data types
        print('🔍 Raw payment data types:');
        paymentData.forEach((key, value) {
          print('   - $key: $value (type: ${value.runtimeType})');
        });

        try {
          return Payment.fromJson(paymentData);
        } catch (e) {
          print('❌ Error parsing payment data: $e');
          print('❌ Payment data that caused error: $paymentData');
          return null;
        }
      }
      return null;
    } catch (e) {
      print('❌ Payment checkout ID check error: $e');
      return null;
    }
  }

  // Check payment status by orderId
  Future<Payment?> checkPaymentByOrderId(String orderId) async {
    try {
      final response = await _apiProvider.get(
        ApiEndpoints.paymentStatusByOrderId(orderId),
      );

      if (response['success'] == true && response['data'] != null) {
        return Payment.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('❌ Payment order ID check error: $e');
      return null;
    }
  }

  Future<List<Payment>> getPaymentHistory() async {
    final response = await _apiProvider.get(ApiEndpoints.paymentHistory);
    final List payments = response['payments'] ?? response['data'] ?? [];
    return payments.map((payment) => Payment.fromJson(payment)).toList();
  }

  Future<void> approvePayment(String paymentId, bool isApproved) async {
    await _apiProvider.put('${ApiEndpoints.approvePayment}/$paymentId', {
      'isApproved': isApproved,
    });
  }
}
