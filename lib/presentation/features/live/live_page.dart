import 'dart:async' show unawaited;

import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/chords_view.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/features/live/tuner_view.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:flutter/material.dart';
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
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              _ModeSwitch(
                chords: _chords,
                onChanged: () => unawaited(_toggleMode()),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints box) =>
                      SingleChildScrollView(
                        child: _chords
                            ? const ChordsView()
                            : TunerView(minHeight: box.maxHeight),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selector visible entre el afinador y la detección de acordes.
class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.chords, required this.onChanged});

  final bool chords;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: SegmentedButton<bool>(
        showSelectedIcon: false,
        segments: <ButtonSegment<bool>>[
          ButtonSegment<bool>(
            value: false,
            icon: const Icon(Icons.tune_rounded),
            label: Text(t.tuner.modeTuner),
          ),
          ButtonSegment<bool>(
            value: true,
            icon: const Icon(Icons.library_music_rounded),
            label: Text(t.tuner.modeChords),
          ),
        ],
        selected: <bool>{chords},
        onSelectionChanged: (Set<bool> mode) {
          if (mode.first != chords) {
            onChanged();
          }
        },
      ),
    );
  }
}
