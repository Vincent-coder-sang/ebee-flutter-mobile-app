import 'dart:convert';

import 'package:ebee/app/data/models/user_model.dart';
import 'package:ebee/app/data/providers/local_storage.dart';
import 'package:ebee/app/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final isLoading = false.obs;
  final user = Rxn<UserModel>();
  final token = ''.obs;
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  /* -------------------------------------------------------------------------- */
  /*                               TOKEN HANDLING                               */
  /* -------------------------------------------------------------------------- */

  bool get isTokenValid {
    if (token.value.isEmpty) return false;

    try {
      final payload = _decodeJWT(token.value);
      final exp = payload['exp'];

      if (exp != null) {
        final expiration = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        return expiration.isAfter(DateTime.now());
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                 AUTH FLOW                                  */
  /* -------------------------------------------------------------------------- */
  Future<bool> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      print('📧 Sending password reset request for: $email');

      await _authRepository.forgotPassword(email);

      isLoading.value = false;

      _showSnackbar(
        title: 'Email Sent',
        message: 'Password reset instructions have been sent to your email',
        backgroundColor: Colors.blue,
      );

      // Go back after short delay
      await Future.delayed(const Duration(milliseconds: 1200));
      Get.back();
      return true;
    } catch (e) {
      isLoading.value = false;
      print('❌ Forgot password failed: $e');

      _showSnackbar(
        title: 'Reset Failed',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      final response = await _authRepository.login(email, password);
      final responseToken = response['token'];
      final responseMessage = response['message'];

      if (responseToken == null || responseToken.isEmpty) {
        throw 'No token received from server';
      }

      final payload = _decodeJWT(responseToken);

      user.value = UserModel.fromJson(payload);
      token.value = responseToken;

      await LocalStorage.saveToken(responseToken);
      await LocalStorage.saveUserData(user.value!.toJson());

      isLoggedIn.value = true;
      isLoading.value = false;

      _showSnackbar(
        title: 'Success',
        message: responseMessage ?? 'Login successful',
        backgroundColor: Colors.green,
      );

      await Future.delayed(const Duration(milliseconds: 1200));
      Get.offAllNamed('/home');
      return true;
    } catch (e) {
      isLoading.value = false;

      _showSnackbar(
        title: 'Login Failed',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
    String confirmPassword,
  ) async {
    try {
      isLoading.value = true;

      final response = await _authRepository.register(
        name,
        email,
        phone,
        password,
        confirmPassword,
      );

      final responseToken = response['token'];

      if (responseToken != null) {
        final payload = _decodeJWT(responseToken);
        user.value = UserModel.fromJson(payload);
        token.value = responseToken;

        await LocalStorage.saveToken(responseToken);
        await LocalStorage.saveUserData(user.value!.toJson());

        isLoggedIn.value = true;

        _showSnackbar(
          title: 'Welcome',
          message: 'Account created successfully',
          backgroundColor: Colors.green,
        );

        await Future.delayed(const Duration(milliseconds: 1200));
        Get.offAllNamed('/home');
      } else {
        _showSnackbar(
          title: 'Success',
          message: 'Account created. Please login.',
          backgroundColor: Colors.green,
        );

        await Future.delayed(const Duration(milliseconds: 1200));
        Get.offAllNamed('/login');
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;

      _showSnackbar(
        title: 'Registration Failed',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                AUTH STATUS                                 */
  /* -------------------------------------------------------------------------- */

  Future<void> _checkAuthStatus() async {
    final storedToken = LocalStorage.getToken();
    final storedUser = LocalStorage.getUserData();

    if (storedToken != null && storedUser != null) {
      token.value = storedToken;
      user.value = UserModel.fromJson(storedUser);

      if (isTokenValid) {
        isLoggedIn.value = true;
      } else {
        await _logoutLocally();
      }
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authRepository.logout();
    } finally {
      await _logoutLocally();

      _showSnackbar(
        title: 'Logged Out',
        message: 'You have been logged out',
        backgroundColor: Colors.blue,
      );

      await Future.delayed(const Duration(milliseconds: 1200));
      Get.offAllNamed('/login');
    }
  }

  Future<void> _logoutLocally() async {
    await LocalStorage.clearAuthData();
    user.value = null;
    token.value = '';
    isLoggedIn.value = false;
    isLoading.value = false;
  }

  /* -------------------------------------------------------------------------- */
  /*                                ROLE CHECKS                                 */
  /* -------------------------------------------------------------------------- */

  bool get isAdmin => user.value?.userType == UserType.admin;

  bool get isCustomer => user.value?.userType == UserType.customer;

  bool get isDispatchManager =>
      user.value?.userType == UserType.dispatchManager;

  bool get isDriver => user.value?.userType == UserType.driver;

  bool get isTechnician => user.value?.userType == UserType.technicianManager;

  /* -------------------------------------------------------------------------- */
  /*                                   UTILS                                    */
  /* -------------------------------------------------------------------------- */

  Map<String, dynamic> _decodeJWT(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return {};

    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );

    return json.decode(payload);
  }

  void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}
