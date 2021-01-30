import 'package:flutter/widgets.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';

class FlutterMapFloatingMarkerTitlesOverlayLayer extends StatelessWidget {
  final FMTOController _fmtoController;
  final bool transparentTitles;
  FlutterMapFloatingMarkerTitlesOverlayLayer(
    this._fmtoController, {
    this.transparentTitles = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: CustomPaint(
        foregroundPainter: _FloatingMarkersTitlesPainter(
          _fmtoController,
          _FMTPainterNotifier(),
          this.transparentTitles,
        ),
      ),
    );
  }
}

class _FMTPainterNotifier extends ChangeNotifier {
  triggerRepaint() {
    notifyListeners();
  }
}

class _FloatingMarkersTitlesPainter extends CustomPainter {
  final _FMTPainterNotifier _changeNotifier;
  final FMTOController _fmtoController;
  final bool _transparentTitles;

  _FloatingMarkersTitlesPainter(
    this._fmtoController,
    final _FMTPainterNotifier changeNotifier,
    final bool transparentTitles,
  )   : _changeNotifier = changeNotifier,
        _transparentTitles = transparentTitles,
        super(repaint: changeNotifier) {
    if (!_transparentTitles) {
      _repaintForever();
    }
  }

  void _repaintForever() async {
    while (true) {
      await Future.delayed(Duration(
        milliseconds: this._fmtoController.fmtoOptions.repaintIntervalMillis,
      ));
      _changeNotifier.triggerRepaint();
    }
  }

  @override
  void paint(final Canvas canvas, final Size size) {
    if (size != null && size.width > 0 && size.height > 0) {
      // This call to clipRect is necessary to make sure the drawing doesn't happen over other views
      canvas.clipRect(Rect.fromLTRB(
        0,
        0,
        size.width,
        size.height,
      ));
    }
    _fmtoController.paintFloatingMarkerTitles(
      canvas,
      size,
      _transparentTitles,
    );
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) {
    return true;
  }
}
