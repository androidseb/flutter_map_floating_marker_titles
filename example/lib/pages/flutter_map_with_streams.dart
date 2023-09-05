import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/abstract_flutter_map_demo_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_floating_marker_titles/flutter_map_floating_marker_titles.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_floating_map_marker_titles_demo/assets/demo_data.dart' as demo_data;
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';

class FlutterMapWithStreamsDemoPage extends AbstractFlutterMapDemoPage {
  static const String route = 'Flutter Map with streams';

  FlutterMapWithStreamsDemoPage({final Key? key}) : super(key: key);
  @override
  _FlutterMapWithStreamsDemoPageState createState() => _FlutterMapWithStreamsDemoPageState();
}

class _FlutterMapWithStreamsDemoPageState extends AbstractFlutterMapDemoPageState {
  final StreamController<List<FloatingMarkerTitleInfo>> _floatingTitlesSC = StreamController();
  final StreamController<List<Marker>> _markersSC = StreamController();

  @override
  void addMarker(LatLng latLng) {
    addMarkerToData(latLng);
    _markersSC.add(markers);
    _floatingTitlesSC.add(floatingTitles);
  }

  @override
  Widget buildMapWidget(final BuildContext context, final Function(LatLng) createNewMarkerCallback) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Row(
            children: [
              Text(demo_data.ROTATION_LABEL_TEXT),
              Flexible(
                child: Slider(
                  value: currentRotation,
                  min: 0,
                  max: 360,
                  onChanged: (final double newRotationValue) {
                    mapController.rotate(newRotationValue);
                    setState(() {
                      currentRotation = newRotationValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: FlutterMapWithFMTO(
            floatingTitlesStream: _floatingTitlesSC.stream,
            floatingTitles: floatingTitles,
            fmtoOptions: createFMTOOptions(),
            mapController: mapController,
            options: MapOptions(
              initialCenter: demo_data.INITIAL_MAP_LOCATION,
              initialZoom: demo_data.INITIAL_MAP_ZOOM,
              onTap: (final TapPosition tapPosition, final LatLng latLng) {
                createNewMarkerCallback(latLng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.flutter_map_floating_marker_titles.example',
              ),
              StreamBuilder(
                stream: _markersSC.stream,
                builder: (context, snapshot) {
                  return MarkerLayer(
                    markers: markers,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  String getTitleText() {
    return demo_data.FLUTTER_MAP_PAGE_TITLE;
  }

  @override
  String getHelpMessageText() {
    return demo_data.FLUTTER_MAP_HELP_DIALOG_MESSAGE;
  }

  @override
  String getPageRouteString() {
    return FlutterMapWithStreamsDemoPage.route;
  }
}
