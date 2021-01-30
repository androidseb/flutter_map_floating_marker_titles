import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/flutter_map.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/google_maps.dart';
import 'package:flutter_floating_map_marker_titles_demo/assets/demo_data.dart' as demo_data;

Widget _buildMenuItem(
    final BuildContext context, final Widget title, final String routeName, final String currentRoute) {
  bool isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
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
          const Text(demo_data.FLUTTER_MAP_PAGE_TITLE),
          FlutterMapDemoPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text(demo_data.GOOGLE_MAPS_PAGE_TITLE),
          GoogleMapsDemoPage.route,
          currentRoute,
        ),
      ],
    ),
  );
}
