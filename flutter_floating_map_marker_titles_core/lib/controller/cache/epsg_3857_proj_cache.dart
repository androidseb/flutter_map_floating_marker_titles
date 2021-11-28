import 'package:flutter_floating_map_marker_titles_core/utils/cached_calculator.dart';
import 'package:flutter_floating_map_marker_titles_core/utils/geo/crs.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as Math;

class _Epsg3857ProjCacheKey {
  final LatLng latLng;
  final double zoom;

  _Epsg3857ProjCacheKey(
    this.latLng,
    this.zoom,
  );

  @override
  int get hashCode {
    return latLng.hashCode + zoom.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (!(other is _Epsg3857ProjCacheKey)) {
      return false;
    }
    final _Epsg3857ProjCacheKey o = other;
    return latLng == o.latLng && zoom == o.zoom;
  }
}

class _Epsg3857ProjCacheImpl extends CachedCalculator<_Epsg3857ProjCacheKey, Math.Point<num>> {
  static final Epsg3857 mapProjection = Epsg3857();

  _Epsg3857ProjCacheImpl(final int cacheMaxSize) : super(cacheMaxSize);

  @override
  Math.Point<num> calculateValue(final _Epsg3857ProjCacheKey key) {
    return mapProjection.latLngToPoint(key.latLng, key.zoom);
  }
}

class Epsg3857ProjCache {
  _Epsg3857ProjCacheImpl _projectionsCache;

  Epsg3857ProjCache(final int cacheMaxSize) {
    _projectionsCache = _Epsg3857ProjCacheImpl(cacheMaxSize);
  }

  void updateFrom(final Epsg3857ProjCache projCache) {
    _projectionsCache = projCache._projectionsCache;
  }

  Math.Point<num> getProjectedLatLng(final LatLng latLng, final double zoom) {
    return _projectionsCache.getValue(_Epsg3857ProjCacheKey(latLng, zoom));
  }
}
