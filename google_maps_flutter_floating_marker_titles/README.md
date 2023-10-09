# Flutter Map Floating Map Marker Titles

Floating Map Marker Titles for [google_maps_flutter](https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter/google_maps_flutter), using the core library of the [Flutter Floating Map Marker Titles](https://github.com/androidseb/flutter_map_floating_marker_titles) project.

## Code example

```dart
GoogleMapWithFMTO(
  floatingTitles,
  fmtoOptions: fmtoOptions,
  // ... other than the 2 above option, this widget takes
  // exactly the same props as the GoogleMap widget.
  initialCameraPosition: CameraPosition(
    target: LatLng(0, 0),
    zoom: 13,
  ),
)
```

See the [how-to](https://github.com/androidseb/flutter_map_floating_marker_titles#how-to-use-this-library-in-your-code) section of the main project for more details.
