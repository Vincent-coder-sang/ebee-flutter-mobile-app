import 'package:ebee/app/data/repositories/address_repository.dart';
import 'package:ebee/app/data/repositories/cart_repository.dart';
import 'package:ebee/app/data/repositories/order_repository.dart';
import 'package:ebee/app/data/repositories/payment_repository.dart';
import 'package:ebee/app/data/repositories/user_repository.dart';
import 'package:ebee/app/data/repositories/dispatch_repository.dart'; // ADD THIS
import 'package:ebee/app/modules/address/controllers/address_controller.dart';
import 'package:ebee/app/modules/cart/controllers/cart_controller.dart';
import 'package:ebee/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:ebee/app/modules/orders/controllers/order_controller.dart';
import 'package:ebee/app/modules/payments/controllers/payment_controller.dart';
import 'package:ebee/app/modules/profile/controllers/profile_controller.dart';
import 'package:ebee/app/modules/dispatch/controllers/dispatch_controller.dart'; // ADD THIS
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/providers/local_storage.dart';
import 'app/data/providers/api_provider.dart';
import 'app/data/repositories/auth_repository.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize LocalStorage first
    await LocalStorage.init();
    print('✅ LocalStorage initialized');

    // Initialize ApiProvider
    final apiProvider = ApiProvider();
    await apiProvider.init();
    Get.put(apiProvider, permanent: true);
    print('✅ ApiProvider initialized');
  } catch (e) {
    print('❌ Error during initialization: $e');
    // Continue anyway - some features might still work
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'eBee - E-Bike Marketplace',
      initialRoute: AppRoutes.initial,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      // Enable GetX logs for debugging
      enableLog: true,
      logWriterCallback: (String text, {bool isError = false}) {
        if (isError) {
          print('❌ $text');
        } else {
          print('📝 $text');
        }
      },
    );
  }
}

// Create a global binding class
class AppBinding extends Bindings {
  @override
  void dependencies() {
    print('🔧 Initializing App Dependencies...');

    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<CartRepository>(() => CartRepository(), fenix: true);
    Get.lazyPut<OrderRepository>(() => OrderRepository(), fenix: true);
    Get.lazyPut<PaymentRepository>(() => PaymentRepository(), fenix: true);
    Get.lazyPut<AddressRepository>(() => AddressRepository(), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
    Get.lazyPut<DispatchRepository>(
      () => DispatchRepository(),
      fenix: true,
    ); // ADD THIS

    // Controllers
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<AddressController>(() => AddressController(), fenix: true);
    Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
    Get.lazyPut<CheckoutController>(() => CheckoutController(), fenix: true);
    Get.lazyPut<PaymentController>(() => PaymentController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<DispatchController>(
      () => DispatchController(),
      fenix: true,
    ); // ADD THIS

    print('✅ All dependencies initialized');
  }
}
