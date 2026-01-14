// app/utils/constants.dart
class AppConstants {
  static const String appName = 'ebee';
  static const String appSlogan = 'Ride the Electric Future';

  // Storage keys
  static const String tokenKey = 'auth_token'; //for authentication
  static const String userKey =
      'user_data'; // data for profile we can user id from here

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 13;
}

class ApiEndpoints {
  static const String baseUrl = 'https://ebee-admin-kjn8.onrender.com/api';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/signup';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Products - UPDATED
  static const String products = '/products/get';
  static const String createProduct = '/products/create';
  static String updateProduct(String productId) =>
      '/products/update/$productId';
  static String deleteProduct(String productId) =>
      '/products/delete/$productId';
  static String getProduct(String productId) => '/products/get/$productId';
  static String searchProducts(String query) => '/products/search/$query';

  // Users - UPDATED to match your backend routes
  static const String users = '/users';
  static const String getUsers = '/users/get';
  static String getUserById(String userId) => '/users/get/$userId';
  static String updateUser(String userId) => '/users/update/$userId';
  static String deleteUser(String userId) => '/users/delete/$userId';
  static String approveUser(String userId) => '/users/approve/$userId';
  static const String approveUsers = '/users/approve';

  // User profile endpoints (if separate from the above)WWWWWWWWWWW
  static String profile(String userId) =>
      '/users/get/$userId'; // Same as getUserById
  static String updateProfile(String userId) =>
      '/users/update/$userId'; // Same as updateUser
  static String changePassword(String userId) =>
      '/users/change-password/$userId';

  // Cart endpoints - FIX THESE
  static String getCart(String userId) =>
      '/cart/get/$userId'; // Remove baseUrl from here
  static const String addToCart = '/cart/add';
  static String increaseQuantity(String cartItemId) =>
      '/cart/update/$cartItemId/increase';
  static String decreaseQuantity(String cartItemId) =>
      '/cart/update/$cartItemId/decrease';
  static String removeFromCart(String userId, String cartItemId) =>
      '/cart/delete/$userId/$cartItemId';
  static String clearCart(String userId) => '/cart/clear/$userId';

  // Order endpoints
  static const String createOrder = '/orders/create';
  static const String getOrders = '/orders/get';
  static String getOrder(String orderId) => '/orders/get/$orderId';
  static String updateOrder(String orderId) => '/orders/update/$orderId';
  static String deleteOrder(String orderId) => '/orders/delete/$orderId';
  static String myOrders(String userId) => '/orders/user/$userId';

  // Address endpoints
  static const String getAddresses = '/address/get';
  static const String createAddress = '/address/create';
  static String updateAddress(String addressId) => '/address/update/$addressId';
  static String deleteAddress(String addressId) => '/address/delete/$addressId';
  //   static String getUserAddresses(String userId) => '/address/get/$userId';

  // Payment endpoints - UPDATED WITH STATUS ENDPOINTS
  static const String stkPush = '/payment/stkpush';
  static const String paymentHistory = '/payment/history';
  static String approvePayment(String paymentId) =>
      '/payment/update/$paymentId';

  // NEW: Payment status endpoints
  static String paymentStatusByCheckoutId(String checkoutRequestId) =>
      '/payment/status/$checkoutRequestId';
  static String paymentStatusByOrderId(String orderId) =>
      '/payment/status/$orderId';

  // Dispatch endpoints - ADD THESE
  static const String getDispatches = '/dispatch/get';
  static const String createDispatch = '/dispatch/create';
  static String updateDispatch(String dispatchId) =>
      '/dispatch/update/$dispatchId';
  static String deleteDispatch(String dispatchId) =>
      '/dispatch/delete/$dispatchId';

  // Rentals
  static const String rentals = '/rentals';
  static const String createRental = '/rentals/create';
  static const String getRental = '/rentals/get';
  static const String updateRental = '/rentals/update';
  static const String deleteRental = '/rentals/delete';
  static const String myRentals = '/rentals/my-rentals';

  // Services
  static const String services = '/services';
  static const String createService = '/services/create';
  static const String updateService = '/services/update';
  static const String deleteService = '/services/delete';
  static const String getService = '/services/get';
  static const String allServices = '/services/get';

  // Bookings
  static const String bookings = '/bookings';
  static const String createBooking = '/bookings/create';
  static const String getBookings = '/bookings/get';
  static const String updateBooking = '/bookings/update';
  static const String deleteBooking = '/bookings/delete';
  static const String myBookings = '/bookings/my-bookings';

  // Other endpoints
  static const String inventories = '/inventories';
  static const String feedbacks = '/feedbacks';
  static const String dispatches = '/dispatches';
  static const String reports = '/reports';
  static const String fines = '/fines';
}
