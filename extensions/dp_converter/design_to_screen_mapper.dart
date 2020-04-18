import 'dart:math';

import 'package:flutter/material.dart';

class DesignToScreenMapper {
  static double designPixelRatio = 3.0;
  static double designWidth = 360;
  static double textScale;
  static double screenWidth;

  static init(BuildContext context) {
    if (context == null) return;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    textScale = mediaQueryData.textScaleFactor;
    screenWidth = min(mediaQueryData.size.width, mediaQueryData.size.height);
  }

  static double dpToPixels({double dp, int px}) {
    if (dp != null) {
      return dp / designWidth * screenWidth;
    } else if (px != null) {
      return px / designPixelRatio / designWidth * screenWidth;
    }
    return 0.0;
  }

  static double spToPixels({double sp, bool scale = false}) {
    return dpToPixels(dp: sp) * (scale ? textScale : 1.0);
  }
}
