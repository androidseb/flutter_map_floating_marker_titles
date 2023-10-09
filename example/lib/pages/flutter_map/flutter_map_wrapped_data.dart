import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/flutter_map/abstract_flutter_map_demo_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_floating_marker_titles/flutter_map_floating_marker_titles.dart';
import 'package:latlong2/latlong.dart';

class FlutterMapDWrapperDemoPage extends AbstractFlutterMapDemoPage {
  static const String route = 'Flutter Map - Wrapper + Data';

  FlutterMapDWrapperDemoPage({final Key? key}) : super(key: key);
  @override
  _FlutterMapDWrapperDemoPageState createState() => _FlutterMapDWrapperDemoPageState();
}

class _FlutterMapDWrapperDemoPageState extends AbstractFlutterMapDemoPageState {
  @override
  String getTitleText() {
    return FlutterMapDWrapperDemoPage.route;
  }

  @override
  String getPageRouteString() {
    return FlutterMapDWrapperDemoPage.route;
  }

  @override
  Widget buildMapWidgetImpl(
    final BuildContext context,
    final MapOptions mapOptions,
    final Widget backgroundLayer,
    final Function(LatLng) createNewMarkerCallback,
  ) {
    return FlutterMapWithFMTO(
      floatingTitles: floatingTitles,
      fmtoOptions: createFMTOOptions(),
      mapController: mapController,
      options: mapOptions,
      children: [
        backgroundLayer,
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }
}
