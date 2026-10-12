import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/chord_practice_session.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/practice/chord_practice_controller.dart';
import 'package:chords/presentation/features/practice/practice_retune_sheet.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Guía de la práctica: qué tocar ahora, el consejo si falló y los botones.
class PracticeGuide extends StatelessWidget {
  /// Crea la guía.
  const PracticeGuide({
    required this.controller,
    required this.session,
    super.key,
  });

  /// Controlador de la práctica.
  final ChordPracticeController controller;

  /// Sesión en curso.
  final ChordPracticeSession session;

  @override
  Widget build(BuildContext context) {
    if (session.isComplete) {
      return _DoneCard(controller: controller);
    }
    final PracticeString? focus = session.focus;
    if (!controller.status.isListening || focus == null) {
      return _IdleCard(controller: controller);
    }
    return Column(
      children: <Widget>[
        _NextCard(controller: controller, focus: focus),
        if (session.tip != null) ...<Widget>[
          const SizedBox(height: 12),
          _TipCard(tip: session.tip!),
        ],
      ],
    );
  }
}

/// Aún sin escuchar: explica el modo y ofrece empezar.
class _IdleCard extends StatelessWidget {
  const _IdleCard({required this.controller});

  final ChordPracticeController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return AppCard(
      child: Column(
        children: <Widget>[
          AppText(
            t.practice.intro,
            align: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: controller.start,
            icon: const Icon(Icons.mic_rounded),
            label: Text(t.practice.start),
          ),
        ],
      ),
    );
  }
}

/// La cuerda que toca ahora, con su traste y dedo.
class _NextCard extends StatelessWidget {
  const _NextCard({required this.controller, required this.focus});

  final ChordPracticeController controller;
  final PracticeString focus;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.primaryContainer,
      child: Column(
        children: <Widget>[
          AppText(
            practiceNextText(t, focus),
            variant: AppTextVariant.titleLarge,
            color: scheme.onPrimaryContainer,
            align: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: <Widget>[
              FilledButton.tonalIcon(
                onPressed: () => unawaited(controller.playString(focus)),
                icon: const Icon(Icons.volume_up_rounded),
                label: Text(t.practice.listenString),
              ),
              TextButton.icon(
                onPressed: controller.stop,
                icon: const Icon(Icons.stop_rounded),
                label: Text(t.practice.stop),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Consejo para corregir la cuerda que sonó mal.
class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final PracticeTip tip;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.tertiaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.lightbulb_rounded, color: scheme.onTertiaryContainer),
              const SizedBox(width: 8),
              AppText(
                t.practice.tipsTitle,
                variant: AppTextVariant.titleMedium,
                color: scheme.onTertiaryContainer,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText(
            practiceTipText(t, tip),
            color: scheme.onTertiaryContainer,
            overflow: TextOverflow.visible,
          ),
          if (tip.suggestsRetune) ...<Widget>[
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: () =>
                  unawaited(showRetuneSheet(context, tip.stringNumber)),
              icon: const Icon(Icons.tune_rounded),
              label: Text(t.practice.retune),
            ),
          ],
        ],
      ),
    );
  }
}

/// Acorde completo.
class _DoneCard extends StatelessWidget {
  const _DoneCard({required this.controller});

  final ChordPracticeController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.primaryContainer,
      child: Column(
        children: <Widget>[
          Icon(
            Icons.celebration_rounded,
            size: 44,
            color: scheme.onPrimaryContainer,
          ),
          const SizedBox(height: 8),
          AppText(
            t.practice.doneTitle,
            variant: AppTextVariant.headlineMedium,
            color: scheme.onPrimaryContainer,
            weight: FontWeight.w800,
            align: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AppText(
            t.practice.doneMessage,
            color: scheme.onPrimaryContainer,
            align: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: <Widget>[
              FilledButton.icon(
                onPressed: controller.start,
                icon: const Icon(Icons.replay_rounded),
                label: Text(t.practice.restart),
              ),
              FilledButton.tonalIcon(
                onPressed: controller.playChord,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(t.practice.listenChord),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
