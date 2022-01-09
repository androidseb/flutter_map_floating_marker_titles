import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/layer/title_layer_background_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/layer/title_layer_foreground_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/layer/title_layer_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';

class FloatingTitlePainter {
  final TitleLayerPainter? _bgLayerPainter;
  final TitleLayerPainter _fgLayerPainter;

  factory FloatingTitlePainter(
    final String textString,
    final Color textColor,
    final bool isBoldText,
    final FMTOOptions fmtoOptions,
  ) {
    return FloatingTitlePainter._internal(
      _createBGPainter(textString, textColor, isBoldText, fmtoOptions),
      _createFGPainter(textString, textColor, isBoldText, fmtoOptions),
    );
  }

  FloatingTitlePainter._internal(
    this._bgLayerPainter,
    this._fgLayerPainter,
  );

  static TitleLayerPainter? _createBGPainter(
    final String textString,
    final Color textColor,
    final bool isBoldText,
    final FMTOOptions fmtoOptions,
  ) {
    return TitleLayerBackgroundPainter(
      textString,
      textColor,
      isBoldText,
      fmtoOptions,
    );
  }

  static TitleLayerPainter _createFGPainter(
    final String textString,
    final Color textColor,
    final bool isBoldText,
    final FMTOOptions fmtoOptions,
  ) {
    return TitleLayerForegroundPainter(
      textString,
      textColor,
      isBoldText,
      fmtoOptions,
    );
  }

  void paintTitle(final Canvas canvas, final Offset offset) {
    _bgLayerPainter?.paintLayer(canvas, offset);
    _fgLayerPainter.paintLayer(canvas, offset);
  }

  double get width {
    return _fgLayerPainter.width;
  }

  double get height {
    return _fgLayerPainter.height;
  }
}
