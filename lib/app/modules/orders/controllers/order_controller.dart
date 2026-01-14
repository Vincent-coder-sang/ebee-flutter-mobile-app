// app/modules/orders/controllers/order_controller.dart
import 'package:get/get.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../data/models/order_model.dart';

class OrderController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();

  var isLoading = false.obs;
  var orders = <Order>[].obs;
  var selectedOrder = Rxn<Order>();

  @override
  void onInit() {
    super.onInit();
    getMyOrders(); // Load user's orders by default
  }

  // Get specific order
  Future<void> getOrderById(String orderId) async {
    try {
      isLoading.value = true;
      final Order order = await _orderRepository.getOrderById(orderId);
      selectedOrder.value = order;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get user's orders
  Future<void> getMyOrders() async {
    try {
      isLoading.value = true;
      final List<Order> myOrders = await _orderRepository.getMyOrders();
      orders.assignAll(myOrders);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load your orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // In OrderController, make sure you're using the correct method name
  Future<void> getOrders() async {
    try {
      isLoading.value = true;
      final List<Order> orderList = await _orderRepository
          .getOrders(); // This should work now
      orders.assignAll(orderList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Create order from cart - FIXED: Updated parameters to match repository
  Future<void> createOrderFromCart({
    required String cartId,
    required String userAddressId,
    String paymentMethod = 'card',
    Map<String, dynamic>? paymentDetails,
  }) async {
    try {
      isLoading.value = true;
      final Order order = await _orderRepository.createOrderFromCart(
        cartId: cartId,
        userAddressId: userAddressId,
      );
      orders.insert(0, order); // Add new order to the top
      Get.snackbar('Success', 'Order created successfully');
      Get.offAllNamed('/orders');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update order
  Future<void> updateOrder(String orderId, Map<String, dynamic> updates) async {
    try {
      isLoading.value = true;
      final updatedOrder = await _orderRepository.updateOrder(orderId, updates);

      // Update the order in the list
      final index = orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        orders[index] = updatedOrder;
      }

      // Update selected order if it's the same one
      if (selectedOrder.value?.id == orderId) {
        selectedOrder.value = updatedOrder;
      }

      Get.snackbar('Success', 'Order updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete order
  Future<void> deleteOrder(String orderId) async {
    try {
      isLoading.value = true;
      await _orderRepository.deleteOrder(orderId);
      orders.removeWhere((order) => order.id == orderId);
      Get.snackbar('Success', 'Order deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter orders by status
  List<Order> get pendingOrders =>
      orders.where((o) => o.orderStatus == OrderStatus.pending).toList();

  List<Order> get processingOrders =>
      orders.where((o) => o.orderStatus == OrderStatus.processing).toList();

  List<Order> get deliveredOrders =>
      orders.where((o) => o.orderStatus == OrderStatus.delivered).toList();

  List<Order> get cancelledOrders =>
      orders.where((o) => o.orderStatus == OrderStatus.cancelled).toList();

  // Get orders by payment status
  List<Order> get paidOrders =>
      orders.where((o) => o.paymentStatus == PaymentStatus.paid).toList();

  List<Order> get pendingPaymentOrders =>
      orders.where((o) => o.paymentStatus == PaymentStatus.pending).toList();

  // Refresh orders
  Future<void> refreshOrders() async {
    await getMyOrders();
  }

  // Clear selected order
  void clearSelectedOrder() {
    selectedOrder.value = null;
  }
}
