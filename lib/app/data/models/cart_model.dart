// app/data/models/cart_model.dart
import 'package:ebee/app/data/models/product_model.dart' show Product;

class Cart {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final List<CartItem>? cartItems;

  Cart({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.cartItems,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      cartItems:
          json['cartitems'] !=
              null // <- lowercase 'i'
          ? (json['cartitems'] as List)
                .map((item) => CartItem.fromJson(item))
                .toList()
          : null,
    );
  }

  double get totalPrice {
    if (cartItems == null) return 0.0;
    return cartItems!.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  int get totalItems {
    if (cartItems == null) return 0;
    return cartItems!.fold(0, (sum, item) => sum + item.quantity);
  }
}

class CartItem {
  final String id;
  final int quantity;
  final String cartId;
  final String productId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final Product? product;

  CartItem({
    required this.id,
    required this.quantity,
    required this.cartId,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString() ?? '',
      quantity: json['quantity'] ?? 1,
      cartId: json['cartId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  double get subtotal => quantity * (product?.price ?? 0);
}
