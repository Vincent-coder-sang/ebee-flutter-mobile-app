// app/utils/ui_constants.dart
import 'package:flutter/material.dart';

class UIConstants {
  UIConstants._();

  // Base spacing unit
  static const double base = 8;

  // Padding
  static const EdgeInsets paddingSM = EdgeInsets.all(base * 2);
  static const EdgeInsets paddingMD = EdgeInsets.all(base * 3);

  // Radius
  static const double radiusSM = 8;
  static const double radiusMD = 12;

  // Fixed minimums (safe)
  static const double minButtonHeight = 44;
  static const double maxButtonHeight = 56;
}
