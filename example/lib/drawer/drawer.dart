import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/flutter_map/flutter_map_with_layer.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/flutter_map/flutter_map_wrapped_data.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/flutter_map/flutter_map_wrapped_streams.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/google_maps/google_maps.dart';
import 'package:flutter_floating_map_marker_titles_demo/assets/demo_data.dart' as demo_data;

Widget _buildMenuItem(final BuildContext context, final String routeName, final String currentRoute) {
  bool isSelected = routeName == currentRoute;

  return ListTile(
    title: Text(routeName),
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(final BuildContext context, final String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text(demo_data.APP_TITLE),
          ),
        ),
        _buildMenuItem(
          context,
          FlutterMapLayerDemoPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          FlutterMapDWrapperDemoPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          FlutterMapSWrapperDemoPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          GoogleMapsDemoPage.route,
          currentRoute,
        ),
      ],
    ),
  );
}
