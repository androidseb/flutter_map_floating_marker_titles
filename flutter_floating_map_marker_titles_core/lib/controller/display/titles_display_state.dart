import 'dart:ui';
import 'package:flutter_floating_map_marker_titles_core/controller/display/floating_title_painter.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:flutter_floating_map_marker_titles_core/utils/geo/bounds.dart';
import 'package:flutter_floating_map_marker_titles_core/utils/geo/point.dart';
import 'package:flutter_floating_map_marker_titles_core/utils/utils.dart';

class TitleDisplayInfo {
  int creationTime;
  final FloatingMarkerTitleInfo floatingMarkerTitleInfo;
  final FloatingTitlePainter titlePainter;
  final Offset viewCoordinates;
  final Bounds _displayBounds;

  TitleDisplayInfo(
    this.floatingMarkerTitleInfo,
    this.titlePainter,
    this.viewCoordinates,
  )   : creationTime = Utils.currentTimeEpochMillis(),
        _displayBounds = Bounds(
          CustomPoint<double>(
            viewCoordinates.dx,
            viewCoordinates.dy,
          ),
          CustomPoint<double>(
            viewCoordinates.dx + titlePainter.width,
            viewCoordinates.dy + titlePainter.height,
          ),
        );

  bool intersectsWith(final TitleDisplayInfo titleDisplayInfo) {
    return _displayBounds.containsPartialBounds(titleDisplayInfo._displayBounds);
  }
}

class TitlesDisplayState {
  final Map<int, TitleDisplayInfo> _titleDisplayInfoMap = {};
  final Set<int> fullyVisibleTitleIds = {};
  final Set<int> fadingInTitleIds = {};
  final Set<int> pendingFadeInTitleIds = {};
  int currentTitleIndex = 0;
  int lastFadeInStartTimeEpochMillis = 0;

  TitleDisplayInfo? getTitleDisplayInfo(final int floatingMarkerTitleInfoId) {
    return _titleDisplayInfoMap[floatingMarkerTitleInfoId];
  }

  void updateFrom(final TitlesDisplayState oldState) {
    _titleDisplayInfoMap.addAll(oldState._titleDisplayInfoMap);
    fullyVisibleTitleIds.addAll(oldState.fullyVisibleTitleIds);
    fadingInTitleIds.addAll(oldState.fadingInTitleIds);
    pendingFadeInTitleIds.addAll(oldState.pendingFadeInTitleIds);
    currentTitleIndex = oldState.currentTitleIndex;
    lastFadeInStartTimeEpochMillis = oldState.lastFadeInStartTimeEpochMillis;
  }

  void removeObsoleteTitles(final Iterable<int> availableIds) {
    final Iterable<int> currentIds = List.from(_titleDisplayInfoMap.keys);
    for (final currentId in currentIds) {
      if (!availableIds.contains(currentId)) {
        removeTitleInfo(currentId);
      }
    }
  }

  void removeAllTitles() {
    final Iterable<int> currentIds = List.from(_titleDisplayInfoMap.keys);
    for (final currentId in currentIds) {
      removeTitleInfo(currentId);
    }
  }

  void removeTitleInfo(final int floatingMarkerTitleInfoId) {
    _titleDisplayInfoMap.remove(floatingMarkerTitleInfoId);
    fullyVisibleTitleIds.remove(floatingMarkerTitleInfoId);
    fadingInTitleIds.remove(floatingMarkerTitleInfoId);
    pendingFadeInTitleIds.remove(floatingMarkerTitleInfoId);
  }

  void updateWithTitleInfo(final TitleDisplayInfo titleDisplayInfo) {
    final TitleDisplayInfo? existingTDI = _titleDisplayInfoMap[titleDisplayInfo.floatingMarkerTitleInfo.id];
    if (existingTDI == null) {
      pendingFadeInTitleIds.add(titleDisplayInfo.floatingMarkerTitleInfo.id);
    } else {
      titleDisplayInfo.creationTime = existingTDI.creationTime;
    }
    _titleDisplayInfoMap[titleDisplayInfo.floatingMarkerTitleInfo.id] = titleDisplayInfo;
  }

  Iterable<TitleDisplayInfo> get titleDisplayInfos {
    return _titleDisplayInfoMap.values;
  }

  int get titlesCount {
    return _titleDisplayInfoMap.length;
  }
}
