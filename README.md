# Flutter Floating Map Marker Titles

This library is inspired from [android-google-maps-floating-marker-titles](https://github.com/androidseb/android-google-maps-floating-marker-titles) and aims to achieve the same thing on Flutter apps. I have built this library as an experiment to gauge how much native-like things can be achieved with Flutter, and although I'm pretty happy with the result, this library is not used on production yet.

This library is useful if you want to see the titles of the markers on the map floating next to the marker. It attempts to reproduce the behavior for labels of points of interest shown in map applications. It works as a wrapper of existing map view widgets for the following libraries:
* [Flutter Map](https://github.com/fleaflet/flutter_map)
* [Google Maps Flutter](https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter/google_maps_flutter)

## Visual Preview

This is how it looks like, from the example sample app of this library:

<img src="visual_demo.gif" height="400">

## Project structure

This project is divided into the following main folders:
* `flutter_floating_map_marker_titles_core`: the core code of the floating map marker titles library, meant to be agnostic of any map view implementation, this is the source code of the [flutter_floating_map_marker_titles_core](https://pub.dev/packages/flutter_floating_map_marker_titles_core) library
* `flutter_map_floating_marker_titles`: the code of the floating map marker titles library for [Flutter Map](https://github.com/fleaflet/flutter_map), this is the source code of the [flutter_map_floating_marker_titles](https://pub.dev/packages/flutter_map_floating_marker_titles) library
* `google_maps_flutter_floating_marker_titles`: the code of the floating map marker titles library for [Google Maps Flutter](https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter/google_maps_flutter), this is the source code of the [google_maps_flutter_floating_marker_titles](https://pub.dev/packages/google_maps_flutter_floating_marker_titles) library
* `example`: a simple example of a flutter application show-casing the use of the libraries

## Sample app setup

In the sample app, the [Flutter Map](https://github.com/fleaflet/flutter_map) example will work out of the box, but for the [Google Maps Flutter](https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter/google_maps_flutter) example to work, you will need to update the following file, based on the [Google Maps Flutter library getting started instructions](https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter/google_maps_flutter#getting-started):
* `example/android/app/src/main/AndroidManifest.xml`
* `example/ios/Runner/AppDelegate.m`

## How to use this library in your code

For a working example, see the flutter app project in the `example` folder of this repo.

### Step 1: depend on the library

Add `flutter_map_floating_marker_titles` and/or `google_maps_flutter_floating_marker_titles` to your pubspec:

```yaml
dependencies:
  flutter_map_floating_marker_titles: any # or the latest version on Pub
  google_maps_flutter_floating_marker_titles: any # or the latest version on Pub
```

### Step 2: create the FMTOOptions object

```dart
final FMTOOptions fmtoOptions = FMTOOptions();
```

### Step 3: create the list of FloatingMarkerTitleInfo items

```dart
final List<FloatingMarkerTitleInfo> floatingTitles = [];
floatingTitles.add(FloatingMarkerTitleInfo(
  id: 0,
  latLng: LatLng(0, 0),
  title: 'A floating title',
  color: Colors.green,
));
```

### Step 4a: Create the Flutter Map View

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
    TileLayerOptions(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    ),
  ],
),
```

### Step 4b: Create the Google Maps View

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
),
```

## Library features

### Overall features

* Display floating markers titles on top of the map
* Automatically avoids overlap between floating marker titles, will not display a title if overlapping with others
* Marker title text transparent outline for better visuals: the text will be readable no matter the map background and the outline color will adapt to white or black depending on the text color's luminance (perceived brightness)
* Marker title fade-in animation for better visuals

### View-wide customization options

```dart
FMTOOptions(
  // The number of milliseconds between two repaints of the titles layer. 60 frames per seconds = 16 milliseconds between each frame.
  repaintIntervalMillis: 16,
  // Titles text size
  textSize: 14.0,
  // Maximum number of floating titles
  maxTitlesCount: 30,
  // Maximum width of floating titles
  maxTitlesWidth: 150,
  // Maximum lines count of floating titles
  maxTitleLines: 2,
  // Maximum number of cached, pre-laid out, ready to draw floating titles info, since computing the layout of text is an expensive operation
  textPaintingCacheSize: 2000,
  // Maximum number of cached coordinates by the map coordinates projections calculator
  mapProjectionsCacheSize: 10000,
  // No performance drop with more markers once the maximum number of floating titles has been reached, since the library only scans for a limited number of markers per frame, which can be set with titlesToCheckPerFrame
  titlesToCheckPerFrame: 30,
  // Time in milliseconds of the title fade-in animation
  fadeInAnimationTimeMillis: 300,
  // Titles placement option with anchor and margin
  titlePlacementPolicy: const FloatingMarkerPlacementPolicy(FloatingMarkerGravity.right, 12),
);
```

### Per-title customization options

```dart
FloatingMarkerTitleInfo(
  // ID of the floating title, used by the system to track what was added/removed between two paints
  id: 0,
  // Base coordinates the title is attached to
  latLng: LatLng(0, 0),
  // The title text as a String
  title: 'The title',
  // The title base color
  color: Colors.green,
  // Whether the title text should be written in bold
  isBold: false,
  // z-index of the title to specify which title has the most priority for display in case of titles collisions
  zIndex: 1,
);
```

## Known limitations

* Does not work in web for [Google Maps Flutter](https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter/google_maps_flutter)

## About issues and/or feature requests

I am not willing to invest time to take feature requests at the moment, but if you find a bug, I'll probably want to fix it, so feel free to report any bugs you may find.

If you need a feature and want to build it and then submit it as a pull request, I'm willing to work with you to merge your work into the current code.
