import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/abstract_demo_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_floating_marker_titles/flutter_map_floating_marker_titles.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_floating_map_marker_titles_demo/assets/demo_data.dart' as demo_data;
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';

class FlutterMapWithStreamsDemoPage extends AbstractDemoPage<Marker> {
  static const String route = 'Flutter Map with streams';

  FlutterMapWithStreamsDemoPage({final Key? key}) : super(key: key);
  @override
  _FlutterMapWithStreamsDemoPageState createState() => _FlutterMapWithStreamsDemoPageState();
}

class _FlutterMapWithStreamsDemoPageState extends AbstractDemoPageState<Marker> {
  final FMTOMapController mapController = FMTOMapController();
  final StreamController<List<FloatingMarkerTitleInfo>> _floatingTitlesSC = StreamController();
  final StreamController<List<Marker>> _markersSC = StreamController();
  double currentRotation = 0;

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
            fmtoOptions: createFMTOOptions(),
            mapController: mapController,
            options: MapOptions(
              center: demo_data.INITIAL_MAP_LOCATION,
              zoom: demo_data.INITIAL_MAP_ZOOM,
              onTap: (final TapPosition tapPosition, final LatLng latLng) {
                createNewMarkerCallback(latLng);
              },
            ),
            children: [
              TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
              ),
              StreamBuilder(
                stream: _markersSC.stream,
                builder: (context, snapshot) {
                  return MarkerLayerWidget(
                    options: MarkerLayerOptions(markers: markers),
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
  Marker createMarker(final LatLng latLng) {
    return Marker(
      point: latLng,
      width: 14,
      height: 20,
      anchorPos: AnchorPos.align(AnchorAlign.top),
      builder: (ctx) => Container(
        child: Image.asset(
          demo_data.MARKER_ICON_ASSET_PATH,
          fit: BoxFit.fitHeight,
          width: 28,
          height: 40,
        ),
      ),
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
