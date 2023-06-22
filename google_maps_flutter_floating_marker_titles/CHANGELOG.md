## [1.0.0] - 2023/06/22

* Updated the semantic version prefix to "officially stable" 1.X.X, because this library has been successful in a production app (see https://mapmarker.app) used by thousands of daily users for several months
* Updated latlong2 dependency to latlong2: ^0.9.0

## [0.3.0] - 2022/10/23

* Improved the logic handling the appearance for higher z-index titles

## [0.2.0] - 2022/09/15

* Added the ability to set floating marker titles with a stream with the `floatingTitlesStream` parameter
* Updated dependencies to use google_maps_flutter: ^2.2.0

## [0.1.0] - 2022/09/02

* Changed the versioning pattern to leave the last digit for minor non-feature-related changes (e.g. library upgrades)

## [0.0.6] - 2022/06/11

Fixed titles being placed incorrectly when the map is rotated.

## [0.0.5+5] - 2022/01/09

Removed web-specific code working around [a bug](https://github.com/flutter/flutter/issues/46683) that has since then been fixed.

## [0.0.4+4] - 2021/11/29

Migrated to null safety.

## [0.0.3+3] - 2021/06/01

Updated dependencies to use google_maps_flutter: ^2.0.4

## [0.0.2+2] - 2021/04/01

Fixed some issues with floating titles data not being updated in some cases, due to a wrong widget state setup.

## [0.0.1+1] - 2021/01/30

This is the initial release of the library.

* Support for floating map marker titles on google_maps_flutter
