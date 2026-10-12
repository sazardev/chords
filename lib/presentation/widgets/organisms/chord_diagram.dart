import 'package:chords/domain/chords/entities/barre_info.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:flutter/foundation.dart' show listEquals;
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
    this.stringStates,
    this.focusString,
    this.stringNames,
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

  /// Estado de cada cuerda en la práctica (índice 0 = sexta); `null` si el
  /// diagrama es solo informativo.
  final List<PracticeStringStatus>? stringStates;

  /// Número de la cuerda (1-6) que toca ahora; se resalta su columna.
  final int? focusString;

  /// Nombres bajo cada cuerda (índice 0 = sexta); `null` para no mostrarlos.
  final List<String>? stringNames;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Semantics(
      label: _semanticLabel(t),
      child: CustomPaint(
        size: Size(width, height),
        painter: _ChordDiagramPainter(
          variant: variant,
          mirror: mirror,
          showFingers: showFingers,
          colors: chordColorsOf(context),
          states: stringStates,
          focusString: focusString,
          focusColor: Theme.of(context).colorScheme.primary,
          names: stringNames,
          nameColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _semanticLabel(Translations t) {
    final List<String> parts = <String>[
      for (int s = 0; s < variant.frets.length; s++)
        t.chordDiagram.stringLabel(
          number: s + 1,
          fret: _fretLabel(t, variant.frets[s]),
        ),
    ];
    return t.chordDiagram.description(
      position: variant.positionLabel,
      details: parts.join(', '),
    );
  }

  String _fretLabel(Translations t, int fret) => switch (fret) {
    -1 => t.chordDiagram.muted,
    0 => t.chordDiagram.open,
    final int value => t.chordDiagram.fret(value: value),
  };
}

/// Pintor del diagrama de diapasón.
class _ChordDiagramPainter extends CustomPainter {
  _ChordDiagramPainter({
    required this.variant,
    required this.mirror,
    required this.showFingers,
    required this.colors,
    required this.focusColor,
    required this.nameColor,
    this.states,
    this.focusString,
    this.names,
  });

  final ChordVariant variant;
  final bool mirror;
  final bool showFingers;
  final AppChordColors colors;
  final List<PracticeStringStatus>? states;
  final int? focusString;
  final Color focusColor;
  final List<String>? names;
  final Color nameColor;

  static const int _stringCount = 6;
  static const int _visibleFrets = 5;

  @override
  void paint(Canvas canvas, Size size) {
    const double horizontal = 18;
    const double topPad = 26;
    final double bottomPad = names == null ? 10 : 26;
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

    _drawFocusColumn(canvas, horizontal, spacing, topPad, rowHeight);
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
      final bool matched = _statusOf(s) == PracticeStringStatus.matched;
      canvas.drawLine(
        Offset(x, topPad),
        Offset(x, topPad + _visibleFrets * rowHeight),
        matched
            ? (Paint()
                ..color = colors.inTune
                ..strokeWidth = 3)
            : stringPaint,
      );
    }
    _drawNames(canvas, horizontal, spacing, topPad + _visibleFrets * rowHeight);

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
        final bool matched = _statusOf(s) == PracticeStringStatus.matched;
        canvas.drawCircle(
          Offset(x, topPad - 14),
          matched ? 5.5 : 4,
          Paint()
            ..style = matched ? PaintingStyle.fill : PaintingStyle.stroke
            ..strokeWidth = 1.6
            ..color = matched ? colors.inTune : colors.openString,
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
        Paint()
          ..color = _statusOf(s) == PracticeStringStatus.matched
              ? colors.inTune
              : colors.fretPressed,
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

  PracticeStringStatus? _statusOf(int stringIndex) {
    final List<PracticeStringStatus>? list = states;
    return list == null || stringIndex >= list.length
        ? null
        : list[stringIndex];
  }

  void _drawFocusColumn(
    Canvas canvas,
    double horizontal,
    double spacing,
    double topPad,
    double rowHeight,
  ) {
    final int? number = focusString;
    if (number == null) {
      return;
    }
    final double x = _stringX(_stringCount - number, horizontal, spacing);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          x - spacing * 0.45,
          topPad - 26,
          x + spacing * 0.45,
          topPad + _visibleFrets * rowHeight + 4,
        ),
        const Radius.circular(10),
      ),
      Paint()..color = focusColor.withValues(alpha: 0.16),
    );
  }

  void _drawNames(Canvas canvas, double horizontal, double spacing, double y) {
    final List<String>? labels = names;
    if (labels == null) {
      return;
    }
    for (int s = 0; s < _stringCount && s < labels.length; s++) {
      final bool focus = focusString == _stringCount - s;
      _text(
        canvas,
        labels[s],
        Offset(_stringX(s, horizontal, spacing), y + 14),
        focus ? focusColor : nameColor,
        12,
        bold: focus,
      );
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
      oldDelegate.showFingers != showFingers ||
      oldDelegate.focusString != focusString ||
      oldDelegate.focusColor != focusColor ||
      !listEquals(oldDelegate.states, states) ||
      !listEquals(oldDelegate.names, names);
}
