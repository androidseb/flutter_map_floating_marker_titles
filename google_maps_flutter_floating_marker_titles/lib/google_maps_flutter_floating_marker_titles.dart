library google_maps_flutter_floating_marker_titles;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_czr_map_view_interface.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:flutter_floating_map_marker_titles_core/view/abstract_map_view_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latlong;

class GoogleMapWithFMTO extends AbstractMapViewWrapper<_GoogleMapMVI> {
  final CameraPosition _initialCameraPosition;
  final MapCreatedCallback _onMapCreated;
  final Set<Factory<OneSequenceGestureRecognizer>> _gestureRecognizers;
  final bool _compassEnabled;
  final bool _mapToolbarEnabled;
  final CameraTargetBounds _cameraTargetBounds;
  final MapType _mapType;
  final MinMaxZoomPreference _minMaxZoomPreference;
  final bool _rotateGesturesEnabled;
  final bool _scrollGesturesEnabled;
  final bool _zoomControlsEnabled;
  final bool _zoomGesturesEnabled;
  final bool _liteModeEnabled;
  final bool _tiltGesturesEnabled;
  final EdgeInsets _padding;
  final Set<Marker> _markers;
  final Set<Polygon> _polygons;
  final Set<Polyline> _polylines;
  final Set<Circle> _circles;
  final VoidCallback _onCameraMoveStarted;
  final CameraPositionCallback _onCameraMove;
  final VoidCallback _onCameraIdle;
  final ArgumentCallback<LatLng> _onTap;
  final ArgumentCallback<LatLng> _onLongPress;
  final bool _myLocationEnabled;
  final bool _myLocationButtonEnabled;
  final bool _indoorViewEnabled;
  final bool _trafficEnabled;
  final bool _buildingsEnabled;

  factory GoogleMapWithFMTO(
    final List<FloatingMarkerTitleInfo> floatingTitles, {
    final FMTOOptions fmtoOptions,
    final Key key,
    @required final CameraPosition initialCameraPosition,
    final MapCreatedCallback onMapCreated,
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
    final bool compassEnabled = true,
    final bool mapToolbarEnabled = true,
    final CameraTargetBounds cameraTargetBounds = CameraTargetBounds.unbounded,
    final MapType mapType = MapType.normal,
    final MinMaxZoomPreference minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    final bool rotateGesturesEnabled = true,
    final bool scrollGesturesEnabled = true,
    final bool zoomControlsEnabled = true,
    final bool zoomGesturesEnabled = true,
    final bool liteModeEnabled = false,
    final bool tiltGesturesEnabled = true,
    final EdgeInsets padding = const EdgeInsets.all(0),
    final Set<Marker> markers,
    final Set<Polygon> polygons,
    final Set<Polyline> polylines,
    final Set<Circle> circles,
    final VoidCallback onCameraMoveStarted,
    final CameraPositionCallback onCameraMove,
    final VoidCallback onCameraIdle,
    final ArgumentCallback<LatLng> onTap,
    final ArgumentCallback<LatLng> onLongPress,
    final bool myLocationEnabled,
    final bool myLocationButtonEnabled,
    final bool indoorViewEnabled,
    final bool trafficEnabled,
    final bool buildingsEnabled,
  }) {
    return GoogleMapWithFMTO._internal(
      _GoogleMapMVI(fmtoOptions.mapProjectionsCacheSize),
      floatingTitles,
      fmtoOptions,
      key,
      initialCameraPosition,
      onMapCreated,
      gestureRecognizers,
      compassEnabled,
      mapToolbarEnabled,
      cameraTargetBounds,
      mapType,
      minMaxZoomPreference,
      rotateGesturesEnabled,
      scrollGesturesEnabled,
      zoomControlsEnabled,
      zoomGesturesEnabled,
      liteModeEnabled,
      tiltGesturesEnabled,
      padding,
      markers,
      polygons,
      polylines,
      circles,
      onCameraMoveStarted,
      onCameraMove,
      onCameraIdle,
      onTap,
      onLongPress,
      myLocationEnabled,
      myLocationButtonEnabled,
      indoorViewEnabled,
      trafficEnabled,
      buildingsEnabled,
    );
  }

  GoogleMapWithFMTO._internal(
    final _GoogleMapMVI mapViewInterface,
    final List<FloatingMarkerTitleInfo> floatingTitles,
    final FMTOOptions fmtoOptions,
    final Key key,
    this._initialCameraPosition,
    this._onMapCreated,
    this._gestureRecognizers,
    this._compassEnabled,
    this._mapToolbarEnabled,
    this._cameraTargetBounds,
    this._mapType,
    this._minMaxZoomPreference,
    this._rotateGesturesEnabled,
    this._scrollGesturesEnabled,
    this._zoomControlsEnabled,
    this._zoomGesturesEnabled,
    this._liteModeEnabled,
    this._tiltGesturesEnabled,
    this._padding,
    this._markers,
    this._polygons,
    this._polylines,
    this._circles,
    this._onCameraMoveStarted,
    this._onCameraMove,
    this._onCameraIdle,
    this._onTap,
    this._onLongPress,
    this._myLocationEnabled,
    this._myLocationButtonEnabled,
    this._indoorViewEnabled,
    this._trafficEnabled,
    this._buildingsEnabled,
  ) : super(
          mapViewInterface,
          floatingTitles,
          fmtoOptions,
          key: key,
        ) {
    mapViewInterface.cameraPosition = this._initialCameraPosition;
  }

  @override
  Widget buildMapView(final BuildContext context, final _GoogleMapMVI mapViewInterface) {
    return GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: _onMapCreated,
      gestureRecognizers: _gestureRecognizers,
      compassEnabled: _compassEnabled,
      mapToolbarEnabled: _mapToolbarEnabled,
      cameraTargetBounds: _cameraTargetBounds,
      mapType: _mapType,
      minMaxZoomPreference: _minMaxZoomPreference,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      zoomControlsEnabled: _zoomControlsEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      liteModeEnabled: _liteModeEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationButtonEnabled: _myLocationButtonEnabled,
      padding: _padding,
      indoorViewEnabled: _indoorViewEnabled,
      trafficEnabled: _trafficEnabled,
      buildingsEnabled: _buildingsEnabled,
      markers: _markers,
      polygons: _polygons,
      polylines: _polylines,
      circles: _circles,
      onCameraMoveStarted: _onCameraMoveStarted,
      onCameraMove: (final CameraPosition newPosition) {
        if (_onCameraMove != null) {
          _onCameraMove(newPosition);
        }
        mapViewInterface.cameraPosition = newPosition;
      },
      onCameraIdle: _onCameraIdle,
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }
}

class _GoogleMapMVI extends AbstractCZRMapViewInterface {
  CameraPosition cameraPosition;

  _GoogleMapMVI(final int projCacheSize) : super(projCacheSize);

  @override
  latlong.LatLng getMapViewCenter() {
    if (cameraPosition == null ||
        cameraPosition.target == null ||
        cameraPosition.target.latitude.isNaN ||
        cameraPosition.target.longitude.isNaN) {
      return latlong.LatLng(0, 0);
    }
    return latlong.LatLng(
      cameraPosition.target.latitude,
      cameraPosition.target.longitude,
    );
  }

  @override
  double getMapViewZoom() {
    if (cameraPosition == null || cameraPosition.zoom.isNaN) {
      return 1;
    }
    return cameraPosition.zoom;
  }

  @override
  double getMapViewRotationDegrees() {
    if (cameraPosition == null || cameraPosition.bearing.isNaN) {
      return 0;
    }
    return -cameraPosition.bearing;
  }
}
