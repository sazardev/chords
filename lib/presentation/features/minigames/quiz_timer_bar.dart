import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/quiz_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Barra del tiempo que queda para responder en los juegos con reloj.
class QuizTimerBar extends StatelessWidget {
  /// Crea la barra para la pregunta actual de [state].
  const QuizTimerBar({required this.state, super.key});

  /// Estado de la partida.
  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final MiniGameKind kind = state.kind;
    final int limit = kind.timeLimitMs(state.level);
    final double fraction = (state.msLeft / limit).clamp(0.0, 1.0);
    final bool urgent = fraction < 0.25;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Semantics(
        label: t.chordGames.timeLeft(n: (state.msLeft / 1000).ceil()),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8,
                color: urgent ? scheme.error : scheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            AppText(
              t.chordGames.timeLeft(n: (state.msLeft / 1000).ceil()),
              variant: AppTextVariant.labelMedium,
              color: urgent ? scheme.error : scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
