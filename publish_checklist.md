# Publish checklist

This is just a cheat sheet for me when I publish a new library version for the following library folders:
* `flutter_floating_map_marker_titles_core`
* `flutter_map_floating_marker_titles`
* `google_maps_flutter_floating_marker_titles`

These steps are based on the [official documentation](https://flutter.dev/docs/development/packages-and-plugins/developing-packages).

**Publishing steps:**

* Update the version in `pubspec.yaml`
* Update the changelog file `CHANGELOG.md` documenting the changes of that new version
* Test the publishing with this command: `flutter pub publish --dry-run`
* Actually publish with this command: `flutter pub publish`
