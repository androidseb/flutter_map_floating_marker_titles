import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:flutter_floating_map_marker_titles_demo/drawer/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_floating_map_marker_titles_demo/assets/demo_data.dart' as demo_data;

abstract class AbstractDemoPage<M> extends StatefulWidget {
  AbstractDemoPage({final Key key}) : super(key: key);
  @override
  AbstractDemoPageState<M> createState();
}

abstract class AbstractDemoPageState<M> extends State<AbstractDemoPage<M>> {
  final List<M> markers = [];
  final List<FloatingMarkerTitleInfo> floatingTitles = [];

  M createMarker(final LatLng latLng);

  String getTitleText();

  String getHelpMessageText();

  String getPageRouteString();

  Widget buildMapWidget(final BuildContext context, final Function(LatLng) createNewMarkerCallback);

  FMTOOptions createFMTOOptions() {
    // You can specify the Floating Marker Titles Overlay options here
    return FMTOOptions();
  }

  void _addMarker(final LatLng latLng) {
    setState(() {
      markers.add(createMarker(latLng));
      floatingTitles.add(FloatingMarkerTitleInfo(
        id: floatingTitles.length + 1,
        latLng: latLng,
        title: demo_data.MARKER_NAMES[floatingTitles.length % demo_data.MARKER_NAMES.length] +
            ' ${floatingTitles.length + 1}',
        color: demo_data.COLORS[floatingTitles.length % demo_data.COLORS.length],
        zIndex: floatingTitles.length + 1,
      ));
    });
  }

  Future<void> _showHelpMessageDialog(final BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTitleText()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(getHelpMessageText()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(demo_data.OK_BUTTON_TEXT),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTitleText()),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              _showHelpMessageDialog(context);
            },
          )
        ],
      ),
      drawer: buildDrawer(context, getPageRouteString()),
      body: buildMapWidget(context, (final LatLng newMarkerLatLng) {
        _addMarker(newMarkerLatLng);
      }),
    );
  }
}
