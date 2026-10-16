import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/live_chord_phase.dart';
import 'package:chords/presentation/l10n/note_labels.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Tarjeta grande con lo que oye la app: el acorde, "toca un acorde" o
/// "escuchando…".
///
/// Con acorde reconocido muestra su nombre en grande, el nombre largo, el
/// bajo y una barra de confianza con una palabra (muy / bastante / poco
/// seguro) para que no haya que interpretar el porcentaje.
class DetectedChordCard extends StatelessWidget {
  /// Crea la tarjeta para la [phase] dada; [chord] solo se usa al detectar.
  const DetectedChordCard({
    required this.phase,
    super.key,
    this.chord,
    this.bass,
  });

  /// Qué está pasando.
  final LiveChordPhase phase;

  /// Acorde reconocido.
  final ChordCandidate? chord;

  /// Clase de nota del bajo, si se distingue.
  final int? bass;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final ChordCandidate? shown = phase == LiveChordPhase.detected
        ? chord
        : null;
    return AppCard(
      color: shown == null ? scheme.surfaceContainer : scheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: AnimatedSize(
        duration: kMotionMedium,
        curve: kEmphasizedCurve,
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: kMotionFast,
          child: shown == null
              ? _Waiting(
                  key: ValueKey<bool>(phase == LiveChordPhase.listening),
                  phase: phase,
                )
              : _Detected(
                  key: ValueKey<String>(shown.id),
                  chord: shown,
                  bass: bass,
                ),
        ),
      ),
    );
  }
}

class _Detected extends StatelessWidget {
  const _Detected({required this.chord, required this.bass, super.key});

  final ChordCandidate chord;
  final int? bass;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color ink = scheme.onPrimaryContainer;
    final int percent = (chord.confidence * 100).round();
    return Semantics(
      container: true,
      label:
          '${chord.name}, ${chordLongName(context, chord)}, '
          '${t.liveChords.confidence(percent: percent)}',
      child: ExcludeSemantics(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  chord.name,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: ink,
                    fontSize: 88,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AppText(
                chordLongName(context, chord),
                variant: AppTextVariant.titleMedium,
                color: ink,
                align: TextAlign.center,
                maxLines: 2,
              ),
              if (bass != null) ...<Widget>[
                const SizedBox(height: 4),
                AppText(
                  t.liveChords.bass(note: noteLabel(context, bass!)),
                  color: ink.withValues(alpha: 0.8),
                ),
              ],
              const SizedBox(height: 16),
              _ConfidenceBar(confidence: chord.confidence),
              const SizedBox(height: 6),
              AppText(
                '${_wordFor(t, chord.confidence)} · '
                '${t.liveChords.confidence(percent: percent)}',
                color: ink,
                variant: AppTextVariant.labelLarge,
                align: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _wordFor(Translations t, double confidence) {
    if (confidence >= 0.75) {
      return t.liveChords.confidenceHigh;
    }
    return confidence >= 0.5
        ? t.liveChords.confidenceMedium
        : t.liveChords.confidenceLow;
  }
}

class _ConfidenceBar extends StatelessWidget {
  const _ConfidenceBar({required this.confidence});

  final double confidence;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: confidence.clamp(0.0, 1.0)),
        duration: kMotionMedium,
        curve: kEmphasizedCurve,
        builder: (BuildContext context, double value, Widget? child) =>
            LinearProgressIndicator(
              value: value,
              minHeight: 8,
              color: scheme.primary,
              backgroundColor: scheme.onPrimaryContainer.withValues(
                alpha: 0.15,
              ),
            ),
      ),
    );
  }
}

class _Waiting extends StatelessWidget {
  const _Waiting({required this.phase, super.key});

  final LiveChordPhase phase;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool silent = phase != LiveChordPhase.listening;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Icon(
            silent ? Icons.music_note_rounded : Icons.graphic_eq_rounded,
            size: 48,
            color: scheme.primary,
          ),
          const SizedBox(height: 8),
          AppText(
            silent ? t.liveChords.silentTitle : t.liveChords.listeningTitle,
            variant: AppTextVariant.headlineMedium,
            align: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          AppText(
            silent ? t.liveChords.silentMessage : t.liveChords.listeningMessage,
            color: scheme.onSurfaceVariant,
            align: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
