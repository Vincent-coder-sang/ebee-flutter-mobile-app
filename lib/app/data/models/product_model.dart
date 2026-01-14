import 'package:flutter/material.dart';

enum ProductCategory { bike, sparePart, accessory, helmet, service }

extension ProductCategoryExtension on ProductCategory {
  String get value {
    switch (this) {
      case ProductCategory.bike:
        return 'bike';
      case ProductCategory.sparePart:
        return 'spare-part';
      case ProductCategory.accessory:
        return 'accessory';
      case ProductCategory.helmet:
        return 'helmet';
      case ProductCategory.service:
        return 'service';
    }
  }

  String get categoryDisplayName {
    switch (this) {
      case ProductCategory.bike:
        return 'E-Bike';
      case ProductCategory.sparePart:
        return 'Spare Part';
      case ProductCategory.accessory:
        return 'Accessory';
      case ProductCategory.helmet:
        return 'Helmet';
      case ProductCategory.service:
        return 'Service';
    }
  }

  String get categoryIcon {
    switch (this) {
      case ProductCategory.bike:
        return '🚲';
      case ProductCategory.sparePart:
        return '🔧';
      case ProductCategory.accessory:
        return '🎒';
      case ProductCategory.helmet:
        return '⛑️';
      case ProductCategory.service:
        return '🔧';
    }
  }

  Color get categoryColor {
    switch (this) {
      case ProductCategory.bike:
        return Colors.green;
      case ProductCategory.sparePart:
        return Colors.orange;
      case ProductCategory.accessory:
        return Colors.blue;
      case ProductCategory.helmet:
        return Colors.red;
      case ProductCategory.service:
        return Colors.purple;
    }
  }

  static ProductCategory fromString(String value) {
    switch (value) {
      case 'spare-part':
        return ProductCategory.sparePart;
      case 'accessory':
        return ProductCategory.accessory;
      case 'helmet':
        return ProductCategory.helmet;
      case 'service':
        return ProductCategory.service;
      default:
        return ProductCategory.bike;
    }
  }
}

class Product {
  final String id;
  final String imageUrl;
  final String cloudinaryId;
  final String name;
  final String description;
  final double price;
  final ProductCategory category;
  final int stockQuantity;
  final String? supplierId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.imageUrl,
    required this.cloudinaryId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stockQuantity,
    this.supplierId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle price conversion - it might be String or num
    double parsePrice(dynamic price) {
      if (price == null) return 0.0;
      if (price is num) return price.toDouble();
      if (price is String) {
        // Remove any currency symbols and parse
        final cleanPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
        return double.tryParse(cleanPrice) ?? 0.0;
      }
      return 0.0;
    }

    // Handle stock quantity conversion
    int parseStock(dynamic stock) {
      if (stock == null) return 0;
      if (stock is num) return stock.toInt();
      if (stock is String) return int.tryParse(stock) ?? 0;
      return 0;
    }

    // Handle date parsing safely
    DateTime parseDate(dynamic date) {
      if (date == null) return DateTime.now();
      if (date is DateTime) return date;
      if (date is String) {
        try {
          return DateTime.parse(date);
        } catch (e) {
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    return Product(
      id: json['id']?.toString() ?? '',
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      cloudinaryId: json['cloudinaryId'] ?? json['imageId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: parsePrice(json['price']),
      category: ProductCategoryExtension.fromString(json['category'] ?? 'bike'),
      stockQuantity: parseStock(json['stockQuantity'] ?? json['stock']),
      supplierId: json['supplierId']?.toString(),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  // Helper methods
  String get formattedPrice => 'KES ${price.toStringAsFixed(2)}';

  bool get inStock => stockQuantity > 0;

  bool get isRentable => category == ProductCategory.bike;

  bool get isService => category == ProductCategory.service;

  bool get isAccessory => category == ProductCategory.accessory;

  bool get isSparePart => category == ProductCategory.sparePart;

  bool get isHelmet => category == ProductCategory.helmet;

  // You can now remove these from Product class since they're in the extension:
  // String get categoryDisplayName => category.categoryDisplayName;
  // String get categoryIcon => category.categoryIcon;
  // Color get categoryColor => category.categoryColor;

  // Check if product is on sale (you can add salePrice field later)
  bool get isOnSale => false; // You can implement this later

  // Get discount percentage (you can add originalPrice field later)
  double get discountPercentage => 0.0; // You can implement this later

  // Get formatted stock status
  String get stockStatus {
    if (stockQuantity > 10) return 'In Stock';
    if (stockQuantity > 0) return 'Low Stock';
    return 'Out of Stock';
  }

  Color get stockStatusColor {
    if (stockQuantity > 10) return Colors.green;
    if (stockQuantity > 0) return Colors.orange;
    return Colors.red;
  }
}
