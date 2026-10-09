import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Insignia de nivel de dificultad (1-5 estrellas).
class DifficultyBadge extends StatelessWidget {
  /// Crea la insignia.
  const DifficultyBadge({
    required this.difficulty,
    super.key,
    this.compact = false,
  });

  /// Nivel de dificultad.
  final Difficulty difficulty;

  /// Si muestra solo estrellas y número.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final AppChordColors colors = chordColorsOf(context);
    final Color color = colors.forDifficulty(difficulty.level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 1; i <= difficulty.level; i++)
            Icon(Icons.star_rounded, size: compact ? 12 : 14, color: color),
          const SizedBox(width: 6),
          AppText(
            '${difficulty.level}',
            variant: AppTextVariant.labelMedium,
            color: color,
          ),
          if (!compact) ...<Widget>[
            const SizedBox(width: 4),
            AppText(
              difficulty.label,
              variant: AppTextVariant.labelMedium,
              color: color,
            ),
          ],
        ],
      ),
    );
  }
}
