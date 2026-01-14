// app/data/models/service_model.dart
import 'package:flutter/material.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }

class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Booking>? bookings;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.bookings,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      userId: json['userId']?.toString(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      bookings: (json['bookings'] as List?)
          ?.map((e) => Booking.fromJson(e))
          .toList(),
    );
  }
}

class Booking {
  final String id;
  final String serviceId;
  final String userId;
  final String? assignedTo;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.serviceId,
    required this.userId,
    this.assignedTo,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      serviceId: json['serviceId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      assignedTo: json['assignedTo']?.toString(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

extension BookingUI on Booking {
  Color get statusColor => {
    BookingStatus.pending: Colors.orange,
    BookingStatus.confirmed: Colors.blue,
    BookingStatus.completed: Colors.green,
    BookingStatus.cancelled: Colors.red,
  }[status]!;
}
