import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/chord_chip_row.dart';
import 'package:chords/presentation/features/live/chroma_bars.dart';
import 'package:chords/presentation/features/live/closest_position_card.dart';
import 'package:chords/presentation/features/live/detected_chord_card.dart';
import 'package:chords/presentation/features/live/live_chord_phase.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_level_bar.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Modo acordes de la pantalla en vivo: reconoce lo que rasgueas.
///
/// De arriba abajo: el acorde detectado en grande con su confianza, el nivel
/// del micrófono, las 12 notas en vivo (con las del acorde marcadas), las
/// alternativas probables, el diagrama de la posición más cercana y el
/// historial de los últimos acordes. Todo lo que nombra un acorde abre su
/// ficha. No lleva `Scaffold`: lo pone la pantalla que lo aloja.
class ChordsView extends StatelessWidget {
  /// Crea la vista del modo acordes.
  const ChordsView({super.key});

  static const List<double> _flat = <double>[
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  /// Detiene la escucha, abre la ficha de [candidate] y la retoma al volver.
  Future<void> _open(BuildContext context, ChordCandidate candidate) async {
    final LiveController controller = context.read<LiveController>();
    if (controller.chordOf(candidate) == null) {
      return;
    }
    await controller.stopIfListening();
    if (!context.mounted) {
      return;
    }
    await context.push(
      '$kChordDetailPath?id=${Uri.encodeComponent(candidate.id)}',
    );
    if (context.mounted) {
      await controller.start(resume: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final LiveController controller = context.watch<LiveController>();
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController settings) => settings.mirrorChords,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ..._listeningSection(context, controller),
          const SizedBox(height: 20),
          _Section(
            title: context.t.liveChords.notesTitle,
            child: _notes(controller),
          ),
          ..._detectedSections(context, controller, mirror),
          const SizedBox(height: 20),
          _Section(
            title: context.t.liveChords.historyTitle,
            child: _history(context, controller),
          ),
        ],
      ),
    );
  }

  /// Aviso de micrófono, acorde en grande y nivel (o botón para activarlo).
  List<Widget> _listeningSection(
    BuildContext context,
    LiveController controller,
  ) {
    final bool problem = MicProblemCard.isProblem(controller.status);
    return <Widget>[
      if (problem) ...<Widget>[
        MicProblemCard(
          status: controller.status,
          onRetry: () => unawaited(controller.start(resume: true)),
        ),
        const SizedBox(height: 12),
      ],
      DetectedChordCard(
        phase: controller.phase,
        chord: controller.reading?.chord,
        bass: controller.reading?.bass,
      ),
      const SizedBox(height: 12),
      if (controller.status == MicStatus.listening)
        MicLevelBar(level: controller.reading?.level ?? 0)
      else if (!problem)
        FilledButton.icon(
          onPressed: () => unawaited(controller.start(resume: true)),
          icon: const Icon(Icons.mic_rounded),
          label: Text(context.t.tuner.activate),
        ),
    ];
  }

  Widget _notes(LiveController controller) {
    final ChordReading? reading = controller.reading;
    final bool detected = controller.phase == LiveChordPhase.detected;
    return ChromaBars(
      chroma: reading?.chroma ?? _flat,
      chordNotes: detected && reading?.chord != null
          ? reading!.chord!.pitchClasses
          : const <int>{},
      bass: reading?.bass,
    );
  }

  Widget _history(BuildContext context, LiveController controller) {
    if (controller.history.isEmpty) {
      return AppText(
        context.t.liveChords.historyEmpty,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        maxLines: 2,
      );
    }
    return ChordChipRow(
      chords: controller.history,
      highlightFirst: true,
      onOpen: (ChordCandidate chord) => unawaited(_open(context, chord)),
    );
  }

  /// Alternativas y diagrama: solo existen mientras hay un acorde reconocido.
  List<Widget> _detectedSections(
    BuildContext context,
    LiveController controller,
    bool mirror,
  ) {
    final ChordCandidate? detected = controller.reading?.chord;
    if (controller.phase != LiveChordPhase.detected || detected == null) {
      return const <Widget>[];
    }
    final Chord? chord = controller.chord;
    final ChordVariant? variant = controller.variant;
    final List<ChordCandidate> alternatives =
        controller.reading?.alternatives ?? const <ChordCandidate>[];
    return <Widget>[
      if (alternatives.isNotEmpty) ...<Widget>[
        const SizedBox(height: 20),
        _Section(
          title: context.t.liveChords.alternativesTitle,
          child: ChordChipRow(
            chords: alternatives,
            showConfidence: true,
            onOpen: (ChordCandidate chord) => unawaited(_open(context, chord)),
          ),
        ),
      ],
      if (chord != null && variant != null) ...<Widget>[
        const SizedBox(height: 20),
        ClosestPositionCard(
          chord: chord,
          variant: variant,
          mirror: mirror,
          onTap: () => unawaited(_open(context, detected)),
        ),
      ],
    ];
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AppText(title, variant: AppTextVariant.titleMedium),
      const SizedBox(height: 10),
      child,
    ],
  );
}
