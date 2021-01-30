import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/layer/title_layer_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';

class BgNativeTitleLayerPainter extends TitleLayerPainter {
  BgNativeTitleLayerPainter(
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
        fontWeight: isBoldText ? FontWeight.bold : FontWeight.normal,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = TitleLayerPainter.computeBgColorForTextColor(textColor),
      ),
      text: textString,
    );
  }
}
