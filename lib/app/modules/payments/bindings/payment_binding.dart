// app/modules/payments/bindings/payment_binding.dart
import 'package:get/get.dart';
import '../../../data/repositories/payment_repository.dart';
import '../controllers/payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentRepository>(() => PaymentRepository());
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}
