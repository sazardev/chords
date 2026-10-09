import 'package:chords/domain/chords/entities/barre_info.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:flutter/material.dart';

/// Diagrama de diapasón (posición) de un acorde.
class ChordDiagram extends StatelessWidget {
  /// Crea el diagrama.
  const ChordDiagram({
    required this.variant,
    super.key,
    this.mirror = false,
    this.showFingers = true,
    this.width = 132,
    this.height = 168,
  });

  /// Posición a dibujar.
  final ChordVariant variant;

  /// Si se invierte el diagrama para guitarristas zurdos.
  final bool mirror;

  /// Si se muestran los números de dedo.
  final bool showFingers;

  /// Ancho del diagrama.
  final double width;

  /// Alto del diagrama.
  final double height;

  @override
  Widget build(BuildContext context) => Semantics(
    label: _semanticLabel,
    child: CustomPaint(
      size: Size(width, height),
      painter: _ChordDiagramPainter(
        variant: variant,
        mirror: mirror,
        showFingers: showFingers,
        colors: chordColorsOf(context),
      ),
    ),
  );

  String get _semanticLabel {
    final List<String> parts = <String>[
      for (int s = 0; s < variant.frets.length; s++)
        'cuerda ${s + 1}: ${_fretLabel(variant.frets[s])}',
    ];
    return 'Diagrama de ${variant.positionLabel}, $parts';
  }

  String _fretLabel(int fret) => switch (fret) {
    -1 => 'muda',
    0 => 'al aire',
    final int value => 'traste $value',
  };
}

/// Pintor del diagrama de diapasón.
class _ChordDiagramPainter extends CustomPainter {
  _ChordDiagramPainter({
    required this.variant,
    required this.mirror,
    required this.showFingers,
    required this.colors,
  });

  final ChordVariant variant;
  final bool mirror;
  final bool showFingers;
  final AppChordColors colors;

  static const int _stringCount = 6;
  static const int _visibleFrets = 5;

  @override
  void paint(Canvas canvas, Size size) {
    const double horizontal = 18;
    const double topPad = 26;
    const double bottomPad = 10;
    final double spacing = (size.width - horizontal * 2) / (_stringCount - 1);
    final double rowHeight = (size.height - topPad - bottomPad) / _visibleFrets;
    final int startFret = variant.baseFret == 0 ? 1 : variant.baseFret;

    final Paint stringPaint = Paint()
      ..color = colors.mutedString.withValues(alpha: 0.6)
      ..strokeWidth = 1.4;
    final Paint fretPaint = Paint()
      ..color = colors.mutedString.withValues(alpha: 0.75)
      ..strokeWidth = 1.2;
    final Paint nutPaint = Paint()
      ..color = colors.fretPressed
      ..strokeWidth = 3.2;

    for (int i = 0; i <= _visibleFrets; i++) {
      final double y = topPad + i * rowHeight;
      canvas.drawLine(
        Offset(horizontal, y),
        Offset(size.width - horizontal, y),
        i == 0 ? nutPaint : fretPaint,
      );
    }
    for (int s = 0; s < _stringCount; s++) {
      final double x = _stringX(s, horizontal, spacing);
      canvas.drawLine(
        Offset(x, topPad),
        Offset(x, topPad + _visibleFrets * rowHeight),
        stringPaint,
      );
    }

    if (startFret > 1) {
      _text(
        canvas,
        '$startFretº',
        Offset(size.width / 2, topPad - 12),
        colors.mutedString,
        11,
      );
    }

    _drawMarkers(canvas, horizontal, spacing, topPad);
    _drawBarre(canvas, horizontal, spacing, topPad, rowHeight, startFret);
    _drawDots(canvas, horizontal, spacing, topPad, rowHeight, startFret);
  }

  void _drawMarkers(
    Canvas canvas,
    double horizontal,
    double spacing,
    double topPad,
  ) {
    for (int s = 0; s < _stringCount; s++) {
      final int fret = variant.frets[s];
      final double x = _stringX(s, horizontal, spacing);
      if (fret == -1) {
        _text(canvas, '×', Offset(x, topPad - 14), colors.mutedString, 13);
      } else if (fret == 0) {
        canvas.drawCircle(
          Offset(x, topPad - 14),
          4,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6
            ..color = colors.openString,
        );
      }
    }
  }

  void _drawBarre(
    Canvas canvas,
    double horizontal,
    double spacing,
    double topPad,
    double rowHeight,
    int startFret,
  ) {
    final BarreInfo? barre = variant.barre;
    if (barre == null) {
      return;
    }
    final int from = barre.fromString;
    final int last = barre.lastString;
    final int fret = barre.fret;
    final double radius = _dotRadius(spacing, rowHeight);
    final double x0 = _stringX(from, horizontal, spacing);
    final double x1 = _stringX(last, horizontal, spacing);
    final double y = topPad + (fret - startFret + 0.5) * rowHeight;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(x0, y - radius / 1.5, x1, y + radius / 1.5),
        Radius.circular(radius),
      ),
      Paint()..color = colors.fretPressed.withValues(alpha: 0.55),
    );
  }

  void _drawDots(
    Canvas canvas,
    double horizontal,
    double spacing,
    double topPad,
    double rowHeight,
    int startFret,
  ) {
    final double radius = _dotRadius(spacing, rowHeight);
    for (int s = 0; s < _stringCount; s++) {
      final int fret = variant.frets[s];
      if (fret <= 0) {
        continue;
      }
      final double x = _stringX(s, horizontal, spacing);
      final double y = topPad + (fret - startFret + 0.5) * rowHeight;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = colors.fretPressed,
      );
      if (showFingers) {
        final int finger = variant.fingers[s];
        if (finger > 0) {
          _text(
            canvas,
            '$finger',
            Offset(x, y),
            Colors.white,
            radius * 1.05,
            bold: true,
          );
        }
      }
    }
  }

  double _dotRadius(double spacing, double rowHeight) =>
      (spacing < rowHeight ? spacing : rowHeight) * 0.34;

  double _stringX(int stringIndex, double horizontal, double spacing) {
    final int index = mirror ? _stringCount - 1 - stringIndex : stringIndex;
    return horizontal + index * spacing;
  }

  void _text(
    Canvas canvas,
    String value,
    Offset center,
    Color color,
    double size, {
    bool bold = false,
  }) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(center.dx - painter.width / 2, center.dy - painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_ChordDiagramPainter oldDelegate) =>
      oldDelegate.variant != variant ||
      oldDelegate.mirror != mirror ||
      oldDelegate.showFingers != showFingers;
}
