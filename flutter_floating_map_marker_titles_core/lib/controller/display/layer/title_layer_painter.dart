import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/utils/utils.dart';

abstract class TitleLayerPainter {
  static Color computeBgColorForTextColor(final Color textColor) {
    if (Utils.isDarkColor(textColor)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  final String _textString;
  final Color _textColor;
  final bool _isBoldText;
  final FMTOOptions _fmtoOptions;

  TextPainter _textPainter;

  TitleLayerPainter(
    this._textString,
    this._textColor,
    this._isBoldText,
    this._fmtoOptions,
  ) {
    _textPainter = _buildTextPainter();
  }

  TextSpan buildText(
    final String textString,
    final Color textColor,
    final bool isBoldText,
    final FMTOOptions fmtoOptions,
  );

  TextPainter _buildTextPainter() {
    final TextPainter textPainter = TextPainter(
      text: buildText(
        _textString,
        _textColor,
        _isBoldText,
        _fmtoOptions,
      ),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      maxLines: _fmtoOptions.maxTitleLines,
      ellipsis: '...',
    );
    textPainter.layout(maxWidth: _fmtoOptions.maxTitlesWidth);
    return textPainter;
  }

  double get width => _textPainter.width;

  double get height => _textPainter.height;

  void paintLayer(
    final Canvas canvas,
    final Offset offset,
  ) {
    _textPainter.paint(canvas, offset);
  }
}
