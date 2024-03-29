import 'package:flutter/material.dart';

import 'package:flutter_floating_map_marker_titles_demo/assets/demo_data.dart' as demo_data;
import 'package:flutter_floating_map_marker_titles_demo/pages/flutter_map/flutter_map_with_layer.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/flutter_map/flutter_map_wrapped_data.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/flutter_map/flutter_map_wrapped_streams.dart';
import 'package:flutter_floating_map_marker_titles_demo/pages/google_maps/google_maps.dart';

void main() {
  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: demo_data.APP_TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FlutterMapLayerDemoPage(),
      routes: <String, WidgetBuilder>{
        FlutterMapLayerDemoPage.route: (context) => FlutterMapLayerDemoPage(),
        FlutterMapDWrapperDemoPage.route: (context) => FlutterMapDWrapperDemoPage(),
        FlutterMapSWrapperDemoPage.route: ((context) => FlutterMapSWrapperDemoPage()),
        GoogleMapsDemoPage.route: (context) => GoogleMapsDemoPage(),
      },
    );
  }
}
