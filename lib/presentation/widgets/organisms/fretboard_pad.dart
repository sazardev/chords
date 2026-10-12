import 'package:chords/l10n/translations.g.dart';
import 'package:flutter/material.dart';

/// Tablero tocable del mástil para colocar los dedos de un acorde.
///
/// Muestra seis cuerdas y cinco trastes. Tocar una casilla coloca el dedo en
/// ese traste; tocar las marcas de arriba alterna la cuerda entre silenciada
/// (✕) y al aire (○). Las cuerdas de [wrong] se pintan en rojo.
class FretboardPad extends StatelessWidget {
  /// Crea el tablero con lo colocado en [frets] (índice 0 = sexta cuerda).
  const FretboardPad({
    required this.frets,
    required this.onCell,
    required this.onMark,
    super.key,
    this.wrong = const <int>[],
    this.mirror = false,
    this.stringNames,
  });

  /// Traste de cada cuerda: `-1` muda, `0` al aire, `n` pisada.
  final List<int> frets;

  /// Se llama con (cuerda, traste) al tocar una casilla.
  final void Function(int stringIndex, int fret) onCell;

  /// Se llama con la cuerda al tocar su marca superior.
  final ValueChanged<int> onMark;

  /// Cuerdas (índice 0 = sexta) que están mal colocadas.
  final List<int> wrong;

  /// Si se invierte el tablero para guitarristas zurdos.
  final bool mirror;

  /// Nombre de cada cuerda bajo el tablero (índice 0 = sexta).
  final List<String>? stringNames;

  /// Número de trastes visibles.
  static const int fretCount = 5;

  /// Alto de la fila de marcas.
  static const double markRow = 40;

  /// Alto de cada traste.
  static const double fretRow = 46;

  /// Alto de la fila de nombres.
  static const double nameRow = 26;

  /// Margen lateral hasta la primera cuerda.
  static const double sidePad = 28;

  /// Alto total del tablero.
  static double get height => markRow + fretRow * fretCount + nameRow;

  /// Centro de la casilla (0 = marca, 1…5 = traste) de una cuerda.
  static Offset cellCenter(
    double width,
    int stringIndex,
    int row, {
    bool mirror = false,
  }) {
    final double gap = (width - sidePad * 2) / 5;
    final int column = mirror ? 5 - stringIndex : stringIndex;
    final double y = row == 0
        ? markRow / 2
        : markRow + fretRow * (row - 1) + fretRow / 2;
    return Offset(sidePad + gap * column, y);
  }

  void _onTap(Offset position, double width) {
    final double gap = (width - sidePad * 2) / 5;
    final int column = ((position.dx - sidePad) / gap).round().clamp(0, 5);
    final int stringIndex = mirror ? 5 - column : column;
    if (position.dy < markRow) {
      onMark(stringIndex);
      return;
    }
    final int fret = ((position.dy - markRow) / fretRow).floor() + 1;
    if (fret >= 1 && fret <= fretCount) {
      onCell(stringIndex, fret);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth.clamp(240.0, 360.0);
        return Center(
          child: Semantics(
            label: t.minigames.buildTapHint,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (TapUpDetails details) =>
                  _onTap(details.localPosition, width),
              child: CustomPaint(
                size: Size(width, height),
                painter: _PadPainter(
                  frets: frets,
                  wrong: wrong,
                  mirror: mirror,
                  names: stringNames,
                  stringColor: scheme.onSurfaceVariant,
                  fretColor: scheme.outlineVariant,
                  nutColor: scheme.onSurface,
                  dotColor: scheme.primary,
                  wrongColor: scheme.error,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PadPainter extends CustomPainter {
  _PadPainter({
    required this.frets,
    required this.wrong,
    required this.mirror,
    required this.names,
    required this.stringColor,
    required this.fretColor,
    required this.nutColor,
    required this.dotColor,
    required this.wrongColor,
  });

  final List<int> frets;
  final List<int> wrong;
  final bool mirror;
  final List<String>? names;
  final Color stringColor;
  final Color fretColor;
  final Color nutColor;
  final Color dotColor;
  final Color wrongColor;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size);
    for (int s = 0; s < 6; s++) {
      final Color color = wrong.contains(s) ? wrongColor : dotColor;
      final int fret = frets[s];
      final Offset mark = FretboardPad.cellCenter(
        size.width,
        s,
        0,
        mirror: mirror,
      );
      if (fret == -1) {
        _paintCross(canvas, mark, color);
      } else if (fret == 0) {
        canvas.drawCircle(
          mark,
          9,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      } else {
        canvas.drawCircle(
          FretboardPad.cellCenter(size.width, s, fret, mirror: mirror),
          16,
          Paint()..color = color,
        );
      }
      _paintName(canvas, size, s);
    }
  }

  void _paintGrid(Canvas canvas, Size size) {
    final Paint fretPaint = Paint()
      ..color = fretColor
      ..strokeWidth = 2;
    const double left = FretboardPad.sidePad;
    final double right = size.width - FretboardPad.sidePad;
    canvas.drawLine(
      const Offset(left, FretboardPad.markRow),
      Offset(right, FretboardPad.markRow),
      Paint()
        ..color = nutColor
        ..strokeWidth = 6,
    );
    for (int f = 1; f <= FretboardPad.fretCount; f++) {
      final double y = FretboardPad.markRow + FretboardPad.fretRow * f;
      canvas.drawLine(Offset(left, y), Offset(right, y), fretPaint);
    }
    const double bottom =
        FretboardPad.markRow + FretboardPad.fretRow * FretboardPad.fretCount;
    for (int s = 0; s < 6; s++) {
      final double x = FretboardPad.cellCenter(
        size.width,
        s,
        0,
        mirror: mirror,
      ).dx;
      canvas.drawLine(
        Offset(x, FretboardPad.markRow),
        Offset(x, bottom),
        Paint()
          ..color = stringColor
          ..strokeWidth = 1.5 + (5 - s) * 0.45,
      );
    }
  }

  void _paintCross(Canvas canvas, Offset center, Color color) {
    final Paint paint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(
        center + const Offset(-7, -7),
        center + const Offset(7, 7),
        paint,
      )
      ..drawLine(
        center + const Offset(-7, 7),
        center + const Offset(7, -7),
        paint,
      );
  }

  void _paintName(Canvas canvas, Size size, int stringIndex) {
    final List<String>? labels = names;
    if (labels == null) {
      return;
    }
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: labels[stringIndex],
        style: TextStyle(color: stringColor, fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final Offset center = FretboardPad.cellCenter(
      size.width,
      stringIndex,
      0,
      mirror: mirror,
    );
    painter.paint(
      canvas,
      Offset(
        center.dx - painter.width / 2,
        size.height - FretboardPad.nameRow + 6,
      ),
    );
  }

  @override
  bool shouldRepaint(_PadPainter old) =>
      old.frets != frets ||
      old.wrong != wrong ||
      old.mirror != mirror ||
      old.dotColor != dotColor;
}
