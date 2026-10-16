import 'dart:async' show unawaited;
import 'dart:math' as math;

import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/theory/services/scale_positions.dart'
    show kScaleMaxFret;
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:flutter/material.dart';

/// Cómo se pinta una nota en el mástil.
enum FretMarkStyle {
  /// Tónica: color principal.
  root,

  /// Nota de la escala dentro de la posición.
  scale,

  /// Nota característica (blue note, nota del modo).
  accent,

  /// Nota de la escala fuera de la posición elegida.
  faded,
}

/// Una nota marcada en el mástil con su etiqueta (`La` o `b3`).
@immutable
class FretMark {
  /// Crea la marca.
  const FretMark(this.position, this.label, this.style);

  /// Cuerda y traste.
  final FretPosition position;

  /// Texto dentro del círculo.
  final String label;

  /// Estilo.
  final FretMarkStyle style;
}

/// Mástil horizontal con notas marcadas: la 1ª cuerda arriba, como en una
/// tablatura. Se desplaza en horizontal si no cabe y, al tocar una nota,
/// avisa con [onTap] para que suene.
class ScaleFretboard extends StatefulWidget {
  /// Crea el mástil.
  const ScaleFretboard({
    required this.marks,
    super.key,
    this.startFret = 0,
    this.endFret = kScaleMaxFret,
    this.mirror = false,
    this.window,
    this.onTap,
    this.semanticLabel,
  });

  /// Notas a dibujar.
  final List<FretMark> marks;

  /// Primer traste visible (0 = incluye las cuerdas al aire).
  final int startFret;

  /// Último traste visible.
  final int endFret;

  /// Dibuja en espejo (zurdos).
  final bool mirror;

  /// Tramo de trastes resaltado (la posición elegida).
  final (int, int)? window;

  /// Se llama al tocar una cuerda en un traste.
  final ValueChanged<FretPosition>? onTap;

  /// Descripción para lectores de pantalla.
  final String? semanticLabel;

  static const double _stringGap = 30;
  static const double _top = 18;
  static const double _bottom = 26;

  @override
  State<ScaleFretboard> createState() => _ScaleFretboardState();
}

class _ScaleFretboardState extends State<ScaleFretboard> {
  final ScrollController _scroll = ScrollController();
  double _viewport = 0;
  double _fretWidth = 44;

  @override
  void didUpdateWidget(ScaleFretboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.window != widget.window && widget.window != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _revealWindow());
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Desplaza el mástil para que la posición elegida quede a la vista.
  void _revealWindow() {
    final (int, int)? range = widget.window;
    if (!mounted || range == null || !_scroll.hasClients) {
      return;
    }
    final int columns = widget.endFret - widget.startFret + 1;
    final double total = _fretWidth * columns;
    final double left = (range.$1 - widget.startFret) * _fretWidth - 24;
    final double target = widget.mirror ? total - _viewport - left : left;
    unawaited(
      _scroll.animateTo(
        target.clamp(0, _scroll.position.maxScrollExtent),
        duration: kMotionMedium,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final int columns = widget.endFret - widget.startFret + 1;
      final double fretWidth = math.max(44, constraints.maxWidth / columns);
      _viewport = constraints.maxWidth;
      _fretWidth = fretWidth;
      final Size size = Size(
        fretWidth * columns,
        ScaleFretboard._top +
            ScaleFretboard._stringGap * 5 +
            ScaleFretboard._bottom,
      );
      final Widget board = GestureDetector(
        onTapUp: widget.onTap == null
            ? null
            : (TapUpDetails details) =>
                  _handleTap(details.localPosition, fretWidth, size.width),
        child: CustomPaint(
          size: size,
          painter: _FretboardPainter(
            marks: widget.marks,
            startFret: widget.startFret,
            endFret: widget.endFret,
            fretWidth: fretWidth,
            mirror: widget.mirror,
            window: widget.window,
            scheme: Theme.of(context).colorScheme,
            textStyle: Theme.of(context).textTheme.labelSmall!,
          ),
        ),
      );
      return Semantics(
        label: widget.semanticLabel,
        child: SingleChildScrollView(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          reverse: widget.mirror,
          child: board,
        ),
      );
    },
  );

  void _handleTap(Offset local, double fretWidth, double width) {
    final double x = widget.mirror ? width - local.dx : local.dx;
    final int fret = widget.startFret + (x / fretWidth).floor();
    final int string =
        ((local.dy - ScaleFretboard._top) / ScaleFretboard._stringGap).round() +
        1;
    if (string >= 1 &&
        string <= 6 &&
        fret >= widget.startFret &&
        fret <= widget.endFret) {
      widget.onTap!(FretPosition(string, fret));
    }
  }
}

class _FretboardPainter extends CustomPainter {
  _FretboardPainter({
    required this.marks,
    required this.startFret,
    required this.endFret,
    required this.fretWidth,
    required this.mirror,
    required this.window,
    required this.scheme,
    required this.textStyle,
  });

  final List<FretMark> marks;
  final int startFret;
  final int endFret;
  final double fretWidth;
  final bool mirror;
  final (int, int)? window;
  final ColorScheme scheme;
  final TextStyle textStyle;

  static const Set<int> _inlays = <int>{3, 5, 7, 9, 15, 17};

  double _x(double raw, Size size) => mirror ? size.width - raw : raw;

  double _y(int string) =>
      ScaleFretboard._top + (string - 1) * ScaleFretboard._stringGap;

  double _center(int fret, Size size) =>
      _x((fret - startFret + 0.5) * fretWidth, size);

  @override
  void paint(Canvas canvas, Size size) {
    _paintWindow(canvas, size);
    _paintInlays(canvas, size);
    _paintFrets(canvas, size);
    _paintStrings(canvas, size);
    for (final FretMark mark in marks) {
      _paintMark(canvas, size, mark);
    }
  }

  void _paintWindow(Canvas canvas, Size size) {
    final (int, int)? range = window;
    if (range == null) {
      return;
    }
    final double a = _x((range.$1 - startFret) * fretWidth, size);
    final double b = _x((range.$2 - startFret + 1) * fretWidth, size);
    canvas.drawRRect(
      RRect.fromLTRBR(
        math.min(a, b),
        4,
        math.max(a, b),
        _y(6) + 14,
        const Radius.circular(12),
      ),
      Paint()..color = scheme.primaryContainer.withValues(alpha: 0.45),
    );
  }

  void _paintInlays(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = scheme.outlineVariant;
    for (int fret = math.max(startFret, 1); fret <= endFret; fret++) {
      final double x = _center(fret, size);
      if (fret == 12) {
        canvas
          ..drawCircle(Offset(x, (_y(2) + _y(3)) / 2), 5, paint)
          ..drawCircle(Offset(x, (_y(4) + _y(5)) / 2), 5, paint);
      } else if (_inlays.contains(fret)) {
        canvas.drawCircle(Offset(x, (_y(3) + _y(4)) / 2), 5, paint);
      }
      if (fret == 12 || _inlays.contains(fret) || fret == 1) {
        _text(canvas, '$fret', Offset(x, _y(6) + 18), scheme.outline);
      }
    }
  }

  void _paintFrets(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = scheme.outline
      ..strokeWidth = 1.4;
    for (int i = 1; i <= endFret - startFret + 1; i++) {
      final int fret = startFret + i - 1;
      final double x = _x(i * fretWidth, size);
      canvas.drawLine(
        Offset(x, _y(1)),
        Offset(x, _y(6)),
        fret == 0
            ? (Paint()
                ..color = scheme.onSurface
                ..strokeWidth = 5)
            : paint,
      );
    }
  }

  void _paintStrings(Canvas canvas, Size size) {
    for (int string = 1; string <= 6; string++) {
      canvas.drawLine(
        Offset(0, _y(string)),
        Offset(size.width, _y(string)),
        Paint()
          ..color = scheme.onSurfaceVariant.withValues(alpha: 0.7)
          ..strokeWidth = 0.8 + string * 0.35,
      );
    }
  }

  void _paintMark(Canvas canvas, Size size, FretMark mark) {
    final int fret = mark.position.fret;
    if (fret < startFret || fret > endFret) {
      return;
    }
    final Offset center = Offset(
      _center(fret, size),
      _y(mark.position.stringNumber),
    );
    final (Color fill, Color ink) = switch (mark.style) {
      FretMarkStyle.root => (scheme.primary, scheme.onPrimary),
      FretMarkStyle.scale => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      FretMarkStyle.accent => (scheme.tertiary, scheme.onTertiary),
      FretMarkStyle.faded => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant.withValues(alpha: 0.6),
      ),
    };
    canvas.drawCircle(center, 12.5, Paint()..color = fill);
    if (mark.style != FretMarkStyle.faded) {
      canvas.drawCircle(
        center,
        12.5,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = scheme.surface,
      );
    }
    _text(canvas, mark.label, center, ink);
  }

  void _text(Canvas canvas, String text, Offset center, Color color) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: text.length > 2 ? 9 : 11,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_FretboardPainter old) =>
      old.marks != marks ||
      old.window != window ||
      old.mirror != mirror ||
      old.scheme != scheme ||
      old.fretWidth != fretWidth;
}
