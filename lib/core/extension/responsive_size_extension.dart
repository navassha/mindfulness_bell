import 'package:flutter/material.dart';

// This is the Responsive Extension used for the UI
extension ResponsiveSize on BuildContext {
  double responsiveSize(double width) {
    return MediaQuery.sizeOf(this).width * (width / 376);
  }
}
