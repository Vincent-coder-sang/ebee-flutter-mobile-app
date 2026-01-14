// app/data/repositories/order_repository.dart
import 'package:ebee/app/utils/constants.dart';
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/order_model.dart';
import '../providers/local_storage.dart'; // Add this import

class OrderRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Try alternative endpoints for getting user orders
  Future<List<Order>> _tryAlternativeEndpoints() async {
    try {
      final userId = await _getCurrentUserId();
      print('🔄 Trying alternative endpoints for user: $userId');

      // Common patterns for user orders endpoints
      final endpoints = [
        '/users/$userId/orders', // Pattern 1
        '/orders?userId=$userId', // Pattern 2
        '/orders/user/$userId/orders', // Pattern 3
      ];

      for (final endpoint in endpoints) {
        try {
          print('🔄 Trying endpoint: $endpoint');
          final response = await _apiProvider.get(endpoint);
          final orders = (response['data'] as List)
              .map((orderJson) => Order.fromJson(orderJson))
              .toList();
          print(
            '✅ Success with endpoint: $endpoint - Found ${orders.length} orders',
          );
          return orders;
        } catch (e) {
          print('❌ Endpoint $endpoint failed: $e');
          continue;
        }
      }

      throw Exception('All order endpoints failed');
    } catch (e) {
      print('❌ All alternative endpoints failed: $e');
      rethrow;
    }
  }

  Future<Order> getOrderById(String orderId) async {
    try {
      print('🔄 OrderRepository.getOrderById() called for: $orderId');
      final response = await _apiProvider.get(ApiEndpoints.getOrder(orderId));
      return Order.fromJson(response['data']);
    } catch (e) {
      print('❌ OrderRepository.getOrderById() error: $e');
      rethrow;
    }
  }

  // Create order from cart
  Future<Order> createOrderFromCart({
    required String cartId,
    required String userAddressId,
  }) async {
    try {
      print('🛒 Creating order from cart: $cartId');
      final response = await _apiProvider.post(ApiEndpoints.createOrder, {
        'cartId': cartId,
        'userAddressId': userAddressId,
      });

      print('✅ Order created successfully');
      return Order.fromJson(response['order'] ?? response['data']);
    } catch (e) {
      print('❌ Error creating order: $e');
      rethrow;
    }
  }

  // Helper method to prepare payment details
  Map<String, dynamic> _preparePaymentDetails({
    required String paymentMethod,
    Map<String, dynamic>? customDetails,
  }) {
    final details = customDetails ?? {};

    switch (paymentMethod.toLowerCase()) {
      case 'mpesa':
        return {
          'type': 'mpesa_till',
          'tillNumber': details['tillNumber'] ?? '000000',
          'phoneNumber': details['phoneNumber'],
          'amount': details['amount'],
          'transactionReference':
              details['transactionReference'] ?? _generateTransactionRef(),
          'timestamp': DateTime.now().toIso8601String(),
          ...details,
        };

      case 'card':
        return {
          'type': 'card',
          'cardLastFour': details['cardLastFour'],
          'cardType': details['cardType'] ?? 'visa',
          'paymentGateway': details['paymentGateway'] ?? 'stripe',
          'transactionId': details['transactionId'],
          ...details,
        };

      case 'cash_on_delivery':
      case 'cod':
        return {
          'type': 'cash_on_delivery',
          'amount': details['amount'],
          'paymentOnDelivery': true,
          ...details,
        };

      default:
        return {
          'type': paymentMethod,
          'timestamp': DateTime.now().toIso8601String(),
          ...details,
        };
    }
  }

  String _generateTransactionRef() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch % 10000;
    return 'EBEE${timestamp}${random.toString().padLeft(4, '0')}';
  }

  // Update order - matches your /orders/update/:orderId route
  Future<Order> updateOrder(
    String orderId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiProvider.put(
        ApiEndpoints.updateOrder(orderId),
        updates,
      );
      return Order.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Delete order - matches your /orders/delete/:orderId route
  Future<void> deleteOrder(String orderId) async {
    try {
      await _apiProvider.delete(ApiEndpoints.deleteOrder(orderId));
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to get current user ID
  Future<String> _getCurrentUserId() async {
    try {
      // Use LocalStorage to get user ID
      final userId = LocalStorage.getUserId();
      print("🔍 User ID from LocalStorage: $userId");

      if (userId == null) {
        throw Exception('User ID not found in local storage');
      }
      return userId;
    } catch (e) {
      print('❌ Error getting user ID: $e');
      rethrow;
    }
  }

  // ADD THIS METHOD for OrderController (if needed)
  Future<List<Order>> getOrders() async {
    try {
      print('🔄 OrderRepository.getOrders() called (all orders)');
      final response = await _apiProvider.get(ApiEndpoints.getOrders);
      final orders = (response['data'] as List)
          .map((orderJson) => Order.fromJson(orderJson))
          .toList();
      print('📦 Parsed ${orders.length} orders');
      return orders;
    } catch (e) {
      print('❌ OrderRepository.getOrders() error: $e');
      rethrow;
    }
  }

  Future<List<Order>> getMyOrders() async {
    try {
      final userId = LocalStorage.getUserId();
      if (userId == null) throw Exception('User ID not available');

      // Use the correct endpoint identified from testing
      final response = await _apiProvider.get('/orders/user/$userId');

      // Use the correct data extraction based on your API response
      List<dynamic> ordersData;
      if (response.containsKey('data')) {
        ordersData = response['data'];
      } else if (response.containsKey('orders')) {
        ordersData = response['orders'];
      } else {
        ordersData = response is List ? response : [];
      }

      return ordersData.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error fetching orders: $e');
      rethrow;
    }
  }

  // Add this to your OrderRepository temporarily
  Future<void> testOrderEndpoints() async {
    try {
      final userId = await _getCurrentUserId();
      print('\n🔍 TESTING ORDER ENDPOINTS FOR USER: $userId');

      final testEndpoints = [
        '/orders/get/$userId',
        '/orders/user/$userId',
        '/users/$userId/orders',
        '/orders?userId=$userId',
        '/orders/my-orders',
        '/orders',
      ];

      for (final endpoint in testEndpoints) {
        try {
          print('🔄 Testing: $endpoint');
          final response = await _apiProvider.get(endpoint);
          print('✅ $endpoint - SUCCESS: ${response['data'] != null}');
          if (response['data'] is List) {
            print('   📦 Found ${(response['data'] as List).length} orders');
          }
        } catch (e) {
          print('❌ $endpoint - FAILED: $e');
        }
      }
      print('🔍 ENDPOINT TESTING COMPLETE\n');
    } catch (e) {
      print('❌ Error testing endpoints: $e');
    }
  }
}
