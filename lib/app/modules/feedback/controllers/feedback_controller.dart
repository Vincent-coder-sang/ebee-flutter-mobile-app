// app/modules/feedback/controllers/feedback_controller.dart
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  var isLoading = false.obs;
  var feedbackCategories = [
    'Service',
    'Product',
    'Delivery',
    'App',
    'Other',
  ].obs;
  var selectedCategory = 'Service'.obs;
  var rating = 0.obs;

  void submitFeedback({
    required int rating,
    required String category,
    required String message,
    List<String>? attachments,
  }) async {
    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.back();
      Get.snackbar(
        'Thank You!',
        'Your feedback has been submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit feedback: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setRating(int value) {
    rating.value = value;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }
}
