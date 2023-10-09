import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/flutter_map/abstract_flutter_map_demo_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_floating_marker_titles/flutter_map_floating_marker_titles.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';

class FlutterMapSWrapperDemoPage extends AbstractFlutterMapDemoPage {
  static const String route = 'Flutter Map - Wrapper + Stream';

  FlutterMapSWrapperDemoPage({final Key? key}) : super(key: key);
  @override
  _FlutterMapSWrapperDemoPageState createState() => _FlutterMapSWrapperDemoPageState();
}

class _FlutterMapSWrapperDemoPageState extends AbstractFlutterMapDemoPageState {
  final StreamController<List<FloatingMarkerTitleInfo>> _floatingTitlesSC = StreamController();
  final StreamController<List<Marker>> _markersSC = StreamController();

  @override
  void addMarker(LatLng latLng) {
    addMarkerToData(latLng);
    _markersSC.add(markers);
    _floatingTitlesSC.add(floatingTitles);
  }

  @override
  String getTitleText() {
    return FlutterMapSWrapperDemoPage.route;
  }

  @override
  String getPageRouteString() {
    return FlutterMapSWrapperDemoPage.route;
  }

  @override
  Widget buildMapWidgetImpl(
    final BuildContext context,
    final MapOptions mapOptions,
    final Widget backgroundLayer,
    final Function(LatLng) createNewMarkerCallback,
  ) {
    return FlutterMapWithFMTO(
      floatingTitlesStream: _floatingTitlesSC.stream,
      floatingTitles: floatingTitles,
      fmtoOptions: createFMTOOptions(),
      mapController: mapController,
      options: mapOptions,
      children: [
        backgroundLayer,
        StreamBuilder(
          stream: _markersSC.stream,
          builder: (context, snapshot) {
            return MarkerLayer(
              markers: markers,
            );
          },
        ),
      ],
    );
  }
}
