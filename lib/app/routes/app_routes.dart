// app/routes/app_routes.dart
abstract class AppRoutes {
  static const initial = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';

  // Main App
  static const home = '/home';
  static const products = '/products';
  static const productDetail = '/products/:id';
  static const cart = '/cart';

  // Orders
  static const orders = '/orders';
  static const orderDetail = '/orders/:id';

  // Rentals
  static const rentals = '/rentals';
  static const rentalDetail = '/rentals/:id';

  // Services
  static const services = '/services';
  static const serviceDetail = '/services/:id';
  static const bookings = '/bookings';

  // Profile
  static const profile = '/profile';
  static const editProfile = '/profile/edit';

  // Address
  static const addresses = '/addresses';
  static const addAddress = '/add-address';
  static const editAddress = '/edit-address';

  // Payments
  static const payment = '/payment';
  static const checkout = '/checkout';
  static const paymentHistory = '/payment/history';

  // Dispatch
  static const dispatch = '/dispatch';
  static const createDispatch = '/create-dispatch';

  // Reports
  static const reports = '/reports';
  static const createReport = '/reports/create';

  // Service Management
  static const serviceManager = '/service/manager';
  static const technician = '/technician';
  static const driver = '/driver';

  // Feedback & Support
  static const feedback = '/feedback';
  static const help = '/help';
  static const aboutUs = '/about-us';
  static const contactUs = '/contact-us';

  // Search
  static const search = '/search';

  // Business Management
  static const supplier = '/supplier';
  static const inventoryManager = '/inventory';
  static const finance = '/finance';

  // Booking Management
  static const bookingManager = '/bookings/manager';
  static const bookingDetails = '/bookings/:id';
}
