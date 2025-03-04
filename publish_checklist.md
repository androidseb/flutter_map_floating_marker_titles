# Publish checklist

This is just a cheat sheet for me when I publish a new library version for the following library folders:
* `flutter_floating_map_marker_titles_core`
* `flutter_map_floating_marker_titles`
* `google_maps_flutter_floating_marker_titles`

These steps are based on the [official documentation](https://flutter.dev/docs/development/packages-and-plugins/developing-packages).

**Publishing steps:**

* Branch off main with a temporary branch (e.g. "version/2025.03.04")
* Update the version in `pubspec.yaml`
* Update the changelog file `CHANGELOG.md` documenting the changes of that new version
* Test the publishing with this command: `flutter pub publish --dry-run`
* Actually publish with this command: `flutter pub publish`
* Tag the version with git:
    * core library: `git tag -a "core_v1.1.0" -m "core_v1.1.0"`
    * flutter_map plugin: `git tag -a "fm_v1.2.0" -m "fm_v1.2.0"`
    * google_maps_flutter plugin: `git tag -a "gm_v1.1.0" -m "gm_v1.1.0"`
* Merge the temporary branch back into main
* Delete the temporary branch
