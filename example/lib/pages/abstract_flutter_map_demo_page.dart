import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/abstract_demo_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_floating_marker_titles/flutter_map_floating_marker_titles.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_floating_map_marker_titles_demo/assets/demo_data.dart' as demo_data;

abstract class AbstractFlutterMapDemoPage extends AbstractDemoPage<Marker> {
  AbstractFlutterMapDemoPage({final Key? key}) : super(key: key);
}

abstract class AbstractFlutterMapDemoPageState extends AbstractDemoPageState<Marker> {
  final FMTOMapController mapController = FMTOMapController();
  double currentRotation = 0;

  @override
  Marker createMarker(final LatLng latLng) {
    return Marker(
      point: latLng,
      width: 14,
      height: 20,
      anchorPos: AnchorPos.align(AnchorAlign.top),
      rotate: true,
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
}
