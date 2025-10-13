import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  static const double baseHeight = 812;
  static const double baseWidth = 375;

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double w(double originalWidth) {
    double scaleFactor = screenWidth / baseWidth;
    return originalWidth * scaleFactor;
  }

  double h(double originalHeight) {
    double scaleFactor = screenHeight / baseHeight;
    return originalHeight * scaleFactor;
  }

  double f(double originalFontSize) {
    double scaleFactor = screenWidth / baseWidth;
    return originalFontSize * scaleFactor;
  }

  double borderRadius(double originalRadius) {
    double scaleFactor = screenWidth / baseWidth;
    return originalRadius * scaleFactor;
  }
}
