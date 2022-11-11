# Flutter Map Floating Map Marker Titles

Floating Map Marker Titles for [flutter_map](https://github.com/fleaflet/flutter_map), using the core library of the [Flutter Floating Map Marker Titles](https://github.com/androidseb/flutter_map_floating_marker_titles) project.

## Code example

```dart
FlutterMapWithFMTO(
  floatingTitles,
  fmtoOptions: fmtoOptions,
  // ... other than the 2 above option, this widget takes
  // exactly the same props as the FlutterMap widget.
  options: MapOptions(
    center: LatLng(0, 0),
    zoom: 13,
  ),
  layers: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    ),
  ],
),
```

See the [how-to](https://github.com/androidseb/flutter_map_floating_marker_titles#how-to-use-this-library-in-your-code) section of the main project for more details.
