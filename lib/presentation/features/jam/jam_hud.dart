import 'package:chords/domain/jam/jam_scorer.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Compases que se ven por delante en la pista.
const int _laneLength = 8;

/// Marcador del modo puntuar: puntos, multiplicador, racha y la nota del
/// último compás.
class JamScoreBar extends StatelessWidget {
  /// Crea el marcador.
  const JamScoreBar({required this.state, super.key});

  /// Estado de la sesión.
  final JamState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final JamScore score = state.score;
    final BarGrade? grade = state.lastGrade;
    return AppCard(
      color: scheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: <Widget>[
          AppText(
            t.jam.points(n: score.points),
            variant: AppTextVariant.titleLarge,
            color: scheme.onSecondaryContainer,
          ),
          const SizedBox(width: 10),
          AnimatedScale(
            scale: score.multiplier > 1 ? 1.15 : 1,
            duration: const Duration(milliseconds: 200),
            child: Chip(
              label: Text('×${score.multiplier}'),
              backgroundColor: scheme.tertiary,
              labelStyle: TextStyle(
                color: scheme.onTertiary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AppText(
              t.jam.streak(n: score.streak),
              color: scheme.onSecondaryContainer,
            ),
          ),
          if (grade != null)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: AppText(
                _gradeLabel(t, grade),
                key: ValueKey<int>(score.total),
                variant: AppTextVariant.titleMedium,
                color: _gradeColor(scheme, grade),
              ),
            ),
        ],
      ),
    );
  }

  String _gradeLabel(Translations t, BarGrade grade) => switch (grade) {
    BarGrade.perfect => t.jam.gradePerfect,
    BarGrade.good => t.jam.gradeGood,
    BarGrade.miss => t.jam.gradeMiss,
    BarGrade.silent => t.jam.gradeSilent,
  };

  Color _gradeColor(ColorScheme scheme, BarGrade grade) => switch (grade) {
    BarGrade.perfect => scheme.primary,
    BarGrade.good => scheme.tertiary,
    _ => scheme.error,
  };
}

/// Pulsos del compás como puntos; el actual, encendido.
class BeatDots extends StatelessWidget {
  /// Crea los puntos.
  const BeatDots({
    required this.beat,
    required this.color,
    super.key,
    this.beats = 4,
  });

  /// Pulso actual (desde 0).
  final int beat;

  /// Color de los puntos.
  final Color color;

  /// Pulsos por compás.
  final int beats;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      for (int i = 0; i < beats; i++)
        AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == beat ? 16 : 10,
          height: i == beat ? 16 : 10,
          decoration: BoxDecoration(
            color: i == beat ? color : color.withValues(alpha: 0.25),
            shape: BoxShape.circle,
          ),
        ),
    ],
  );
}

/// Carril con los próximos compases (estilo autopista): el actual a la
/// izquierda, resaltado, y los siguientes detrás.
class JamBarsLane extends StatelessWidget {
  /// Crea el carril.
  const JamBarsLane({required this.state, super.key});

  /// Estado de la sesión.
  final JamState state;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final JamTrack track = state.track!;
    final int end = (state.bar + _laneLength).clamp(0, track.bars.length);
    return SizedBox(
      height: 54,
      child: Row(
        children: <Widget>[
          for (int b = state.bar; b < end; b++)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: b == state.bar
                      ? scheme.primary
                      : scheme.surfaceContainerHighest.withValues(
                          alpha: 1 - (b - state.bar) / (_laneLength + 2),
                        ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      track.bars[b].chords
                          .map((ChordSymbol c) => c.name)
                          .join(' '),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: b == state.bar
                            ? scheme.onPrimary
                            : scheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          for (int pad = end - state.bar; pad < _laneLength; pad++)
            const Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }
}
