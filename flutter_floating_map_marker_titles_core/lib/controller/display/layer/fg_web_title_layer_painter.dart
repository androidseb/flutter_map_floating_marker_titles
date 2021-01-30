import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/layer/title_layer_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';

/// This class can be deleted once this bug is fixed:
/// https://github.com/flutter/flutter/issues/46683
class FgWebTitleLayerPainter extends TitleLayerPainter {
  static const int _SHADOWS_STACK_COUNT = 5;
  static const double _SHADOWS_BLUR_RADIUS = 2;

  FgWebTitleLayerPainter(
    final String textString,
    final Color textColor,
    final bool isBoldText,
    final FMTOOptions fmtoOptions,
  ) : super(textString, textColor, isBoldText, fmtoOptions);

  @override
  TextSpan buildText(
    final String textString,
    final Color textColor,
    final bool isBoldText,
    final FMTOOptions fmtoOptions,
  ) {
    final Color bgColor = TitleLayerPainter.computeBgColorForTextColor(textColor);
    // Unfortunately it is not possible to do a stroke paint on web because of this bug:
    // https://github.com/flutter/flutter/issues/46683
    // Working around this by using shadows instead for now
    return TextSpan(
      style: TextStyle(
        fontSize: fmtoOptions.textSize,
        color: textColor,
        fontWeight: isBoldText ? FontWeight.bold : FontWeight.normal,
        shadows: _buildShadows(bgColor),
      ),
      text: textString,
    );
  }

  List<Shadow> _buildShadows(final Color shadowColor) {
    final List<Shadow> res = [];
    for (int i = 0; i < _SHADOWS_STACK_COUNT; i++) {
      res.add(Shadow(
        color: shadowColor,
        blurRadius: _SHADOWS_BLUR_RADIUS,
      ));
    }
    return res;
  }
}
