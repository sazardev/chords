import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Medidor del nivel de entrada del micrófono con una pista de uso.
///
/// Dice al guitarrista si lo oye bien, si debe acercarse o si suena
/// demasiado fuerte, para que sepa qué corregir antes de pensar que la app
/// "no escucha".
class MicLevelBar extends StatelessWidget {
  /// Crea el medidor.
  const MicLevelBar({required this.level, super.key});

  /// Nivel de entrada normalizado (0-1).
  final double level;

  static const int _segments = 14;
  static const double _quiet = 0.08;
  static const double _lowGood = 0.25;
  static const double _loud = 0.92;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AppChordColors colors = chordColorsOf(context);
    final int lit = (level.clamp(0.0, 1.0) * _segments).round();
    final Color litColor = level >= _loud
        ? colors.outOfTune
        : (level < _lowGood ? colors.nearTune : colors.inTune);
    return Semantics(
      label: t.mic.levelLabel,
      value: '${(level * 100).round()}%',
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.mic_rounded, size: 18, color: scheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: <Widget>[
                    for (int i = 0; i < _segments; i++)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 90),
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          decoration: BoxDecoration(
                            color: i < lit
                                ? litColor
                                : scheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AppText(
            _hint(t),
            variant: AppTextVariant.labelMedium,
            color: scheme.onSurfaceVariant,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _hint(Translations t) {
    if (level < _quiet) {
      return t.mic.levelWaiting;
    }
    if (level < _lowGood) {
      return t.mic.levelQuiet;
    }
    return level >= _loud ? t.mic.levelLoud : t.mic.levelGood;
  }
}
