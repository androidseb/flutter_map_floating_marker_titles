# Flutter Map Floating Map Marker Titles

Floating Map Marker Titles for [flutter_map](https://github.com/fleaflet/flutter_map), using the core library of the [Flutter Floating Map Marker Titles](https://github.com/androidseb/flutter_map_floating_marker_titles) project.

## Code example

```dart
// With the FlutterMapWithFMTO widget as a FlutterMap wrapper
FlutterMapWithFMTO(
  floatingTitles: floatingTitles,
  fmtoOptions: fmtoOptions,
  // ... other than the 2 above option, this widget takes
  // exactly the same props as the FlutterMap widget.
  options: MapOptions(
    center: LatLng(0, 0),
    zoom: 13,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    ),
  ],
)

// Or with the FloatingMarkerTitlesLayer widget as a FlutterMap layer
FlutterMap(
  options: MapOptions(
    center: LatLng(0, 0),
    zoom: 13,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    ),
    FloatingMarkerTitlesLayer(
      floatingTitles: floatingTitles,
      fmtoOptions: fmtoOptions,
    ),
  ],
)
```

See the [how-to](https://github.com/androidseb/flutter_map_floating_marker_titles#how-to-use-this-library-in-your-code) section of the main project for more details.
