// app/modules/payments/controllers/payment_controller.dart
import 'package:ebee/app/data/models/payment_model.dart';
import 'package:ebee/app/data/repositories/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final PaymentRepository _paymentRepository = Get.find<PaymentRepository>();

  var isLoading = false.obs;
  var paymentHistory = <Payment>[].obs;
  var latestPayment = Rxn<Payment>();

  // Helper method to safely show snackbars
  void _showSafeSnackbar(
    String title,
    String message, {
    Color backgroundColor = Colors.blue,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Use a safer approach without WidgetsBinding
    Future.delayed(Duration(milliseconds: 100), () {
      try {
        if (Get.isSnackbarOpen) {
          Get.back(); // Close any existing snackbar
        }
        Get.snackbar(
          title,
          message,
          backgroundColor: backgroundColor,
          colorText: Colors.white,
          duration: duration,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        print('❌ Error showing snackbar: $e');
      }
    });
  }

  // Initiate M-Pesa STK Push
  Future<Map<String, dynamic>> initiateMpesaPayment({
    required String phone,
    required double amount,
    required String orderId,
  }) async {
    try {
      isLoading.value = true;
      print('💳 Initiating M-Pesa payment for order: $orderId');

      final response = await _paymentRepository.initiateSTKPush(
        phone,
        amount,
        orderId,
      );

      print('✅ Backend STK Push response: $response');

      // Check if STK Push was successfully initiated
      if (response['success'] == true) {
        final paymentData = response['data'];
        final status = paymentData['status'];
        final reference = paymentData['reference'];
        final checkoutRequestId = paymentData['CheckoutRequestID'];

        print('📱 Payment Status: $status');
        print('🔗 Reference: $reference');
        print('🆔 CheckoutRequestID: $checkoutRequestId');

        // Return the response for status tracking
        return {
          'success': true,
          'status': status,
          'reference': reference,
          'checkoutRequestId': checkoutRequestId,
          'message': response['message'] ?? 'STK Push sent to $phone',
        };
      } else {
        print('❌ Payment initiation failed: ${response['message']}');
        return {
          'success': false,
          'message': response['message'] ?? 'Failed to initiate payment',
        };
      }
    } catch (e) {
      print('❌ Payment initiation failed: $e');
      return {
        'success': false,
        'message': 'Payment initiation failed: ${e.toString()}',
      };
    } finally {
      isLoading.value = false;
    }
  }

  // Check payment status periodically by checkoutRequestId
  Future<bool> checkPaymentStatus(
    String checkoutRequestId, {
    int maxAttempts = 30,
  }) async {
    print('🔄 Starting payment status check for checkout: $checkoutRequestId');

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        print('📡 Checking payment status (attempt $attempt/$maxAttempts)');

        // Check payment status from backend using checkoutRequestId
        final payment = await _paymentRepository.checkPaymentByCheckoutId(
          checkoutRequestId,
        );

        if (payment != null) {
          print('📊 Payment details:');
          print('   - Status: ${payment.status}');
          print('   - Approved: ${payment.isApproved}');
          print('   - M-Pesa Receipt: ${payment.mpesaReceiptNumber}');
          print('   - Reference: ${payment.reference}');

          // Check if payment is successful
          bool isSuccessful =
              payment.status?.toLowerCase() == 'paid' ||
              payment.status?.toLowerCase() == 'success' ||
              payment.mpesaReceiptNumber != null;

          if (isSuccessful) {
            print('✅ Payment confirmed!');
            latestPayment.value = payment;

            // Show success message safely
            _showSafeSnackbar(
              'Payment Successful',
              'Your payment has been confirmed',
              backgroundColor: Colors.green,
            );

            return true;
          }

          // Check if payment failed or was cancelled
          if (payment.status?.toLowerCase() == 'failed' ||
              payment.status?.toLowerCase() == 'cancelled') {
            print('❌ Payment failed or cancelled');

            _showSafeSnackbar(
              'Payment Failed',
              'Payment was not completed',
              backgroundColor: Colors.red,
            );

            return false;
          }

          // Payment is still pending/queued
          print('⏳ Payment still pending... Current status: ${payment.status}');
        } else {
          print('⏳ Payment record not found yet...');
        }

        // Wait 3 seconds before next check
        if (attempt < maxAttempts) {
          await Future.delayed(Duration(seconds: 3));
        }
      } catch (e) {
        print('❌ Error checking payment status: $e');
        // Continue polling even if there's an error
        if (attempt < maxAttempts) {
          await Future.delayed(Duration(seconds: 3));
        }
      }
    }

    print('⏰ Payment status check timeout after $maxAttempts attempts');

    _showSafeSnackbar(
      'Payment Timeout',
      'Payment confirmation is taking longer than expected. Please check your M-Pesa messages.',
      backgroundColor: Colors.orange,
      duration: Duration(seconds: 5),
    );

    return false;
  }

  // Get payment history
  Future<void> getPaymentHistory() async {
    try {
      isLoading.value = true;
      final payments = await _paymentRepository.getPaymentHistory();
      paymentHistory.assignAll(payments);
    } catch (e) {
      print('❌ Error fetching payment history: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
