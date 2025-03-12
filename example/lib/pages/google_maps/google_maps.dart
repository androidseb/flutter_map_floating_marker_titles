import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_floating_map_marker_titles_demo/assets/demo_data.dart' as demo_data;
import 'package:flutter_floating_map_marker_titles_demo/pages/abstract_demo_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_floating_marker_titles/google_maps_flutter_floating_marker_titles.dart';
import 'package:latlong2/latlong.dart' as latlong;

class GoogleMapsDemoPage extends AbstractDemoPage<Marker> {
  static const String route = 'Google Maps';

  GoogleMapsDemoPage({final Key? key}) : super(key: key);
  @override
  _GoogleMapsDemoPageState createState() => _GoogleMapsDemoPageState();
}

int markerId = 0;

class _GoogleMapsDemoPageState extends AbstractDemoPageState<Marker> {
  BitmapDescriptor? _markerIcon;

  BitmapDescriptor createBitmapDescriptorFromBytes(Uint8List bytes) {
    // Note that the correct non-deprecated code should be:
    // return BitmapDescriptor.bytes(
    //   bytes,
    //   bitmapScaling: MapBitmapScaling.none,
    // );
    // However at the current time, bitmapScaling is not working on iOS, so we
    // are using the deprecated method instead which works for both Android and iOS.
    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<void> _createMarkerImageFromAsset(final BuildContext context) async {
    if (_markerIcon == null) {
      final bytes = Uint8List.sublistView(await rootBundle.load(demo_data.MARKER_ICON_ASSET_PATH));
      final BitmapDescriptor bitmapDescriptor = createBitmapDescriptorFromBytes(bytes);
      _updateBitmap(bitmapDescriptor);
    }
  }

  void _updateBitmap(final BitmapDescriptor bitmap) {
    setState(() {
      _markerIcon = bitmap;
    });
  }

  @override
  Widget buildMapWidget(final BuildContext context, final Function(latlong.LatLng) createNewMarkerCallback) {
    _createMarkerImageFromAsset(context);
    return Column(
      children: [
        Flexible(
          child: GoogleMapWithFMTO(
            floatingTitles: floatingTitles,
            fmtoOptions: createFMTOOptions(),
            initialCameraPosition: CameraPosition(
              target: LatLng(
                demo_data.INITIAL_MAP_LOCATION.latitude,
                demo_data.INITIAL_MAP_LOCATION.longitude,
              ),
              zoom: demo_data.INITIAL_MAP_ZOOM,
            ),
            onTap: (final LatLng latLng) {
              createNewMarkerCallback(latlong.LatLng(latLng.latitude, latLng.longitude));
            },
            markers: _buildMarkersSet(),
          ),
        ),
      ],
    );
  }

  Set<Marker> _buildMarkersSet() {
    final Set<Marker> res = {};
    res.addAll(markers);
    return res;
  }

  @override
  Marker createMarker(final latlong.LatLng latLng) {
    return Marker(
      markerId: MarkerId('${markerId++}'),
      position: LatLng(latLng.latitude, latLng.longitude),
      icon: _markerIcon!,
    );
  }

  @override
  String getTitleText() {
    return GoogleMapsDemoPage.route;
  }

  @override
  String getHelpMessageText() {
    return demo_data.GOOGLE_MAPS_HELP_DIALOG_MESSAGE;
  }

  @override
  String getPageRouteString() {
    return GoogleMapsDemoPage.route;
  }
}
