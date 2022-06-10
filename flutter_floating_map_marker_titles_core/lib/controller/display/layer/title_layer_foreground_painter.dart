import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/layer/title_layer_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';

class TitleLayerForegroundPainter extends TitleLayerPainter {
  TitleLayerForegroundPainter(
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
    return TextSpan(
      style: TextStyle(
        fontSize: fmtoOptions.textSize,
        color: textColor,
        fontWeight: isBoldText ? FontWeight.bold : FontWeight.normal,
      ),
      text: textString,
    );
  }
}
