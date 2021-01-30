import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/floating_title_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/utils/cached_calculator.dart';

class _TextPaintingCacheKey {
  final String textString;
  final Color textColor;
  final bool isBoldText;
  final FMTOOptions options;

  _TextPaintingCacheKey(
    this.textString,
    this.textColor,
    this.isBoldText,
    this.options,
  );

  @override
  int get hashCode {
    return this.textString.hashCode +
        this.textColor.hashCode +
        this.isBoldText.hashCode +
        this.options.maxTitleLines.hashCode +
        this.options.maxTitlesWidth.hashCode +
        this.options.textSize.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (!(other is _TextPaintingCacheKey)) {
      return false;
    }
    final _TextPaintingCacheKey o = other;
    return textString == o.textString &&
        textColor == o.textColor &&
        isBoldText == o.isBoldText &&
        options.maxTitleLines == o.options.maxTitleLines &&
        options.maxTitlesWidth == o.options.maxTitlesWidth &&
        options.textSize == o.options.textSize;
  }
}

class _TextPaintingCacheImpl extends CachedCalculator<_TextPaintingCacheKey, FloatingTitlePainter> {
  _TextPaintingCacheImpl(final int cacheMaxSize) : super(cacheMaxSize);

  @override
  FloatingTitlePainter calculateValue(final _TextPaintingCacheKey key) {
    return FloatingTitlePainter(
      key.textString,
      key.textColor,
      key.isBoldText,
      key.options,
    );
  }
}

class TextPaintingCache {
  _TextPaintingCacheImpl _paintersCache;

  TextPaintingCache(final int cacheMaxSize) {
    _paintersCache = _TextPaintingCacheImpl(cacheMaxSize);
  }

  void updateFrom(final TextPaintingCache textPaintingCache) {
    _paintersCache = textPaintingCache._paintersCache;
  }

  FloatingTitlePainter getTitlePainter(
    final String textString,
    final Color textColor,
    final bool isBoldText,
    final FMTOOptions options,
  ) {
    return _paintersCache.getValue(_TextPaintingCacheKey(
      textString,
      textColor,
      isBoldText,
      options,
    ));
  }
}
