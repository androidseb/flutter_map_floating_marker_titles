part of 'flutter_map_floating_marker_titles.dart';

/// Copy/pasted from the "MapControllerImpl" class at
/// flutter_map-5.0.0/lib/src/map/controller.dart
/// with a single change: the constructor is not private so that it can be overriden
class _MapControllerImpl implements MapController{
  // Commented out this part from the copy/paste
  // MapControllerImpl._();

  @override
  bool move(
    LatLng center,
    double zoom, {
    Offset offset = Offset.zero,
    String? id,
  }) =>
      _state.move(
        center,
        zoom,
        offset: offset,
        id: id,
        source: MapEventSource.mapController,
      );

  @override
  bool rotate(double degree, {String? id}) =>
      _state.rotate(degree, id: id, source: MapEventSource.mapController);

  @override
  MoveAndRotateResult rotateAroundPoint(
    double degree, {
    CustomPoint<double>? point,
    Offset? offset,
    String? id,
  }) =>
      _state.rotateAroundPoint(
        degree,
        point: point,
        offset: offset,
        id: id,
        source: MapEventSource.mapController,
      );

  @override
  MoveAndRotateResult moveAndRotate(
    LatLng center,
    double zoom,
    double degree, {
    String? id,
  }) =>
      _state.moveAndRotate(
        center,
        zoom,
        degree,
        source: MapEventSource.mapController,
        id: id,
      );

  @override
  bool fitBounds(
    LatLngBounds bounds, {
    FitBoundsOptions? options =
        const FitBoundsOptions(padding: EdgeInsets.all(12)),
  }) =>
      _state.fitBounds(bounds, options!);

  @override
  CenterZoom centerZoomFitBounds(
    LatLngBounds bounds, {
    FitBoundsOptions? options =
        const FitBoundsOptions(padding: EdgeInsets.all(12)),
  }) =>
      _state.centerZoomFitBounds(bounds, options!);

  @override
  LatLng pointToLatLng(CustomPoint localPoint) =>
      _state.pointToLatLng(localPoint);

  @override
  CustomPoint<double> latLngToScreenPoint(LatLng latLng) =>
      _state.latLngToScreenPoint(latLng);

  @override
  CustomPoint<double> rotatePoint(
    CustomPoint mapCenter,
    CustomPoint point, {
    bool counterRotation = true,
  }) =>
      _state.rotatePoint(
        mapCenter.toDoublePoint(),
        point.toDoublePoint(),
        counterRotation: counterRotation,
      );

  @override
  LatLng get center => _state.center;

  @override
  LatLngBounds? get bounds => _state.bounds;

  @override
  double get zoom => _state.zoom;

  @override
  double get rotation => _state.rotation;

  final _mapEventStreamController = StreamController<MapEvent>.broadcast();

  @override
  Stream<MapEvent> get mapEventStream => _mapEventStreamController.stream;

  @override
  StreamSink<MapEvent> get mapEventSink => _mapEventStreamController.sink;

  late FlutterMapState _state;

  @override
  set state(FlutterMapState state) {
    _state = state;
  }

  @override
  void dispose() {
    _mapEventStreamController.close();
  }
}
