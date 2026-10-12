import 'dart:math' as math;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:flutter/material.dart';

/// Cabezal de guitarra con sus seis clavijas, para saber qué cuerda es cuál.
///
/// Sigue la disposición real 3+3: a la izquierda 4ª, 5ª y 6ª y a la derecha
/// 1ª, 2ª y 3ª. Cada clavija muestra la nota y el número de cuerda; la que
/// suena se ilumina con el color de su zona de afinación, las afinadas se
/// marcan con un check y la elegida a mano queda resaltada. Pulsar una
/// clavija la selecciona.
class GuitarHeadstock extends StatelessWidget {
  /// Crea el cabezal.
  const GuitarHeadstock({
    required this.tuned,
    required this.onSelect,
    super.key,
    this.active,
    this.zone,
    this.target,
    this.height = 250,
  });

  /// Números de las cuerdas ya afinadas.
  final Set<int> tuned;

  /// Número de la cuerda que suena ahora, si se reconoce.
  final int? active;

  /// Zona de afinación de la cuerda activa.
  final TuningZone? zone;

  /// Número de la cuerda elegida a mano, si hay.
  final int? target;

  /// Acción al pulsar una clavija.
  final ValueChanged<GuitarString> onSelect;

  /// Alto del cabezal.
  final double height;

  /// Columna (0 izquierda, 1 derecha) y fila (0 arriba) de cada cuerda.
  static const Map<int, ({int column, int row})> _layout =
      <int, ({int column, int row})>{
        4: (column: 0, row: 0),
        5: (column: 0, row: 1),
        6: (column: 0, row: 2),
        1: (column: 1, row: 0),
        2: (column: 1, row: 1),
        3: (column: 1, row: 2),
      };

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AppChordColors colors = chordColorsOf(context);
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints box) {
          final _Geometry geometry = _Geometry(Size(box.maxWidth, height));
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(
                  painter: _HeadstockPainter(
                    scheme: scheme,
                    colors: colors,
                    tuned: tuned,
                    active: active,
                    zone: zone,
                  ),
                ),
              ),
              for (final GuitarString string in kStandardTuning)
                _positioned(context, string, geometry),
            ],
          );
        },
      ),
    );
  }

  Widget _positioned(
    BuildContext context,
    GuitarString string,
    _Geometry geometry,
  ) {
    final ({int column, int row}) cell = _layout[string.number]!;
    return Positioned(
      left: geometry.pegLeft(left: cell.column == 0),
      top: geometry.pegTop(cell.row),
      width: geometry.peg,
      height: geometry.peg,
      child: _Peg(
        string: string,
        state: _stateOf(string.number),
        tuned: tuned.contains(string.number),
        zoneColor: _zoneColor(context),
        onTap: () => onSelect(string),
      ),
    );
  }

  _PegState _stateOf(int number) {
    if (number == active) {
      return _PegState.active;
    }
    if (tuned.contains(number)) {
      return _PegState.tuned;
    }
    return number == target ? _PegState.target : _PegState.idle;
  }

  Color _zoneColor(BuildContext context) {
    final AppChordColors colors = chordColorsOf(context);
    return switch (zone) {
      TuningZone.inTune => colors.inTune,
      TuningZone.near => colors.nearTune,
      TuningZone.off || TuningZone.far => colors.outOfTune,
      null => Theme.of(context).colorScheme.primary,
    };
  }
}

/// Medidas del cabezal, compartidas por las clavijas y el pintor de cuerdas.
class _Geometry {
  const _Geometry(this.size);

  final Size size;

  /// Diámetro de una clavija (cabe 3 por columna sin tocarse).
  double get peg => math.min(56, size.height * 0.22);

  /// Distancia vertical entre filas de clavijas.
  double get rowGap => (size.height * 0.72 - peg) / 2;

  /// Separación horizontal entre el eje y la clavija.
  double get inset => size.width * 0.17;

  double pegTop(int row) => size.height * 0.03 + row * rowGap;

  double pegLeft({required bool left}) =>
      size.width / 2 + (left ? -inset - peg : inset);

  /// X desde donde sale la cuerda: el borde interior de la clavija.
  double stringStartX({required bool left}) =>
      size.width / 2 + (left ? -inset : inset);

  /// Y desde donde sale la cuerda: el centro de la clavija.
  double stringStartY(int row) => pegTop(row) + peg / 2;
}

enum _PegState { idle, target, active, tuned }

/// Clavija pulsable con la nota y el número de la cuerda.
class _Peg extends StatelessWidget {
  const _Peg({
    required this.string,
    required this.state,
    required this.tuned,
    required this.zoneColor,
    required this.onTap,
  });

  final GuitarString string;
  final _PegState state;
  final bool tuned;
  final Color zoneColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AppChordColors colors = chordColorsOf(context);
    final Color fill = switch (state) {
      _PegState.active => zoneColor,
      _PegState.tuned => colors.inTune.withValues(alpha: 0.28),
      _PegState.target => scheme.primaryContainer,
      _PegState.idle => scheme.surfaceContainerHighest,
    };
    final Color ink = switch (state) {
      _PegState.active =>
        ThemeData.estimateBrightnessForColor(zoneColor) == Brightness.dark
            ? Colors.white
            : Colors.black87,
      _PegState.target => scheme.onPrimaryContainer,
      _ => scheme.onSurface,
    };
    return Semantics(
      button: true,
      selected: state == _PegState.active || state == _PegState.target,
      label: t.tuner.peg(string: stringTitle(t, string)),
      // La clavija tiene tamaño fijo: se limita el escalado de su texto.
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.textScalerOf(context)
              .clamp(maxScaleFactor: 1.1),
        ),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      openNoteName(t, string),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ink,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    Text(
                      guitarStringLabel(t, string.number),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ink.withValues(alpha: 0.8),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                if (tuned)
                  Positioned(
                    right: -3,
                    top: -3,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: colors.inTune,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pinta el cuerpo del cabezal, el mástil y las seis cuerdas.
class _HeadstockPainter extends CustomPainter {
  const _HeadstockPainter({
    required this.scheme,
    required this.colors,
    required this.tuned,
    required this.active,
    required this.zone,
  });

  final ColorScheme scheme;
  final AppChordColors colors;
  final Set<int> tuned;
  final int? active;
  final TuningZone? zone;

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double bodyHalf = size.width * 0.27;
    final double neckHalf = size.width * 0.15;
    final double bodyBottom = size.height * 0.80;
    canvas
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cx - bodyHalf,
          0,
          cx + bodyHalf,
          bodyBottom,
          topLeft: const Radius.circular(48),
          topRight: const Radius.circular(48),
          bottomLeft: const Radius.circular(10),
          bottomRight: const Radius.circular(10),
        ),
        Paint()..color = scheme.surfaceContainerHigh,
      )
      ..drawRect(
        Rect.fromLTRB(
          cx - neckHalf,
          bodyBottom - 4,
          cx + neckHalf,
          size.height,
        ),
        Paint()..color = scheme.surfaceContainer,
      )
      ..drawRect(
        Rect.fromLTRB(
          cx - neckHalf,
          bodyBottom - 4,
          cx + neckHalf,
          bodyBottom + 3,
        ),
        Paint()..color = scheme.onSurfaceVariant.withValues(alpha: 0.55),
      );
    _strings(canvas, size, cx, neckHalf, bodyBottom);
  }

  void _strings(
    Canvas canvas,
    Size size,
    double cx,
    double neckHalf,
    double nutY,
  ) {
    final _Geometry geometry = _Geometry(size);
    for (int i = 0; i < kStandardTuning.length; i++) {
      final int number = kStandardTuning[i].number;
      final ({int column, int row}) cell = GuitarHeadstock._layout[number]!;
      final double nutX = cx + (i - 2.5) * (neckHalf * 2 / 6);
      final Paint paint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1.2 + (6 - number) * 0.45
        ..color = _colorOf(number);
      canvas
        ..drawLine(
          Offset(
            geometry.stringStartX(left: cell.column == 0),
            geometry.stringStartY(cell.row),
          ),
          Offset(nutX, nutY),
          paint,
        )
        ..drawLine(Offset(nutX, nutY), Offset(nutX, size.height), paint);
    }
  }

  Color _colorOf(int number) {
    if (number == active) {
      return switch (zone) {
        TuningZone.inTune => colors.inTune,
        TuningZone.near => colors.nearTune,
        TuningZone.off || TuningZone.far => colors.outOfTune,
        null => scheme.primary,
      };
    }
    if (tuned.contains(number)) {
      return colors.inTune.withValues(alpha: 0.8);
    }
    return scheme.onSurfaceVariant.withValues(alpha: 0.5);
  }

  @override
  bool shouldRepaint(_HeadstockPainter oldDelegate) =>
      oldDelegate.scheme != scheme ||
      oldDelegate.colors != colors ||
      oldDelegate.active != active ||
      oldDelegate.zone != zone ||
      !_sameSet(oldDelegate.tuned, tuned);

  bool _sameSet(Set<int> a, Set<int> b) =>
      a.length == b.length && a.containsAll(b);
}
