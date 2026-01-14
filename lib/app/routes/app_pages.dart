// app/routes/app_pages.dart
import 'package:ebee/app/modules/address/bindings/address_binding.dart';
import 'package:ebee/app/modules/address/views/add_address_view.dart';
import 'package:ebee/app/modules/address/views/address_list_view.dart';
import 'package:ebee/app/modules/cart/bindings/cart_binding.dart';
import 'package:ebee/app/modules/cart/views/cart_view.dart';
import 'package:ebee/app/modules/checkout/bindings/checkout_binding.dart';
import 'package:ebee/app/modules/checkout/views/checkout_view.dart';
import 'package:ebee/app/modules/dispatch/bindings/dispatch_binding.dart';
import 'package:ebee/app/modules/dispatch/views/create_dispatch_view.dart';
import 'package:ebee/app/modules/orders/bindings/order_binding.dart';
import 'package:ebee/app/modules/orders/views/order_success_view.dart';
import 'package:ebee/app/modules/orders/views/orders_view.dart';
import 'package:ebee/app/modules/payments/bindings/payment_binding.dart';
import 'package:ebee/app/modules/payments/views/payment_view.dart';
import 'package:ebee/app/modules/products/bindings/products_binding.dart';
import 'package:ebee/app/modules/products/views/products_view.dart';
import 'package:ebee/app/modules/profile/bindings/profile_binding.dart';
import 'package:ebee/app/modules/profile/views/profile_view.dart';
import 'package:ebee/app/modules/service_management/views/dispatch_view.dart';
import 'package:ebee/app/modules/splash/bindings/splash_binding.dart';
import 'package:ebee/app/routes/app_routes.dart';
import 'package:get/get.dart';

// Auth
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/bindings/auth_binding.dart';

// Home
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';

// Splash
import '../modules/splash/views/splash_view.dart';

class AppPages {
  static const initial = AppRoutes.initial;

  static final routes = [
    // Splash Screen
    GetPage(
      name: AppRoutes.initial,
      page: () => SplashView(),
      binding: SplashBinding(), // This pre-loads all dependencies
    ),

    // Auth Routes
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordView(),
      binding: AuthBinding(),
    ),

    // HOME
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),

    // Products Routes
    GetPage(
      name: AppRoutes.products,
      page: () => ProductsView(),
      binding: ProductsBinding(), // Add this binding
    ),
    // GetPage(
    //   name: AppRoutes.productDetail,
    //   page: () => ProductDetailView(),
    //   binding: ProductBinding(),
    // ),

    // Cart Routes
    GetPage(
      name: AppRoutes.cart,
      page: () => CartView(),
      binding: CartBinding(),
    ),

    // Orders Routes
    GetPage(
      name: AppRoutes.orders,
      page: () => OrdersView(),
      binding: OrderBinding(),
    ),

    // Dispatch Routes
    GetPage(
      name: AppRoutes.dispatch,
      page: () => DispatchView(),
      binding: DispatchBinding(),
    ),
    GetPage(
      name: AppRoutes.createDispatch,
      page: () => CreateDispatchView(),
      binding: DispatchBinding(),
    ),

    // In your app_pages.dart, add these routes:
    GetPage(
      name: '/addresses',
      page: () => AddressListView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: '/add-address',
      page: () => AddAddressView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: '/edit-address',
      page: () => AddAddressView(address: Get.arguments),
      binding: AddressBinding(),
    ),

    GetPage(
      name: '/order-success',
      page: () => OrderSuccessView(
        orderId: Get.arguments['orderId'],
        amount: Get.arguments['amount'],
        phoneNumber: Get.arguments['phoneNumber'],
      ),
    ),

    // Dispatch Routes
    GetPage(
      name: AppRoutes.dispatch,
      page: () => DispatchView(),
      binding: DispatchBinding(),
    ),
    GetPage(
      name: AppRoutes.createDispatch,
      page: () => CreateDispatchView(),
      binding: DispatchBinding(),
    ),

    // GetPage(
    //   name: AppRoutes.orderDetail,
    //   page: () => OrderDetailView(),
    //   binding: OrderBinding(),
    // ),

    // // Rentals Routes
    // GetPage(
    //   name: AppRoutes.rentals,
    //   page: () => RentalsView(),
    //   binding: RentalBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.rentalDetail,
    //   page: () => RentalDetailView(),
    //   binding: RentalBinding(),
    // ),

    // // Services Routes
    // GetPage(
    //   name: AppRoutes.services,
    //   page: () => ServicesView(),
    //   binding: ServiceBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.serviceDetail,
    //   page: () => ServiceDetailView(),
    //   binding: ServiceBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.bookings,
    //   page: () => BookingsView(),
    //   binding: ServiceBinding(),
    // ),

    // Profile Routes
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.editProfile,
    //   page: () => EditProfileView(),
    //   binding: ProfileBinding(),
    // ),

    // app/routes/app_pages.dart - Update the address section

    // GetPage(
    //   name: AppRoutes.editAddress,
    //   page: () => AddAddressView(),
    //   binding: AddressBinding(),
    // ),
    GetPage(
      name: '/checkout',
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: '/payment',
      page: () => PaymentView(
        orderId: Get.arguments['orderId'],
        amount: Get.arguments['amount'],
      ),
      binding: PaymentBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.paymentHistory,
    //   page: () => PaymentHistoryView(),
    //   binding: PaymentBinding(),
    // ),

    // // Reports Routes
    // GetPage(
    //   name: AppRoutes.reports,
    //   page: () => ReportsView(),
    //   binding: ReportBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.createReport,
    //   page: () => CreateReportView(),
    //   binding: ReportBinding(),
    // ),

    // // Service Management
    // GetPage(
    //   name: AppRoutes.serviceManager,
    //   page: () => ServiceManagerView(),
    //   binding: ServiceManagementBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.dispatch,
    //   page: () => DispatchView(),
    //   binding: ServiceManagementBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.technician,
    //   page: () => TechnicianView(),
    //   binding: ServiceManagementBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.driver,
    //   page: () => DriverView(),
    //   binding: ServiceManagementBinding(),
    // ),

    // // Feedback & Support
    // GetPage(
    //   name: AppRoutes.feedback,
    //   page: () => FeedbackView(),
    //   binding: FeedbackBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.help,
    //   page: () => HelpView(),
    //   binding: SupportBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.aboutUs,
    //   page: () => AboutUsView(),
    //   binding: SupportBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.contactUs,
    //   page: () => ContactUsView(),
    //   binding: SupportBinding(),
    // ),

    // // Search
    // GetPage(
    //   name: AppRoutes.search,
    //   page: () => SearchView(),
    //   binding: SearchBinding(),
    // ),

    // // Business Management
    // GetPage(
    //   name: AppRoutes.supplier,
    //   page: () => SupplierView(),
    //   binding: BusinessBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.inventoryManager,
    //   page: () => InventoryManagerView(),
    //   binding: BusinessBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.finance,
    //   page: () => FinanceView(),
    //   binding: BusinessBinding(),
    // ),

    // // Booking Management
    // GetPage(
    //   name: AppRoutes.bookingManager,
    //   page: () => BookingManagerView(),
    //   binding: BookingBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.bookingDetails,
    //   page: () => BookingDetailView(),
    //   binding: BookingBinding(),
    // ),
  ];
}
