import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

abstract class AbstractMapViewInterface {
  /// Update the Map Interface from a previous instance.
  /// This method is the ideal moment to transfer any cache data from the old instance
  void updateFrom(final AbstractMapViewInterface  oldMapInterface);

  /// Convert LatLng coordinates to screen coordinates
  Offset latLngToViewCoordinates(final LatLng latLng, final Size viewSize);

  /// Return the current Map View Titles Perspective Value:
  /// This value is a way to identify when the map view perspective has changed in a way
  /// floating titles might collide with each other (e.g. zoom, rotation, tilt, etc.)
  /// This allows the floating titles controller to know when to ignore existing titles collisions,
  /// to avoid making titles blink when they are too close together with coordinates calculations
  /// rounding makes them look like they are colliding/not colliding every other frame.
  String getMapViewTitlesPerspectiveValue() ;
}
