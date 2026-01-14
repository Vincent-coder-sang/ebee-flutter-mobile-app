// app/modules/feedback/bindings/feedback_binding.dart
import 'package:get/get.dart';

import '../controllers/feedback_controller.dart';
import '../../../data/repositories/feedback_repository.dart';

class FeedbackBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackRepository>(() => FeedbackRepository());
    Get.lazyPut<FeedbackController>(() => FeedbackController());
  }
}
