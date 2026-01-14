// app/modules/feedback/repositories/feedback_repository.dart
import 'package:ebee/app/data/providers/api_provider.dart' show ApiProvider;
import 'package:get/get.dart';

class FeedbackRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<void> submitFeedback({
    required int rating,
    required String category,
    required String message,
    List<String>? attachments,
  }) async {
    try {
      await _apiProvider.post('/feedback', {
        'rating': rating,
        'category': category,
        'message': message,
        'attachments': attachments ?? [],
      });
    } catch (e) {
      throw 'Failed to submit feedback: $e';
    }
  }

  Future<List<dynamic>> getMyFeedback() async {
    try {
      final response = await _apiProvider.get('/feedback/my');
      return response['data'] ?? [];
    } catch (e) {
      throw 'Failed to load feedback: $e';
    }
  }
}
