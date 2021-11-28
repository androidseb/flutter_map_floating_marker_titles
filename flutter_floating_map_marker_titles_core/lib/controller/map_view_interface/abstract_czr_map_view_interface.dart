import 'package:flutter_floating_map_marker_titles_core/controller/cache/epsg_3857_proj_cache.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_map_view_interface.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as VectorMath;
import 'dart:math' as Math;

abstract class AbstractCZRMapViewInterface extends AbstractMapViewInterface {
  final Epsg3857ProjCache _projCache;

  AbstractCZRMapViewInterface(final int projCacheSize) : _projCache = Epsg3857ProjCache(projCacheSize);

  @override
  void updateFrom(AbstractMapViewInterface oldMapInterface) {
    final AbstractCZRMapViewInterface oldMapInterfaceCast = oldMapInterface as AbstractCZRMapViewInterface;
    _projCache.updateFrom(oldMapInterfaceCast._projCache);
  }

  LatLng getMapViewCenter();
  double getMapViewZoom();
  double getMapViewRotationDegrees();

  @override
  Offset latLngToViewCoordinates(final LatLng latLng, final Size viewSize) {
    final LatLng centerLatLng = getMapViewCenter();
    final double mapViewZoom = getMapViewZoom();
    final double mapViewRotationDegrees = getMapViewRotationDegrees();
    final Math.Point<num> targetPoint = _projCache.getProjectedLatLng(latLng, mapViewZoom);
    final Math.Point<num> centerPoint = _projCache.getProjectedLatLng(centerLatLng, mapViewZoom);
    final double xDiff = targetPoint.x - centerPoint.x;
    final double yDiff = targetPoint.y - centerPoint.y;
    final double viewCenterX = viewSize.width / 2;
    final double viewCenterY = viewSize.height / 2;
    if (mapViewRotationDegrees == 0) {
      return Offset(viewCenterX + xDiff, viewCenterY + yDiff);
    } else {
      final double radius = Math.sqrt(Math.pow(xDiff, 2) + Math.pow(yDiff, 2));
      final double baseAngleRad = Math.acos(xDiff / radius);
      final double angleDeltaRad = VectorMath.radians(mapViewRotationDegrees);
      double resultingAngleRad;
      if (yDiff >= 0) {
        resultingAngleRad = baseAngleRad + angleDeltaRad;
      } else {
        resultingAngleRad = angleDeltaRad - baseAngleRad;
      }
      final double translatedXDiff = radius * Math.cos(resultingAngleRad);
      final double translatedYDiff = radius * Math.sin(resultingAngleRad);
      return Offset(
        viewCenterX + translatedXDiff,
        viewCenterY + translatedYDiff,
      );
    }
  }

  @override
  String getMapViewTitlesPerspectiveValue() {
    return '${getMapViewRotationDegrees()}-${getMapViewZoom()}';
  }
}
