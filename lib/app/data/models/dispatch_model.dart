// app/data/models/dispatch_model.dart
import 'package:flutter/material.dart';
import 'package:ebee/app/data/models/order_model.dart';
import 'package:ebee/app/data/models/user_model.dart';

enum DispatchStatus { assigned, in_transit, delivered }

class Dispatch {
  final String id;
  final String driverId;
  final String orderId;
  final DateTime deliveryDate;
  final DispatchStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final Order? order;
  final UserModel? driver;

  Dispatch({
    required this.id,
    required this.driverId,
    required this.orderId,
    required this.deliveryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.order,
    this.driver,
  });

  factory Dispatch.fromJson(Map<String, dynamic> json) {
    return Dispatch(
      id: json['id']?.toString() ?? '',
      driverId: json['driverId']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      deliveryDate: DateTime.parse(
        json['deliveryDate'] ?? DateTime.now().toIso8601String(),
      ),
      status: _parseDispatchStatus(json['status']?.toString()),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
      driver: json['driver'] != null
          ? UserModel.fromJson(json['driver'])
          : null,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static DispatchStatus _parseDispatchStatus(String? status) {
    if (status == null) return DispatchStatus.assigned;

    switch (status.toLowerCase()) {
      case 'in_transit':
        return DispatchStatus.in_transit;
      case 'delivered':
        return DispatchStatus.delivered;
      default:
        return DispatchStatus.assigned;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'orderId': orderId,
      'deliveryDate': deliveryDate.toIso8601String().split('T')[0],
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get statusText {
    switch (status) {
      case DispatchStatus.assigned:
        return 'Assigned';
      case DispatchStatus.in_transit:
        return 'In Transit';
      case DispatchStatus.delivered:
        return 'Delivered';
    }
  }

  Color get statusColor {
    switch (status) {
      case DispatchStatus.assigned:
        return Colors.orange;
      case DispatchStatus.in_transit:
        return Colors.blue;
      case DispatchStatus.delivered:
        return Colors.green;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case DispatchStatus.assigned:
        return Icons.assignment_turned_in;
      case DispatchStatus.in_transit:
        return Icons.directions_bike;
      case DispatchStatus.delivered:
        return Icons.check_circle;
    }
  }
}
