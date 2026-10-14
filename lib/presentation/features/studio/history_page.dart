import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/chord_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Acordes del historial que existen en el banco, en orden.
List<Chord> historyChords(BuildContext context, List<String> ids) {
  final Map<String, Chord> byId = <String, Chord>{
    for (final Chord chord in context.read<ChordsController>().allChords)
      chord.id: chord,
  };
  return <Chord>[
    for (final String id in ids)
      if (byId[id] != null) byId[id]!,
  ];
}

/// Historial de acordes abiertos, del más reciente al más antiguo.
class HistoryPage extends StatelessWidget {
  /// Crea la pantalla.
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final StudioProgressController progress = context
        .watch<StudioProgressController>();
    final LearnController learn = context.watch<LearnController>();
    final List<Chord> chords = historyChords(context, progress.recentChordIds);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.studio.historyTitle),
        actions: <Widget>[
          if (chords.isNotEmpty)
            IconButton(
              tooltip: t.studio.clearHistory,
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: () => unawaited(progress.clearHistory()),
            ),
        ],
      ),
      body: SafeArea(
        child: chords.isEmpty
            ? AppEmptyState(
                icon: Icons.history_rounded,
                title: t.studio.historyEmptyTitle,
                message: t.studio.historyEmptyBody,
              )
            : ListView(
                padding: const EdgeInsets.only(bottom: 32),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: AppText(
                      t.studio.historyHint,
                      variant: AppTextVariant.labelMedium,
                    ),
                  ),
                  for (final Chord chord in chords)
                    ChordTile(
                      chord: chord,
                      mastered: learn.mastered.contains(chord.id),
                      onTap: () =>
                          unawaited(context.push(chordDetailRoute(chord.id))),
                      onPlay: () =>
                          unawaited(context.push(chordDetailRoute(chord.id))),
                      onToggleMastered: () =>
                          unawaited(learn.toggleMastered(chord.id)),
                    ),
                ],
              ),
      ),
    );
  }
}

/// Fila de acordes recientes (biblioteca e inicio); vacía si no hay.
class RecentChordsRow extends StatelessWidget {
  /// Crea la fila.
  const RecentChordsRow({super.key, this.padding = 16});

  /// Margen lateral.
  final double padding;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<String> ids = context
        .select<StudioProgressController, List<String>>(
          (StudioProgressController p) => p.recentChordIds,
        );
    final List<Chord> chords = historyChords(context, ids).take(12).toList();
    if (chords.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.history_rounded,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          for (final Chord chord in chords) ...<Widget>[
            ActionChip(
              label: Text(chord.name),
              tooltip: t.studio.recentTitle,
              onPressed: () =>
                  unawaited(context.push(chordDetailRoute(chord.id))),
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}
