## [1.1.1] - 2025/03/04

* Fixed some warnings related to color class getters

## [1.1.0] - 2024/08/10

* Fixed a bug with floating marker titles still appearing with maxTitlesCount=0 in some specific cases (e.g. using more than one z-index)

## [1.0.0] - 2023/06/22

* Updated the semantic version prefix to "officially stable" 1.X.X, because this library has been successful in a production app (see https://mapmarker.app) used by thousands of daily users for several months
* Updated latlong2 dependency to latlong2: ^0.9.0

## [0.3.0] - 2022/10/23

* Improved the logic handling the appearance for higher z-index titles

## [0.2.0] - 2022/09/15

* Added the ability to set floating marker titles with a stream with the `floatingTitlesStream` parameter

## [0.1.0] - 2022/09/02

* Changed the versioning pattern to leave the last digit for minor non-feature-related changes (e.g. library upgrades)

## [0.0.6] - 2022/06/11

Added linter rules from the [lint](https://pub.dev/packages/lint) package.

## [0.0.5+5] - 2022/01/09

Removed web-specific code working around [a bug](https://github.com/flutter/flutter/issues/46683) that has since then been fixed.

## [0.0.4+4] - 2021/11/29

Migrated to null safety.

## [0.0.3+3] - 2021/06/01

Updated dependencies to support dependent libraries.

## [0.0.2+2] - 2021/04/01

Fixed some issues with floating titles data not being updated in some cases, due to a wrong widget state setup.

## [0.0.1+1] - 2021/01/30

This is the initial release of the library.

* Floating Map Marker Titles
* Titles overlap detection
* Titles automatic outline based on color
* Titles fade-in animation
* Overlay customization options
    * Paint time interval
    * Text size
    * Text width
    * Text max lines
    * Text painting cache size
    * Coordinates cache size
    * Number of titles to check per frame
    * Fade-in animation time
    * Title placement policy
* Title customization options
    * Color
    * Bold
    * Z-index
