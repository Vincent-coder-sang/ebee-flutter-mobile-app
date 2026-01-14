// app/utils/responsive.dart
import 'package:flutter/material.dart';

class Responsive {
  static Size size(BuildContext context) => MediaQuery.of(context).size;

  static double width(BuildContext context) => size(context).width;

  static double height(BuildContext context) => size(context).height;

  static bool isTablet(BuildContext context) =>
      width(context) >= 768 && width(context) < 1200;

  static bool isDesktop(BuildContext context) => width(context) >= 1200;

  /// Responsive button height
  static double buttonHeight(BuildContext context) {
    final h = height(context) * 0.065;
    return h.clamp(44, 56);
  }

  /// Responsive AppBar height
  static double appBarHeight(BuildContext context) {
    if (isDesktop(context)) return 72;
    if (isTablet(context)) return 64;
    return kToolbarHeight;
  }
}
