// File copied from the flutter_map project to re-use projection utils classes
// Source project file: https://raw.githubusercontent.com/fleaflet/flutter_map/master/lib/src/core/bounds.dart

import 'dart:math' as math;

import 'package:flutter_floating_map_marker_titles_core/utils/geo/point.dart';

/// Rectangular bound delimited by orthogonal lines passing through two
/// points.
class Bounds<T extends num> {
  final CustomPoint<T> min;
  final CustomPoint<T> max;

  factory Bounds(CustomPoint<T> a, CustomPoint<T> b) {
    var bounds1 = Bounds._(a, b);
    var bounds2 = bounds1.extend(a);
    return bounds2.extend(b);
  }

  const Bounds._(this.min, this.max);

  /// Creates a new [Bounds] obtained by expanding the current ones with a new
  /// point.
  Bounds<T> extend(CustomPoint<T> point) {
    return Bounds._(
      CustomPoint(
        math.min(point.x, min.x),
        math.min(point.y, min.y),
      ),
      CustomPoint(
        math.max(point.x, max.x),
        math.max(point.y, max.y),
      ),
    );
  }

  /// This [Bounds] central point.
  CustomPoint<double> get center => CustomPoint<double>(
        (min.x + max.x) / 2,
        (min.y + max.y) / 2,
      );

  /// Bottom-Left corner's point.
  CustomPoint<T> get bottomLeft => CustomPoint(min.x, max.y);

  /// Top-Right corner's point.
  CustomPoint<T> get topRight => CustomPoint(max.x, min.y);

  /// Top-Left corner's point.
  CustomPoint<T> get topLeft => min;

  /// Bottom-Right corner's point.
  CustomPoint<T> get bottomRight => max;

  /// A point that contains the difference between the point's axis projections.
  CustomPoint<T> get size {
    return max - min;
  }

  bool contains(CustomPoint<T> point) {
    var min = point;
    var max = point;
    return containsBounds(Bounds(min, max));
  }

  bool containsBounds(Bounds<T> b) {
    return (b.min.x >= min.x) &&
        (b.max.x <= max.x) &&
        (b.min.y >= min.y) &&
        (b.max.y <= max.y);
  }

  bool containsPartialBounds(Bounds<T> b) {
    return (b.min.x <= max.x) &&
        (b.max.x >= min.x) &&
        (b.min.y <= max.y) &&
        (b.max.y >= min.y);
  }

  @override
  String toString() => 'Bounds($min, $max)';
}
