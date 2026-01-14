// app/middlewares/auth_middleware.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../modules/auth/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();

    // If user is not logged in and trying to access protected routes
    if (!authController.isLoggedIn.value && _isProtectedRoute(route)) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }

  bool _isProtectedRoute(String? route) {
    if (route == null) return false;

    final protectedRoutes = [
      '/home',
      '/profile',
      '/orders',
      '/cart',
      '/bookings',
      // Add other protected routes here
    ];

    return protectedRoutes.any(
      (protectedRoute) => route.startsWith(protectedRoute),
    );
  }
}

class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();

    // If user is already logged in and trying to access auth routes
    if (authController.isLoggedIn.value && _isAuthRoute(route)) {
      return const RouteSettings(name: '/home');
    }
    return null;
  }

  bool _isAuthRoute(String? route) {
    if (route == null) return false;

    final authRoutes = ['/login', '/signup', '/forgot-password'];

    return authRoutes.any((authRoute) => route.startsWith(authRoute));
  }
}
