import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/router/route_paths.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/chord_card.dart';
import 'package:chords/presentation/widgets/organisms/live_pitch_readout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Afinación en vivo: detecta notas con el micrófono y sugiere acordes.
class LivePage extends StatelessWidget {
  /// Crea la pantalla en vivo.
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveController controller = context.watch<LiveController>();
    final bool listening = controller.status == MicStatus.listening;

    return Scaffold(
      appBar: AppBar(title: const Text('Afinación en vivo')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: LivePitchReadout(
                status: controller.status,
                reading: controller.reading,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: controller.toggleListening,
              icon: Icon(listening ? Icons.stop_rounded : Icons.mic_rounded),
              label: Text(listening ? 'Detener' : 'Escuchar guitararra'),
            ),
            const SizedBox(height: 16),
            Expanded(child: _suggestions(context, controller)),
          ],
        ),
      ),
    );
  }

  Widget _suggestions(BuildContext context, LiveController controller) {
    final List<Chord> suggestions = controller.suggestions;
    if (suggestions.isEmpty) {
      return const AppEmptyState(
        icon: Icons.music_note_rounded,
        title: 'Sin sugerencias aún',
        message: 'Pulsa escuchar y toca un acorde para ver coincidencias.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: AppText('Sugerencias', variant: AppTextVariant.titleLarge),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: suggestions.length,
            itemBuilder: (BuildContext context, int index) {
              final Chord chord = suggestions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ChordCard(
                  chord: chord,
                  onTap: () => context.go(
                    '$kChordDetailPath?id=${Uri.encodeComponent(chord.id)}',
                  ),
                  onPlay: () => context.go(
                    '$kChordDetailPath?id=${Uri.encodeComponent(chord.id)}',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
