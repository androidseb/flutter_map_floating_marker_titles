library flutter_map_floating_marker_titles;

import 'package:flutter/widgets.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_czr_map_view_interface.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_map_view_interface.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:flutter_floating_map_marker_titles_core/view/abstract_map_view_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class FlutterMapWithFMTO extends AbstractMapViewWrapper<_FlutterMapMVI> {
  final MapOptions _mapOptions;
  final List<Widget> _children;
  final List<Widget> _nonRotatedChildren;

  factory FlutterMapWithFMTO({
    required final FMTOOptions fmtoOptions,
    required final MapOptions options,
    final Key? key,
    final List<FloatingMarkerTitleInfo>? floatingTitles,
    final Stream<List<FloatingMarkerTitleInfo>>? floatingTitlesStream,
    final List<Widget> children = const [],
    final List<Widget> nonRotatedChildren = const [],
    final MapController? mapController,
  }) {
    return FlutterMapWithFMTO._internal(
      _FlutterMapMVI(mapController ?? MapController(), fmtoOptions.mapProjectionsCacheSize),
      fmtoOptions,
      key,
      options,
      children,
      nonRotatedChildren,
      floatingTitles: floatingTitles,
      floatingTitlesStream: floatingTitlesStream,
    );
  }

  FlutterMapWithFMTO._internal(
    final _FlutterMapMVI mapViewInterface,
    final FMTOOptions fmtoOptions,
    final Key? key,
    this._mapOptions,
    this._children,
    @Deprecated(
      'Append all of these children to `children`. '
      'This property has been removed to simplify the way layers are inserted '
      'into the map, and allow for greater flexibility of layer positioning. '
      'This property is deprecated since v6.',
    )
    this._nonRotatedChildren, {
    final List<FloatingMarkerTitleInfo>? floatingTitles,
    final Stream<List<FloatingMarkerTitleInfo>>? floatingTitlesStream,
  }) : super(
          mapViewInterface,
          fmtoOptions,
          key: key,
          floatingTitles: floatingTitles,
          floatingTitlesStream: floatingTitlesStream,
        );

  @override
  Widget buildMapView(final BuildContext context, final _FlutterMapMVI mapViewInterface) {
    return FlutterMap(
      options: _mapOptions,
      children: _children,
      // ignore: deprecated_member_use
      nonRotatedChildren: _nonRotatedChildren,
      mapController: mapViewInterface.mapController,
    );
  }
}

class _FlutterMapMVI extends AbstractCZRMapViewInterface {
  MapController mapController;

  _FlutterMapMVI(
    this.mapController,
    final int projCacheSize,
  ) : super(projCacheSize);

  @override
  void updateFrom(final AbstractMapViewInterface oldMapInterface) {
    super.updateFrom(oldMapInterface);
    if (oldMapInterface is _FlutterMapMVI) {
      mapController = oldMapInterface.mapController;
    }
  }

  @override
  LatLng getMapViewCenter() {
    return mapController.camera.center;
  }

  @override
  double getMapViewZoom() {
    return mapController.camera.zoom;
  }

  @override
  double getMapViewRotationDegrees() {
    return mapController.camera.rotation;
  }
}
