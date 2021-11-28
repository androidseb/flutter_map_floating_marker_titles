import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class FloatingMarkerTitleInfo {
  /// ID of the floating title, used by the system to track what was added/removed between two paints
  final int id;

  /// Base coordinates the title is attached to
  final LatLng latLng;

  /// The title text as a String
  final String title;

  /// The title base color
  final Color color;

  /// Whether the title text should be written in bold
  final bool isBold;

  /// z-index of the title to specify which title has the most priority for display in case of titles collisions
  final int zIndex;

  FloatingMarkerTitleInfo({
    @required this.id,
    @required this.latLng,
    @required this.title,
    @required this.color,
    this.isBold = false,
    this.zIndex = 1,
  });
}
