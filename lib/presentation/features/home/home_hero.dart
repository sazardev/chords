import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tarjeta principal del inicio: el siguiente acorde del itinerario.
///
/// Muestra el acorde con su diagrama, el nivel en el que está y una barra de
/// progreso que se llena con una animación al entrar. Un toque abre su ficha.
class HomeHero extends StatelessWidget {
  /// Crea la tarjeta.
  const HomeHero({
    required this.next,
    required this.progress,
    required this.mastered,
    super.key,
    this.mirror = false,
  });

  /// Siguiente acorde a estudiar; `null` si el itinerario está completo.
  final Chord? next;

  /// Progreso global del itinerario (0-1).
  final double progress;

  /// Acordes dominados.
  final int mastered;

  /// Si los diagramas se muestran en espejo.
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Chord? chord = next;
    return AppCard(
      color: scheme.primaryContainer,
      borderRadius: 36,
      padding: const EdgeInsets.fromLTRB(22, 22, 18, 20),
      onTap: chord == null
          ? () => context.go(kLearnPath)
          : () => context.push(
              '$kChordDetailPath?id=${Uri.encodeComponent(chord.id)}',
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: _Copy(chord: chord)),
              if (chord != null)
                ChordDiagram(
                  variant: chord.easiestVariant,
                  mirror: mirror,
                  width: 116,
                  height: 148,
                )
              else
                Icon(
                  Icons.emoji_events_rounded,
                  size: 72,
                  color: scheme.onPrimaryContainer,
                ),
            ],
          ),
          const SizedBox(height: 18),
          _ProgressBar(progress: progress, mastered: mastered),
        ],
      ),
    );
  }
}

class _Copy extends StatelessWidget {
  const _Copy({required this.chord});

  final Chord? chord;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Chord? value = chord;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText(
          value == null ? t.home.itineraryComplete : t.home.nextUp,
          variant: AppTextVariant.labelLarge,
          color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
        ),
        if (value != null) ...<Widget>[
          AppText(
            value.name,
            variant: AppTextVariant.displayLarge,
            color: scheme.onPrimaryContainer,
          ),
          AppText(
            learningLevelTitle(t, LearningLevel.of(value)),
            variant: AppTextVariant.bodyLarge,
            color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => context.push(
              '$kChordDetailPath?id=${Uri.encodeComponent(value.id)}',
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(t.home.practiceCta),
          ),
        ],
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.mastered});

  final double progress;
  final int mastered;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TweenAnimationBuilder<double>(
          tween: Tween<double>(end: progress.clamp(0.0, 1.0)),
          duration: kMotionEntrance * 2,
          curve: kEmphasizedCurve,
          builder: (BuildContext context, double value, Widget? _) => ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              color: scheme.primary,
              backgroundColor: scheme.onPrimaryContainer.withValues(
                alpha: 0.18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AppText(
          t.home.masteredCount(n: mastered),
          variant: AppTextVariant.labelMedium,
          color: scheme.onPrimaryContainer.withValues(alpha: 0.85),
        ),
      ],
    );
  }
}
