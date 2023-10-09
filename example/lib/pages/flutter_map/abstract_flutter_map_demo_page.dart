import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/abstract_demo_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_floating_map_marker_titles_demo/assets/demo_data.dart' as demo_data;
import 'package:flutter_map/src/gestures/positioned_tap_detector_2.dart';

abstract class AbstractFlutterMapDemoPage extends AbstractDemoPage<Marker> {
  AbstractFlutterMapDemoPage({final Key? key}) : super(key: key);
}

abstract class AbstractFlutterMapDemoPageState extends AbstractDemoPageState<Marker> {
  final MapController mapController = MapController();
  double currentRotation = 0;

  @override
  String getHelpMessageText() {
    return demo_data.FLUTTER_MAP_HELP_DIALOG_MESSAGE;
  }

  @override
  Marker createMarker(final LatLng latLng) {
    return Marker(
      point: latLng,
      width: 14,
      height: 20,
      alignment: Alignment.topCenter,
      rotate: true,
      child: Container(
        child: Image.asset(
          demo_data.MARKER_ICON_ASSET_PATH,
          fit: BoxFit.fitHeight,
          width: 28,
          height: 40,
        ),
      ),
    );
  }

  @nonVirtual
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
          child: buildMapWidgetImpl(
            context,
            MapOptions(
              initialCenter: demo_data.INITIAL_MAP_LOCATION,
              initialZoom: demo_data.INITIAL_MAP_ZOOM,
              onTap: (final TapPosition tapPosition, final LatLng latLng) {
                createNewMarkerCallback(latLng);
              },
            ),
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.flutter_map_floating_marker_titles.example',
            ),
            createNewMarkerCallback,
          ),
        ),
      ],
    );
  }

  @protected
  Widget buildMapWidgetImpl(
    final BuildContext context,
    final MapOptions mapOptions,
    final Widget backgroundLayer,
    final Function(LatLng) createNewMarkerCallback,
  );
}
