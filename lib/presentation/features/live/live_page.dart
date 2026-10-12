import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/features/live/tuner_view.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/chord_card.dart';
import 'package:chords/presentation/widgets/molecules/mic_level_bar.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:chords/presentation/widgets/organisms/live_pitch_readout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Afinador automático con micrófono, y detección de acordes.
///
/// Escucha sola al entrar en la pestaña y se detiene al salir: no hay botón
/// de empezar. Un único icono en la barra alterna entre el afinador por
/// cuerdas y la detección de acordes; solo uno escucha a la vez.
class LivePage extends StatefulWidget {
  /// Crea la pantalla en vivo.
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  bool _chords = false;
  bool _visible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Dentro de las pestañas, la rama inactiva tiene los tickers apagados:
    // sirve para saber cuándo la pantalla se ve y empezar a escuchar.
    final bool visible = TickerMode.valuesOf(context).enabled;
    if (visible == _visible) {
      return;
    }
    _visible = visible;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(visible ? _listen() : _stopAll());
    });
  }

  Future<void> _listen() => _chords
      ? context.read<LiveController>().start()
      : context.read<TunerController>().start();

  Future<void> _stopAll() async {
    await context.read<LiveController>().stopIfListening();
    if (mounted) {
      await context.read<TunerController>().stopIfListening();
    }
  }

  Future<void> _toggleMode() async {
    await _stopAll();
    if (!mounted) {
      return;
    }
    setState(() => _chords = !_chords);
    await _listen();
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool glow =
        !_chords &&
        context.select<TunerController, bool>(
          (TunerController c) =>
              c.state.reading?.isInTune ??
              (c.state.allTuned && c.state.isListening),
        );
    final Color tint = Color.alphaBlend(
      chordColorsOf(context).inTune.withValues(alpha: 0.18),
      scheme.surface,
    );
    // El fondo se tiñe de verde al afinar, también tras la barra superior.
    return AnimatedContainer(
      duration: kMotionSlow,
      curve: kEmphasizedCurve,
      color: glow ? tint : scheme.surface,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(_chords ? t.tuner.chordsTitle : t.live.title),
          actions: <Widget>[
            IconButton(
              tooltip: _chords ? t.tuner.switchToTuner : t.tuner.switchToChords,
              icon: Icon(
                _chords ? Icons.tune_rounded : Icons.library_music_rounded,
              ),
              onPressed: () => unawaited(_toggleMode()),
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints box) =>
                SingleChildScrollView(
                  child: _chords
                      ? const _ChordsView()
                      : TunerView(minHeight: box.maxHeight),
                ),
          ),
        ),
      ),
    );
  }
}

/// Detección libre: nota, nivel y acordes sugeridos.
class _ChordsView extends StatelessWidget {
  const _ChordsView();

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final LiveController controller = context.watch<LiveController>();
    final bool listening = controller.status == MicStatus.listening;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
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
          const SizedBox(height: 12),
          if (listening)
            MicLevelBar(level: controller.level)
          else if (!MicProblemCard.isProblem(controller.status))
            FilledButton.icon(
              onPressed: controller.start,
              icon: const Icon(Icons.mic_rounded),
              label: Text(t.tuner.activate),
            ),
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
