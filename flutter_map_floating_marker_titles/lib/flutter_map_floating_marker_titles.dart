library flutter_map_floating_marker_titles;

import 'package:flutter/widgets.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_czr_map_view_interface.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_map_view_interface.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:flutter_floating_map_marker_titles_core/view/abstract_map_view_wrapper.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

class FlutterMapWithFMTO extends AbstractMapViewWrapper<_FlutterMapMVI> {
  final MapOptions _mapOptions;
  final List<LayerOptions> _layers;
  final List<LayerOptions> _nonRotatedLayers;
  final List<Widget> _children;
  final List<Widget> _nonRotatedChildren;

  factory FlutterMapWithFMTO(
    final List<FloatingMarkerTitleInfo> floatingTitles, {
    final FMTOOptions fmtoOptions,
    final Key key,
    @required final MapOptions options,
    final List<LayerOptions> layers = const [],
    final List<LayerOptions> nonRotatedLayers = const [],
    final List<Widget> children = const [],
    final List<Widget> nonRotatedChildren = const [],
    final FMTOMapController mapController,
  }) {
    return FlutterMapWithFMTO._internal(
      _FlutterMapMVI(mapController ?? FMTOMapController(), fmtoOptions.mapProjectionsCacheSize),
      floatingTitles,
      fmtoOptions,
      key,
      options,
      layers,
      nonRotatedLayers,
      children,
      nonRotatedChildren,
    );
  }

  FlutterMapWithFMTO._internal(
    final _FlutterMapMVI mapViewInterface,
    final List<FloatingMarkerTitleInfo> floatingTitles,
    final FMTOOptions fmtoOptions,
    final Key key,
    this._mapOptions,
    this._layers,
    this._nonRotatedLayers,
    this._children,
    this._nonRotatedChildren,
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
      nonRotatedLayers: _nonRotatedLayers,
      children: _children,
      nonRotatedChildren: _nonRotatedChildren,
      mapController: mapViewInterface.mapController,
    );
  }
}

class FMTOMapController extends MapControllerImpl {
  MapState _state;

  @override
  set state(final MapState state) {
    _state = state;
    super.state = state;
  }

  double get rotation => _state == null ? 0 : _state.rotation;
}

class _FlutterMapMVI extends AbstractCZRMapViewInterface {
  FMTOMapController mapController;

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
