// app/data/models/order_model.dart
import 'user_model.dart';
import 'address_model.dart';
import 'product_model.dart';

enum OrderStatus { pending, processing, delivered, cancelled }

enum PaymentStatus { pending, paid, cancelled }

class Order {
  final String id;
  final OrderStatus orderStatus;
  final PaymentStatus paymentStatus;
  final double totalPrice;
  final String userAddressId;
  final String cartId;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final UserModel? user;
  final UserAddress? userAddress;
  final List<OrderItem>? orderItems;

  Order({
    required this.id,
    required this.orderStatus,
    required this.paymentStatus,
    required this.totalPrice,
    required this.userAddressId,
    required this.cartId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.userAddress,
    this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      orderStatus: _parseOrderStatus(json['orderStatus']?.toString()),
      paymentStatus: _parsePaymentStatus(json['paymentStatus']?.toString()),
      totalPrice: _parseDouble(json['totalPrice']),
      userAddressId:
          json['userAddressId']?.toString() ??
          json['userAddressId']?.toString() ??
          '',
      cartId: json['cartId']?.toString() ?? json['cartId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? json['userId']?.toString() ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      userAddress: json['userAddress'] != null
          ? UserAddress.fromJson(json['userAddress'])
          : null,
      orderItems: json['orderItems'] != null
          ? (json['orderItems'] as List)
                .map((item) => OrderItem.fromJson(item))
                .toList()
          : null,
    );
  }

  // Safe parsing methods
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static OrderStatus _parseOrderStatus(String? status) {
    if (status == null) return OrderStatus.pending;

    switch (status.toLowerCase()) {
      case 'processing':
        return OrderStatus.processing;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  static PaymentStatus _parsePaymentStatus(String? status) {
    if (status == null) return PaymentStatus.pending;

    switch (status.toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'cancelled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderStatus': orderStatus.toString().split('.').last,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'totalPrice': totalPrice,
      'userAddressId': userAddressId,
      'cartId': cartId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user?.toJson(),
      'userAddress': userAddress?.toJson(),
      'orderItems': orderItems?.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final String id;
  final int quantity;
  final double price;
  final String productId;
  final String orderId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final Product? product;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.productId,
    required this.orderId,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id']?.toString() ?? '',
      quantity: Order._parseInt(json['quantity']),
      price: Order._parseDouble(json['price']),
      productId:
          json['productId']?.toString() ?? json['productId']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? json['orderId']?.toString() ?? '',
      createdAt: Order._parseDateTime(json['createdAt']),
      updatedAt: Order._parseDateTime(json['updatedAt']),
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  double get subtotal => quantity * price;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'productId': productId,
      'orderId': orderId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      // 'product': product?.toJson(),
    };
  }
}
