// app/modules/support/repositories/support_repository.dart
import 'package:ebee/app/data/providers/api_provider.dart' show ApiProvider;
import 'package:get/get.dart';

class SupportRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<dynamic>> getFAQCategories() async {
    try {
      final response = await _apiProvider.get('/support/faq-categories');
      return response['data'] ?? [];
    } catch (e) {
      throw 'Failed to load FAQ categories: $e';
    }
  }

  Future<List<dynamic>> getFAQTopics(String category) async {
    try {
      final response = await _apiProvider.get('/support/faq/$category');
      return response['data'] ?? [];
    } catch (e) {
      throw 'Failed to load FAQ topics: $e';
    }
  }

  Future<void> submitContactForm({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      await _apiProvider.post('/support/contact', {
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
      });
    } catch (e) {
      throw 'Failed to submit contact form: $e';
    }
  }

  Future<void> startLiveChat() async {
    try {
      final response = await _apiProvider.post('/support/live-chat/start', {});
      // Handle live chat initialization
    } catch (e) {
      throw 'Failed to start live chat: $e';
    }
  }
}
