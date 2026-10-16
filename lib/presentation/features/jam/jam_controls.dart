import 'dart:async' show unawaited;

import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/features/jam/jam_tempo_control.dart';
import 'package:flutter/material.dart';

/// Mandos de la escena: tempo preciso, pausa y terminar.
class JamControls extends StatelessWidget {
  /// Crea los mandos.
  const JamControls({required this.state, required this.controller, super.key});

  /// Estado de la sesión.
  final JamState state;

  /// Controlador del jam.
  final JamController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final bool paused = state.phase == JamPhase.paused;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          JamTempoControl(
            bpm: state.track!.bpm,
            onChanged: controller.setTempo,
          ),
          const SizedBox(height: 4),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  icon: Icon(
                    paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  ),
                  label: Text(paused ? t.jam.resume : t.jam.pause),
                  onPressed:
                      state.phase == JamPhase.countIn ||
                          state.phase == JamPhase.loading
                      ? null
                      : controller.togglePause,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                tooltip: t.jam.stop,
                icon: const Icon(Icons.stop_rounded),
                onPressed: () => unawaited(controller.stop()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
