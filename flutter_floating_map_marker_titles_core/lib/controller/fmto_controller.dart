import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/cache/text_painting_cache.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/floating_title_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/display/titles_display_state.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_map_view_interface.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:flutter_floating_map_marker_titles_core/utils/utils.dart';

enum FloatingMarkerGravity {
  left,
  top,
  right,
  bottom,
}

class FloatingMarkerPlacementPolicy {
  /// Anchor of the floating title
  final FloatingMarkerGravity anchor;

  /// Margin between the floating title's anchoring point and the text
  final double margin;

  const FloatingMarkerPlacementPolicy(this.anchor, this.margin);
}

class FMTOOptions {
  /// The number of milliseconds between two repaints of the titles layer. 60 frames per seconds = 16 milliseconds between each frame.
  final int repaintIntervalMillis;

  /// Titles text size
  final double textSize;

  /// Maximum number of floating titles
  final int maxTitlesCount;

  /// Maximum width of floating titles
  final double maxTitlesWidth;

  /// Maximum lines count of floating titles
  final int maxTitleLines;

  /// Maximum number of cached, pre-laid out, ready to draw floating titles info, since computing the layout of text is an expensive operation
  final int textPaintingCacheSize;

  /// Maximum number of cached coordinates by the map coordinates projections calculator
  final int mapProjectionsCacheSize;

  /// No performance drop with more markers once the maximum number of floating titles has been reached, since the library only scans for a limited number of markers per frame, which can be set with titlesToCheckPerFrame
  final int titlesToCheckPerFrame;

  /// Time in milliseconds of the title fade-in animation
  final int fadeInAnimationTimeMillis;

  /// Titles placement option with anchor and margin
  final FloatingMarkerPlacementPolicy titlePlacementPolicy;

  const FMTOOptions({
    this.repaintIntervalMillis = 16,
    this.textSize = 14.0,
    this.maxTitlesCount = 30,
    this.maxTitlesWidth = 150,
    this.maxTitleLines = 2,
    this.textPaintingCacheSize = 2000,
    this.mapProjectionsCacheSize = 10000,
    this.titlesToCheckPerFrame = 30,
    this.fadeInAnimationTimeMillis = 300,
    this.titlePlacementPolicy = const FloatingMarkerPlacementPolicy(FloatingMarkerGravity.right, 12),
  });
}

class FMTOController {
  final AbstractMapViewInterface _mapViewInterface;
  final Map<int, FloatingMarkerTitleInfo> _titlesMap;
  final TextPaintingCache _textPaintingCache;
  final TitlesDisplayState _titlesDisplayState;
  final FMTOOptions fmtoOptions;
  List<FloatingMarkerTitleInfo> _floatingTitles;

  String? _lastMapViewTitlesPerspectiveValue;
  Function(double transparentLayerOpacity)? _onTransparentTitlesOpacityChanged;

  FMTOController(
    this._mapViewInterface,
    final FMTOOptions options, {
    final List<FloatingMarkerTitleInfo>? floatingTitles,
    final Stream<List<FloatingMarkerTitleInfo>>? floatingTitlesStream,
  })  : fmtoOptions = options,
        _titlesMap = {},
        _floatingTitles = floatingTitles ?? [],
        _textPaintingCache = TextPaintingCache(options.textPaintingCacheSize),
        _titlesDisplayState = TitlesDisplayState() {
    _updateTitlesMap(floatingTitlesStream?.asBroadcastStream());
  }

  void setOnTransparentTitlesOpacityChanged(
    final Function(double transparentLayerOpacity) onTransparentTitlesOpacityChanged,
  ) {
    _onTransparentTitlesOpacityChanged = onTransparentTitlesOpacityChanged;
  }

  Future<void> _updateTitlesMap(final Stream<List<FloatingMarkerTitleInfo>>? floatingTitlesStream) async {
    do {
      for (final FloatingMarkerTitleInfo fmti in _floatingTitles) {
        _titlesMap[fmti.id] = fmti;
      }
    } while (await _attemptUpdateFromStream(floatingTitlesStream));
  }

  Future<bool> _attemptUpdateFromStream(final Stream<List<FloatingMarkerTitleInfo>>? floatingTitlesStream) async {
    if (floatingTitlesStream == null) {
      return false;
    }
    try {
      _floatingTitles = await floatingTitlesStream.first;
      _titlesMap.clear();
      return true;
    } catch (_) {
      return false;
    }
  }

  void updateFrom(final FMTOController oldController) {
    _mapViewInterface.updateFrom(oldController._mapViewInterface);
    _titlesDisplayState.updateFrom(oldController._titlesDisplayState);
    _textPaintingCache.updateFrom(oldController._textPaintingCache);
  }

  bool _titleFitsInScreenBounds(
    final TitleDisplayInfo titleDisplayInfo,
    final Size size,
  ) {
    return titleDisplayInfo.viewCoordinates.dx + titleDisplayInfo.titlePainter.width > 0 &&
        titleDisplayInfo.viewCoordinates.dy + titleDisplayInfo.titlePainter.height > 0 &&
        titleDisplayInfo.viewCoordinates.dx < size.width &&
        titleDisplayInfo.viewCoordinates.dy < size.height;
  }

  bool _titleFitsBetweenExistingTitles(final TitleDisplayInfo titleDisplayInfo) {
    for (final TitleDisplayInfo tdi in _titlesDisplayState.titleDisplayInfos) {
      if (titleDisplayInfo.floatingMarkerTitleInfo.id == tdi.floatingMarkerTitleInfo.id) {
        continue;
      }
      if (titleDisplayInfo.intersectsWith(tdi)) {
        return false;
      }
    }
    return true;
  }

  /// If a list of titles with zindex stricly lower than titleDisplayInfo can be removed to make
  /// titleDisplayInfo fit without conflict, returns that list, otherwise returns null
  ///
  /// This means that if a single other title is in conflict with titleDisplayInfo and does not
  /// have a strictly lower zindex, the result of this function will be null, even if some conflicting
  /// titles with a lower zindex exist. The purpose of this check is to see if it's worth it to remove
  /// a few titles to fit the one with a higher priority, but if that title is blocked anyways, there
  /// is no point to remove lower zindex conflicting titles.
  List<TitleDisplayInfo>? _getConflictingLowerZIndexTitles(final TitleDisplayInfo titleDisplayInfo) {
    final int candidateZIndex = titleDisplayInfo.floatingMarkerTitleInfo.zIndex;
    final List<TitleDisplayInfo> res = [];
    for (final TitleDisplayInfo tdi in _titlesDisplayState.titleDisplayInfos) {
      if (titleDisplayInfo.floatingMarkerTitleInfo.id == tdi.floatingMarkerTitleInfo.id) {
        continue;
      }
      if (titleDisplayInfo.intersectsWith(tdi)) {
        if (tdi.floatingMarkerTitleInfo.zIndex < candidateZIndex) {
          res.add(tdi);
        } else {
          return null;
        }
      }
    }
    return res;
  }

  void _updateDisplayStateWithTitleAndGeometryInfo(
    final FloatingMarkerTitleInfo floatingMarkerTitleInfo,
    final Size size,
    final FloatingTitlePainter titlePainter,
    final Offset viewCoordinates,
    final bool resolveTitlesCollisions,
  ) {
    final TitleDisplayInfo newTdi = TitleDisplayInfo(
      floatingMarkerTitleInfo,
      titlePainter,
      viewCoordinates,
    );
    if (_titleFitsInScreenBounds(newTdi, size)) {
      if (!resolveTitlesCollisions || _titleFitsBetweenExistingTitles(newTdi)) {
        _titlesDisplayState.updateWithTitleInfo(newTdi);
      } else {
        final List<TitleDisplayInfo>? titlesToRemove = _getConflictingLowerZIndexTitles(newTdi);
        if (titlesToRemove == null) {
          _titlesDisplayState.removeTitleInfo(newTdi.floatingMarkerTitleInfo.id);
        } else {
          for (final TitleDisplayInfo tdi in titlesToRemove) {
            _titlesDisplayState.removeTitleInfo(tdi.floatingMarkerTitleInfo.id);
          }
          _titlesDisplayState.updateWithTitleInfo(newTdi);
        }
      }
    } else {
      _titlesDisplayState.removeTitleInfo(newTdi.floatingMarkerTitleInfo.id);
    }
  }

  Offset _viewCoordinatesToTitleCoordinates(
    final Offset viewCoordinates,
    final double width,
    final double height,
  ) {
    double viewX = viewCoordinates.dx;
    double viewY = viewCoordinates.dy;
    switch (fmtoOptions.titlePlacementPolicy.anchor) {
      case FloatingMarkerGravity.right:
        viewX = viewX + fmtoOptions.titlePlacementPolicy.margin;
        viewY = viewY - height / 2;
        break;
      case FloatingMarkerGravity.left:
        viewX = viewX - width - fmtoOptions.titlePlacementPolicy.margin;
        viewY = viewY - height / 2;
        break;
      case FloatingMarkerGravity.top:
        viewX = viewX - width / 2;
        viewY = viewY - height - fmtoOptions.titlePlacementPolicy.margin;
        break;
      case FloatingMarkerGravity.bottom:
        viewX = viewX - width / 2;
        viewY = viewY + fmtoOptions.titlePlacementPolicy.margin;
        break;
    }
    return Offset(viewX, viewY);
  }

  void _updateDisplayStateWithTitleInfo(
    final FloatingMarkerTitleInfo floatingMarkerTitleInfo,
    final Size size,
    final bool resolveTitlesCollisions,
  ) {
    final FloatingTitlePainter titlePainter = _textPaintingCache.getTitlePainter(
      floatingMarkerTitleInfo.title,
      floatingMarkerTitleInfo.color,
      floatingMarkerTitleInfo.isBold,
      fmtoOptions,
    );
    final Offset viewCoordinates = _mapViewInterface.latLngToViewCoordinates(
      floatingMarkerTitleInfo.latLng,
      size,
    );
    final Offset titleCoordinates =
        _viewCoordinatesToTitleCoordinates(viewCoordinates, titlePainter.width, titlePainter.height);
    _updateDisplayStateWithTitleAndGeometryInfo(
      floatingMarkerTitleInfo,
      size,
      titlePainter,
      titleCoordinates,
      resolveTitlesCollisions,
    );
  }

  /// Updates the display state for all already currently displayed tiles and returns the lowest z-index found
  /// among all displayed titles
  int _updateDisplayStateForCurrentlyDisplayedTitles(final Size size) {
    int? currentTitlesLowestZIndex;
    final String newMapViewTitlesPerspectiveValue = _mapViewInterface.getMapViewTitlesPerspectiveValue();
    final bool resolveTitlesCollisions = _lastMapViewTitlesPerspectiveValue != newMapViewTitlesPerspectiveValue;
    _lastMapViewTitlesPerspectiveValue = newMapViewTitlesPerspectiveValue;
    final Iterable<TitleDisplayInfo> currentlyDisplayedTitles = List.from(_titlesDisplayState.titleDisplayInfos);
    for (final TitleDisplayInfo tdi in currentlyDisplayedTitles) {
      _updateDisplayStateWithTitleInfo(tdi.floatingMarkerTitleInfo, size, resolveTitlesCollisions);
      final int zIndex = tdi.floatingMarkerTitleInfo.zIndex;
      currentTitlesLowestZIndex ??= zIndex;
      if (zIndex < currentTitlesLowestZIndex) {
        currentTitlesLowestZIndex = zIndex;
      }
    }
    return currentTitlesLowestZIndex ?? 0;
  }

  void _updateDisplayStateByCheckingMoreTitles(final Size size, final int currentTitlesLowestZIndex) {
    final int titlesToCheck = math.min(_floatingTitles.length, fmtoOptions.titlesToCheckPerFrame);
    if (titlesToCheck <= 0) {
      return;
    }
    final int startIndex = _titlesDisplayState.currentTitleIndex;
    final int endIndex = startIndex + titlesToCheck;
    for (int i = startIndex; i < endIndex; i++) {
      final int saneIndex = i % _floatingTitles.length;
      final FloatingMarkerTitleInfo fmti = _floatingTitles[saneIndex];
      if (_titlesDisplayState.titlesCount < fmtoOptions.maxTitlesCount || fmti.zIndex > currentTitlesLowestZIndex) {
        _updateDisplayStateWithTitleInfo(fmti, size, true);
      }
    }
    _titlesDisplayState.currentTitleIndex = endIndex;
  }

  void _updateFadingInTitlesState() {
    final int currentTimeEpochMillis = Utils.currentTimeEpochMillis();
    final int currentFadeInDuration = currentTimeEpochMillis - _titlesDisplayState.lastFadeInStartTimeEpochMillis;
    if (currentFadeInDuration < fmtoOptions.fadeInAnimationTimeMillis) {
      _onTransparentTitlesOpacityChanged?.call(currentFadeInDuration / fmtoOptions.fadeInAnimationTimeMillis);
    } else {
      _titlesDisplayState.fullyVisibleTitleIds.addAll(_titlesDisplayState.fadingInTitleIds);
      _titlesDisplayState.fadingInTitleIds.clear();
      _onTransparentTitlesOpacityChanged?.call(0);
    }
  }

  void _updatePendingFadeInTitlesState() {
    _titlesDisplayState.lastFadeInStartTimeEpochMillis = Utils.currentTimeEpochMillis();
    _titlesDisplayState.fadingInTitleIds.addAll(_titlesDisplayState.pendingFadeInTitleIds);
    _titlesDisplayState.pendingFadeInTitleIds.clear();
    _updateFadingInTitlesState();
  }

  void _updateDisplayStateTitlesWorkflow() {
    if (_titlesDisplayState.fadingInTitleIds.isNotEmpty) {
      _updateFadingInTitlesState();
    } else if (_titlesDisplayState.pendingFadeInTitleIds.isNotEmpty) {
      _updatePendingFadeInTitlesState();
    } else {
      _titlesDisplayState.lastFadeInStartTimeEpochMillis = 0;
      _onTransparentTitlesOpacityChanged?.call(0);
    }
  }

  void _updateDisplayState(final Size size) {
    if (fmtoOptions.maxTitlesCount <= 0) {
      _titlesDisplayState.removeAllTitles();
    } else {
      _titlesDisplayState.removeObsoleteTitles(_titlesMap.keys);
      final int currentTitlesLowestZIndex = _updateDisplayStateForCurrentlyDisplayedTitles(size);
      _updateDisplayStateByCheckingMoreTitles(size, currentTitlesLowestZIndex);
    }
    _updateDisplayStateTitlesWorkflow();
  }

  void _paintTitles(final Canvas canvas, final Set<int> floatingMarkerTitleInfoIds) {
    for (final int floatingMarkerTitleInfoId in floatingMarkerTitleInfoIds) {
      final TitleDisplayInfo? tdi = _titlesDisplayState.getTitleDisplayInfo(floatingMarkerTitleInfoId);
      if (tdi == null) {
        continue;
      }
      tdi.titlePainter.paintTitle(
        canvas,
        tdi.viewCoordinates,
      );
    }
  }

  void paintFloatingMarkerTitles(
    final Canvas canvas,
    final Size size,
    final bool transparentTitles,
  ) {
    if (transparentTitles) {
      _paintTitles(canvas, _titlesDisplayState.fadingInTitleIds);
    } else {
      _updateDisplayState(size);
      _paintTitles(canvas, _titlesDisplayState.fullyVisibleTitleIds);
    }
  }
}
