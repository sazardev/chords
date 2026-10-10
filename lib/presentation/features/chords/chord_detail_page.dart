import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_loading.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/chord_play_button.dart';
import 'package:chords/presentation/widgets/atoms/difficulty_badge.dart';
import 'package:chords/presentation/widgets/atoms/section_header.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Detalle de un acorde: posición ampliada, sonido, arpegios y variantes.
class ChordDetailPage extends StatefulWidget {
  /// Crea el detalle.
  const ChordDetailPage({super.key});

  @override
  State<ChordDetailPage> createState() => _ChordDetailPageState();
}

class _ChordDetailPageState extends State<ChordDetailPage> {
  bool _loadRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadRequested) {
      return;
    }
    _loadRequested = true;
    final String? id = GoRouterState.of(context).uri.queryParameters['id'];
    if (id == null || id.isEmpty) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(context.read<ChordDetailController>().load(id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordDetailController controller = context
        .watch<ChordDetailController>();
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController settings) => settings.mirrorChords,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.chord?.name ?? t.chordDetail.titleFallback),
        actions: <Widget>[
          if (controller.chord != null)
            IconButton(
              tooltip: controller.isMastered
                  ? t.chordDetail.unmarkMastered
                  : t.chordDetail.markMastered,
              icon: Icon(
                controller.isMastered
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                color: controller.isMastered
                    ? chordColorsOf(context).openString
                    : null,
              ),
              onPressed: () => unawaited(controller.toggleMastered()),
            ),
          IconButton(
            tooltip: mirror
                ? t.chordDetail.leftHandModeOff
                : t.chordDetail.leftHandMode,
            icon: Icon(
              Icons.flip_rounded,
              color: mirror ? Theme.of(context).colorScheme.primary : null,
            ),
            onPressed: () {
              unawaited(
                context.read<SettingsController>().setMirrorChords(
                  value: !mirror,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(child: _resolveBody(controller, mirror)),
    );
  }

  /// Selecciona el contenido según el estado del controlador.
  Widget _resolveBody(ChordDetailController controller, bool mirror) {
    final Translations t = context.t;
    if (controller.loading) {
      return AppLoading(message: t.chordDetail.loading);
    }
    final ChordDetailProblem? problem = controller.problem;
    if (problem != null) {
      final String? chordId = GoRouterState.of(context)
          .uri
          .queryParameters['id'];
      return AppEmptyState(
        icon: Icons.music_off_rounded,
        title: t.chordDetail.errorTitle,
        message: switch (problem) {
          ChordDetailProblem.notFound => t.chordDetail.notFoundMessage(
            chordId: chordId ?? '',
          ),
          ChordDetailProblem.failed => t.chordDetail.loadFailed,
        },
      );
    }
    if (controller.chord == null) {
      return AppEmptyState(
        icon: Icons.music_off_rounded,
        title: t.chordDetail.noChordTitle,
        message: t.chordDetail.noChordMessage,
      );
    }
    return _chordBody(controller, mirror);
  }

  Widget _chordBody(ChordDetailController controller, bool mirror) {
    final Translations t = context.t;
    final ThemeData theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: <Widget>[
        const SizedBox(height: 12),
        Center(
          child: ChordDiagram(
            variant: controller.selectedVariant!,
            mirror: mirror,
            width: 200,
            height: 260,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: <Widget>[
              AppText(
                controller.chord!.name,
                variant: AppTextVariant.displayLarge,
              ),
              AppText(
                controller.chord!.displayName,
                variant: AppTextVariant.bodyLarge,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              DifficultyBadge(difficulty: controller.chord!.difficulty),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: controller.playSelected,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(t.chordDetail.listen),
              ),
            ],
          ),
        ),
        SectionHeader(title: t.chordDetail.arpeggios),
        _ArpeggioRow(controller: controller),
        SectionHeader(title: t.chordDetail.positions),
        for (int i = 0; i < controller.chord!.variants.length; i++)
          _variantTile(controller, i, theme),
      ],
    );
  }

  Widget _variantTile(
    ChordDetailController controller,
    int index,
    ThemeData theme,
  ) {
    final Translations t = context.t;
    final ChordVariant variant = controller.chord!.variants[index];
    final bool selected = index == controller.selectedIndex;
    return ListTile(
      selected: selected,
      leading: ChordDiagram(
        variant: variant,
        showFingers: false,
        width: 44,
        height: 56,
      ),
      title: Text(variant.positionLabel),
      subtitle: Text(t.chordDetail.notes(notes: variant.notes.join(' · '))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DifficultyBadge(difficulty: variant.difficulty, compact: true),
          const SizedBox(width: 8),
          ChordPlayButton(
            size: 36,
            tooltip: t.chordDetail.listenPosition(
              position: variant.positionLabel,
            ),
            onPressed: () {
              controller.selectVariant(index);
              unawaited(controller.playSelected());
            },
          ),
        ],
      ),
      onTap: () => controller.selectVariant(index),
      tileColor: selected ? theme.colorScheme.surfaceContainerHigh : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

/// Fila de patrones de arpegio del acorde.
class _ArpeggioRow extends StatelessWidget {
  const _ArpeggioRow({required this.controller});

  final ChordDetailController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          for (final ArpeggioPattern pattern
              in ArpeggioPattern.all) ...<Widget>[
            ActionChip(
              avatar: const Icon(Icons.music_note_rounded),
              label: Text(
                t.chordDetail.arpeggioChip(
                  label: arpeggioLabel(t, pattern),
                  level: pattern.difficulty,
                ),
              ),
              onPressed: () => unawaited(controller.playArpeggio(pattern)),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
