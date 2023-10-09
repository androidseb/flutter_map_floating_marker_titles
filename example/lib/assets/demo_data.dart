import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

const String APP_TITLE = 'Floating markers demo';
const String FLUTTER_MAP_HELP_DIALOG_MESSAGE = '''
You can tap on the map to add markers with floating titles.
You can use the slider at the top to rotate the map too.
This example uses the 'fleaflet' flutter library to display the map.
''';
const String GOOGLE_MAPS_HELP_DIALOG_MESSAGE = '''
You can tap on the map to add markers with floating titles.
You can use the pinch gesture to rotate the map too.
This example uses the 'google_maps_flutter' flutter library to display the map.
''';
const String OK_BUTTON_TEXT = 'OK';
const String ROTATION_LABEL_TEXT = 'Rotation';
// ignore: non_constant_identifier_names
LatLng INITIAL_MAP_LOCATION = LatLng(47.2378, 6.0241);
const double INITIAL_MAP_ZOOM = 13.0;
const String MARKER_ICON_ASSET_PATH = 'lib/assets/images/marker.png';
const List<Color> COLORS = [
  Colors.amber,
  Colors.blue,
  Colors.blueGrey,
  Colors.brown,
  Colors.cyan,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.green,
  Colors.grey,
  Colors.indigo,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.lime,
  Colors.orange,
  Colors.pink,
  Colors.purple,
  Colors.red,
  Colors.teal,
  Colors.yellow,
  Colors.black,
  Colors.white,
];
const List<String> MARKER_NAMES = [
  'Marker',
  'A marker with a moderately long name',
  'A marker with a somewhat long long long long long long long long name',
  'A marker with a very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very long name',
  'Some marker',
  'Some other marker',
  'Bakery',
  'A',
  'B',
  'Restaurant',
  'Some lake',
];
