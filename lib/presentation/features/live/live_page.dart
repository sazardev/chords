import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/features/live/tuner_view.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/chord_card.dart';
import 'package:chords/presentation/widgets/molecules/mic_level_bar.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:chords/presentation/widgets/organisms/live_pitch_readout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Afinador por cuerdas y escucha de acordes con el micrófono.
///
/// Dos pestañas: "Afinar" guía cuerda a cuerda con el cabezal de la guitarra
/// y "Acordes" detecta una nota y sugiere acordes. Solo una escucha a la vez:
/// al cambiar de pestaña se detiene el micrófono de la otra.
class LivePage extends StatefulWidget {
  /// Crea la pantalla en vivo.
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  int _tab = 0;

  void _select(int tab) {
    if (tab == _tab) {
      return;
    }
    if (tab == 0) {
      unawaited(context.read<LiveController>().stopIfListening());
    } else {
      unawaited(context.read<TunerController>().stopIfListening());
    }
    setState(() => _tab = tab);
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.live.title)),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: <ButtonSegment<int>>[
                    ButtonSegment<int>(
                      value: 0,
                      icon: const Icon(Icons.tune_rounded),
                      label: Text(t.tuner.tabTune),
                    ),
                    ButtonSegment<int>(
                      value: 1,
                      icon: const Icon(Icons.library_music_rounded),
                      label: Text(t.tuner.tabListen),
                    ),
                  ],
                  selected: <int>{_tab},
                  onSelectionChanged: (Set<int> value) => _select(value.first),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: _tab == 0
                    ? const TunerView(showToggle: false)
                    : const _ListenTab(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: _tab == 0
                  ? const TunerToggleButton()
                  : const _ListenToggleButton(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Escucha libre: lectura de la nota, medidor y acordes sugeridos.
class _ListenTab extends StatelessWidget {
  const _ListenTab();

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final LiveController controller = context.watch<LiveController>();
    final bool listening = controller.status == MicStatus.listening;
    return Column(
      children: <Widget>[
        if (MicProblemCard.isProblem(controller.status)) ...<Widget>[
          MicProblemCard(
            status: controller.status,
            onRetry: () => unawaited(controller.start()),
          ),
          const SizedBox(height: 12),
        ],
        LivePitchReadout(
          status: controller.status,
          reading: controller.reading,
        ),
        if (listening) ...<Widget>[
          const SizedBox(height: 12),
          MicLevelBar(level: controller.level),
        ],
        const SizedBox(height: 20),
        if (controller.suggestions.isEmpty)
          AppEmptyState(
            icon: Icons.music_note_rounded,
            title: t.live.emptyTitle,
            message: t.live.emptyMessage,
          )
        else
          _Suggestions(chords: controller.suggestions),
      ],
    );
  }
}

/// Botón fijo para empezar o detener la escucha libre.
class _ListenToggleButton extends StatelessWidget {
  const _ListenToggleButton();

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final LiveController controller = context.watch<LiveController>();
    final bool listening = controller.status == MicStatus.listening;
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: controller.toggleListening,
        icon: Icon(listening ? Icons.stop_rounded : Icons.mic_rounded),
        label: Text(listening ? t.live.stop : t.live.listen),
      ),
    );
  }
}

/// Lista de acordes sugeridos por la afinación en vivo.
class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.chords});

  final List<Chord> chords;

  /// Detiene la escucha y abre la ficha del acorde sugerido.
  void _openChord(BuildContext context, Chord chord) {
    unawaited(context.read<LiveController>().stopIfListening());
    unawaited(
      context.push('$kChordDetailPath?id=${Uri.encodeComponent(chord.id)}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText(t.live.suggestions, variant: AppTextVariant.titleLarge),
        const SizedBox(height: 8),
        for (final Chord chord in chords)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ChordCard(
              chord: chord,
              onTap: () => _openChord(context, chord),
              onPlay: () => _openChord(context, chord),
            ),
          ),
      ],
    );
  }
}
