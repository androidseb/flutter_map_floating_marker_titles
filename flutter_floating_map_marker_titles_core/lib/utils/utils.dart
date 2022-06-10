import 'package:flutter/material.dart';

class Utils {
  static const double minLuminanceToLightTinting = 0.75;

  static double colorLuminance(final Color color) {
    final double red = color.red / 255.0;
    final double green = color.green / 255.0;
    final double blue = color.blue / 255.0;

    return 0.2126 * red + 0.7152 * green + 0.0722 * blue;
  }

  static bool isDarkColor(final Color color) {
    return colorLuminance(color) < minLuminanceToLightTinting;
  }

  static int currentTimeEpochMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
