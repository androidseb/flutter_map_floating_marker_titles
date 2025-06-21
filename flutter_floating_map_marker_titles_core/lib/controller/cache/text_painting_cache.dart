import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/floating_title_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/utils/cached_calculator.dart';
import 'package:flutter_floating_map_marker_titles_core/utils/utils.dart';

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
    return textString.hashCode +
        textColor.hashCode +
        isBoldText.hashCode +
        options.maxTitleLines.hashCode +
        options.maxTitlesWidth.hashCode +
        options.textSize.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (other is! _TextPaintingCacheKey) {
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
  _TextPaintingCacheImpl(super.cacheMaxSize);

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
  final int? _maxTimeToLiveMillis;
  late _TextPaintingCacheImpl _paintersCache;
  int? _startTime;

  TextPaintingCache(final int cacheMaxSize, this._maxTimeToLiveMillis) {
    _paintersCache = _TextPaintingCacheImpl(cacheMaxSize);
  }

  void checkAndApplyTimeToLive() {
    if (_maxTimeToLiveMillis == null) {
      // If we have no max time to live to apply, we halt here
      return;
    }

    // Sanitizing the maxTimeToLive value to ensure it's a positive integer
    final maxTimeToLive = math.max(0, _maxTimeToLiveMillis ?? 0);

    // Obtaining start time
    final startTime = _startTime;
    if (startTime == null) {
      // If start time is not set, we set it now and giving up for this round
      _startTime = Utils.currentTimeEpochMillis();
      return;
    }

    // Obtaining current time
    final currentTime = Utils.currentTimeEpochMillis();

    // Computing the elapsed time since startTime
    final timeElapsed = currentTime - startTime;
    if (timeElapsed < 0) {
      // We went back in time, maybe because the device clock changed
      // treating this as an invalid / uninitialized start time and
      // giving up for this round
      _startTime = Utils.currentTimeEpochMillis();
      return;
    }

    if (timeElapsed < maxTimeToLive) {
      // If the time elapsed is less than the max time to live, we do nothing more
      return;
    }

    // If we reach this point, it means that the following conditions are met:
    // - maxTimeToLive is a positive integer
    // - startTime is older than maxTimeToLive

    // We clear the cache and reset the start time
    _paintersCache.clear();
    _startTime = Utils.currentTimeEpochMillis();
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
    return _paintersCache.getValue(
      _TextPaintingCacheKey(
        textString,
        textColor,
        isBoldText,
        options,
      ),
    );
  }
}
