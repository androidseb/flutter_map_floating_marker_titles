import 'package:flutter/widgets.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_map_view_interface.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:flutter_floating_map_marker_titles_core/view/floating_marker_titles_overlay_layer.dart';

class FlutterMapFloatingMarkerTitlesOverlay extends StatefulWidget {
  final FMTOController _fmtoController;

  FlutterMapFloatingMarkerTitlesOverlay(
    final AbstractMapViewInterface mapViewInterface,
    final List<FloatingMarkerTitleInfo> floatingTitles,
    final FMTOOptions fmtoOptions, {
    final Key? key,
  })  : _fmtoController = FMTOController(
          mapViewInterface,
          floatingTitles,
          fmtoOptions,
        ),
        super(key: key);

  @override
  _FlutterMapFloatingMarkerTitlesOverlayState createState() => _FlutterMapFloatingMarkerTitlesOverlayState();
}

class _FlutterMapFloatingMarkerTitlesOverlayState extends State<FlutterMapFloatingMarkerTitlesOverlay> {
  @override
  void didUpdateWidget(covariant FlutterMapFloatingMarkerTitlesOverlay oldWidget) {
    widget._fmtoController.updateFrom(oldWidget._fmtoController);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        FlutterMapFloatingMarkerTitlesOverlayLayer(
          widget._fmtoController,
        ),
        _FMTOTransparentTitlesLayerWrapper(widget._fmtoController),
      ],
    );
  }
}

class _FMTOTransparentTitlesLayerWrapper extends StatefulWidget {
  final FMTOController _fmtoController;

  const _FMTOTransparentTitlesLayerWrapper(
    this._fmtoController, {
    final Key? key,
  }) : super(key: key);

  @override
  _FMTOTransparentTitlesLayerWrapperState createState() => _FMTOTransparentTitlesLayerWrapperState();
}

class _FMTOTransparentTitlesLayerWrapperState extends State<_FMTOTransparentTitlesLayerWrapper> {
  double _transparentTitlesOpacity = 0;

  @override
  Widget build(final BuildContext context) {
    widget._fmtoController.setOnTransparentTitlesOpacityChanged((final double transparentTitlesOpacity) {
      Future.delayed(Duration.zero, () {
        setState(() {
          _transparentTitlesOpacity = transparentTitlesOpacity;
        });
      });
    });
    return Opacity(
      opacity: _transparentTitlesOpacity,
      child: FlutterMapFloatingMarkerTitlesOverlayLayer(
        widget._fmtoController,
        transparentTitles: true,
      ),
    );
  }
}
