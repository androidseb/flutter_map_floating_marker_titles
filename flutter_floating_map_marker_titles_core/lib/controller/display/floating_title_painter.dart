import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/layer/bg_native_title_layer_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/layer/fg_native_title_layer_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/layer/fg_web_title_layer_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/layer/title_layer_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FloatingTitlePainter {
  final TitleLayerPainter _bgLayerPainter;
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

  static TitleLayerPainter _createBGPainter(
    final String textString,
    final Color textColor,
    final bool isBoldText,
    final FMTOOptions fmtoOptions,
  ) {
    if (kIsWeb) {
      return null;
    }
    return BgNativeTitleLayerPainter(
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
    if (kIsWeb) {
      return FgWebTitleLayerPainter(
        textString,
        textColor,
        isBoldText,
        fmtoOptions,
      );
    } else {
      return FgNativeTitleLayerPainter(
        textString,
        textColor,
        isBoldText,
        fmtoOptions,
      );
    }
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
