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
