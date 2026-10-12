import 'package:chords/domain/chords/entities/chord_match_feedback.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/game/game_audio_controller.dart';
import 'package:chords/presentation/features/game/game_controller.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_level_bar.dart';
import 'package:flutter/material.dart';

/// Indicador de escucha activa con feedback en vivo del acorde.
class GameListeningCard extends StatelessWidget {
  /// Crea la tarjeta de escucha.
  const GameListeningCard({required this.tuner, super.key});

  /// Escucha de la ronda en curso.
  final GameAudioController tuner;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordMatchFeedback feedback = tuner.feedback;
    return AppCard(
      child: Column(
        children: <Widget>[
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 12),
          AppText(t.game.listening, variant: AppTextVariant.titleMedium),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: tuner.matchRatio.clamp(0.0, 1.0),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 12),
          MicLevelBar(level: tuner.level),
          const SizedBox(height: 12),
          if (feedback.isComplete)
            AppText(
              t.game.feedbackComplete,
              variant: AppTextVariant.titleMedium,
            )
          else if (feedback.heardCount > 0)
            AppText(
              t.game.feedbackProgress(
                hit: feedback.heardCount,
                total: feedback.total,
              ),
            ),
          _FeedbackChips(feedback: feedback),
          if (feedback.extraNotes.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            AppText(
              t.game.feedbackExtra(notes: feedback.extraNotes.join(', ')),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }
}

/// Resultado de la ronda con lo que faltó y lo que sobró.
class GameResultCard extends StatelessWidget {
  /// Crea la tarjeta de resultado.
  const GameResultCard({
    required this.controller,
    required this.tuner,
    super.key,
  });

  /// Controlador de la partida.
  final GameController controller;

  /// Escucha de la ronda terminada.
  final GameAudioController tuner;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final ChordMatchFeedback feedback = tuner.feedback;
    final bool won = controller.phase == GamePhase.won;
    return AppCard(
      color: won ? scheme.primaryContainer : scheme.errorContainer,
      child: Column(
        children: <Widget>[
          Icon(
            won ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 36,
            color: won ? scheme.primary : scheme.error,
          ),
          const SizedBox(height: 8),
          AppText(
            _title(t, feedback, won),
            variant: AppTextVariant.titleMedium,
          ),
          _FeedbackChips(feedback: feedback),
          if (feedback.extraNotes.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            AppText(
              t.game.feedbackExtra(notes: feedback.extraNotes.join(', ')),
            ),
          ],
        ],
      ),
    );
  }

  String _title(Translations t, ChordMatchFeedback feedback, bool won) {
    if (!won) {
      return t.game.feedbackMissing(notes: _missingLabel(t, feedback));
    }
    if (feedback.isComplete) {
      return t.game.feedbackComplete;
    }
    return t.game.feedbackProgress(
      hit: feedback.heardCount,
      total: feedback.total,
    );
  }

  String _missingLabel(Translations t, ChordMatchFeedback feedback) => feedback
      .missing
      .map((TargetNoteFeedback note) => _noteLabel(t, note))
      .join(', ');
}

/// Fichas del objetivo: acertadas con check y pendientes con su cuerda.
class _FeedbackChips extends StatelessWidget {
  const _FeedbackChips({required this.feedback});

  final ChordMatchFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    if (feedback.notes.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: <Widget>[
          for (final TargetNoteFeedback note in feedback.notes)
            Chip(
              avatar: note.heard
                  ? Icon(Icons.check_rounded, size: 18, color: scheme.primary)
                  : null,
              label: Text(_noteLabel(t, note)),
              backgroundColor: note.heard
                  ? scheme.primaryContainer
                  : scheme.surfaceContainerHighest,
              side: BorderSide(
                color: note.heard ? scheme.primary : scheme.outlineVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// Etiqueta de una nota objetivo, con la cuerda que la produce si falta.
String _noteLabel(Translations t, TargetNoteFeedback note) {
  if (note.heard || note.strings.isEmpty) {
    return note.note;
  }
  final String strings = note.strings
      .map((int number) => guitarStringLabel(t, number))
      .join('/');
  return '${note.note} · $strings';
}
