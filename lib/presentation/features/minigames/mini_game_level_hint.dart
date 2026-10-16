import 'package:chords/domain/minigames/entities/chord_changes_rules.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Lo que cambia con la dificultad en los juegos con reloj: el tiempo por
/// pregunta o la meta de cambios limpios. No dice nada en los demás juegos.
class MiniGameLevelHint extends StatelessWidget {
  /// Crea la pista de [kind] en [level].
  const MiniGameLevelHint({required this.kind, required this.level, super.key});

  /// Juego elegido.
  final MiniGameKind kind;

  /// Dificultad elegida.
  final MiniGameLevel level;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final String? text = _text(t);
    if (text == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AppText(
        text,
        variant: AppTextVariant.labelMedium,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        align: TextAlign.center,
        maxLines: 2,
      ),
    );
  }

  String? _text(Translations t) {
    if (kind == MiniGameKind.chordChanges) {
      final ChordChangesRules rules = ChordChangesRules.of(level);
      return t.chordGames.changesGoal(
        goal: rules.goal,
        seconds: rules.totalMs ~/ 1000,
      );
    }
    return kind.timed
        ? t.chordGames.perQuestion(n: kind.timeLimitMs(level) ~/ 1000)
        : null;
  }
}
