// app/modules/support/controllers/support_controller.dart
import 'package:get/get.dart';

class SupportController extends GetxController {
  var isLoading = false.obs;
  var faqCategories = [
    {
      'title': 'Getting Started',
      'icon': 'play_arrow',
      'topics': [
        'How to rent an e-bike',
        'How to buy an e-bike',
        'Account setup guide',
        'Payment methods',
      ],
    },
    {
      'title': 'Services',
      'icon': 'build',
      'topics': [
        'Maintenance services',
        'Repair process',
        'Service pricing',
        'Warranty information',
      ],
    },
    {
      'title': 'Technical Issues',
      'icon': 'phone_iphone',
      'topics': [
        'App troubleshooting',
        'Bike connectivity',
        'Battery issues',
        'Software updates',
      ],
    },
  ].obs;

  var contactMethods = [
    {
      'type': 'email',
      'title': 'Email Support',
      'value': 'support@ebee.com',
      'icon': 'email',
    },
    {
      'type': 'phone',
      'title': 'Phone Support',
      'value': '+1 (555) 123-4567',
      'icon': 'phone',
    },
    {
      'type': 'chat',
      'title': 'Live Chat',
      'value': 'Available 24/7',
      'icon': 'chat',
    },
  ].obs;

  void contactSupport(String type, String value) {
    switch (type) {
      case 'email':
        _sendEmail(value);
        break;
      case 'phone':
        _makePhoneCall(value);
        break;
      case 'chat':
        _startLiveChat();
        break;
    }
  }

  void _sendEmail(String email) {
    // Implement email functionality
    Get.snackbar('Email Support', 'Opening email client...');
  }

  void _makePhoneCall(String phone) {
    // Implement phone call functionality
    Get.snackbar('Phone Support', 'Calling $phone...');
  }

  void _startLiveChat() {
    Get.toNamed('/chat-support');
  }

  void submitContactForm({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.back();
      Get.snackbar(
        'Message Sent!',
        'We will get back to you within 24 hours',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
