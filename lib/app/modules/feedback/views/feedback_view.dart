// app/modules/feedback/views/feedback_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackView extends StatelessWidget {
  FeedbackView({super.key});

  final TextEditingController feedbackController = TextEditingController();
  final RxInt rating = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How was your experience?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < rating.value ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                    onPressed: () => rating.value = index + 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Feedback',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tell us about your experience...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: ['Service', 'Product', 'Delivery', 'App', 'Other']
                  .map(
                    (category) => FilterChip(
                      label: Text(category),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                  )
                  .toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _submitFeedback(),
                child: const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() {
    if (rating.value == 0) {
      Get.snackbar('Error', 'Please provide a rating');
      return;
    }
    if (feedbackController.text.isEmpty) {
      Get.snackbar('Error', 'Please provide feedback');
      return;
    }

    Get.back();
    Get.snackbar('Thank You!', 'Your feedback has been submitted');
  }
}
