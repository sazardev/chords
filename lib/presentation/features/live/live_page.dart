import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/l10n/translations.g.dart';
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
    final Translations t = context.t;
    final LiveController controller = context.watch<LiveController>();
    final bool listening = controller.status == MicStatus.listening;
    return Scaffold(
      appBar: AppBar(title: Text(t.live.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: <Widget>[
              LivePitchReadout(
                status: controller.status,
                reading: controller.reading,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: controller.toggleListening,
                icon: Icon(listening ? Icons.stop_rounded : Icons.mic_rounded),
                label: Text(listening ? t.live.stop : t.live.listen),
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
        ),
      ),
    );
  }
}

/// Lista de acordes sugeridos por la afinación en vivo.
class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.chords});

  final List<Chord> chords;

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
              onTap: () => context.go(
                '$kChordDetailPath?id=${Uri.encodeComponent(chord.id)}',
              ),
              onPlay: () => context.go(
                '$kChordDetailPath?id=${Uri.encodeComponent(chord.id)}',
              ),
            ),
          ),
      ],
    );
  }
}
