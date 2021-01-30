library flutter_map_floating_marker_titles;

import 'package:flutter/widgets.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_czr_map_view_interface.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:flutter_floating_map_marker_titles_core/view/abstract_map_view_wrapper.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

class FlutterMapWithFMTO extends AbstractMapViewWrapper<_FlutterMapMVI> {
  final MapOptions _mapOptions;
  final List<LayerOptions> _layers;
  final List<Widget> _children;

  factory FlutterMapWithFMTO(
    final List<FloatingMarkerTitleInfo> floatingTitles, {
    final FMTOOptions fmtoOptions,
    final Key key,
    @required final MapOptions options,
    final List<LayerOptions> layers = const [],
    final List<Widget> children = const [],
    final FMTOMapController mapController,
  }) {
    return FlutterMapWithFMTO._internal(
      _FlutterMapMVI(mapController ?? FMTOMapController(), fmtoOptions.mapProjectionsCacheSize),
      floatingTitles,
      fmtoOptions,
      key,
      options,
      layers,
      children,
    );
  }

  FlutterMapWithFMTO._internal(
    final _FlutterMapMVI mapViewInterface,
    final List<FloatingMarkerTitleInfo> floatingTitles,
    final FMTOOptions fmtoOptions,
    final Key key,
    this._mapOptions,
    this._layers,
    this._children,
  ) : super(
          mapViewInterface,
          floatingTitles,
          fmtoOptions,
          key: key,
        );

  @override
  Widget buildMapView(final BuildContext context, final _FlutterMapMVI mapViewInterface) {
    return FlutterMap(
      options: _mapOptions,
      layers: _layers,
      children: _children,
      mapController: mapViewInterface.mapController,
    );
  }
}

class FMTOMapController extends MapControllerImpl {
  double _rotationDegrees = 0;
  ValueChanged<double> _onRotationChanged;

  FMTOMapController() {
    super.onRotationChanged = (final double rotationDegrees) {
      _rotationDegrees = rotationDegrees;
      if (_onRotationChanged != null) {
        _onRotationChanged(rotationDegrees);
      }
    };
  }

  @override
  set onRotationChanged(onRotationChanged) {
    _onRotationChanged = onRotationChanged;
  }

  double get rotation => _rotationDegrees;
}

class _FlutterMapMVI extends AbstractCZRMapViewInterface {
  final FMTOMapController mapController;

  _FlutterMapMVI(
    this.mapController,
    final int projCacheSize,
  ) : super(projCacheSize);

  @override
  LatLng getMapViewCenter() {
    return mapController.center;
  }

  @override
  double getMapViewZoom() {
    return mapController.zoom;
  }

  @override
  double getMapViewRotationDegrees() {
    return mapController.rotation;
  }
}
