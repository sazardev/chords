import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/services/chord_insights.dart';
import 'package:chords/domain/profile/entities/playing_style.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:chords/presentation/features/chords/chord_notes_section.dart';
import 'package:chords/presentation/features/chords/chord_position_guide.dart';
import 'package:chords/presentation/features/chords/chord_relatives_section.dart';
import 'package:chords/presentation/features/chords/chord_usage_section.dart';
import 'package:chords/presentation/features/chords/chord_variants_section.dart';
import 'package:chords/presentation/features/profile/profile_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_loading.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/difficulty_badge.dart';
import 'package:chords/presentation/widgets/atoms/section_header.dart';
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
  String? _loadedId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? id = GoRouterState.of(context).uri.queryParameters['id'];
    if (id == null || id.isEmpty || id == _loadedId) {
      return;
    }
    _loadedId = id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_load(id));
      }
    });
  }

  /// Carga el acorde y lo reproduce automáticamente al entrar en la ficha.
  Future<void> _load(String id) async {
    final ChordDetailController controller = context
        .read<ChordDetailController>();
    final StudioProgressController studio = context
        .read<StudioProgressController>();
    await controller.load(id);
    if (!mounted || controller.chord?.id != id) {
      return;
    }
    unawaited(studio.recordChord(id));
    await controller.playSelected();
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
  ///
  /// Mientras el acorde cargado no coincida con el de la ruta, se muestra la
  /// carga: evita ver la ficha del acorde anterior al navegar entre fichas.
  Widget _resolveBody(ChordDetailController controller, bool mirror) {
    final Translations t = context.t;
    final String? chordId = GoRouterState.of(context).uri.queryParameters['id'];
    if (chordId == null || chordId.isEmpty) {
      return AppEmptyState(
        icon: Icons.music_off_rounded,
        title: t.chordDetail.noChordTitle,
        message: t.chordDetail.noChordMessage,
      );
    }
    final ChordDetailProblem? problem = controller.problem;
    if (problem != null) {
      return AppEmptyState(
        icon: Icons.music_off_rounded,
        title: t.chordDetail.errorTitle,
        message: switch (problem) {
          ChordDetailProblem.notFound => t.chordDetail.notFoundMessage(
            chordId: chordId,
          ),
          ChordDetailProblem.failed => t.chordDetail.loadFailed,
        },
      );
    }
    final Chord? chord = controller.chord;
    if (controller.loading || chord == null || chord.id != chordId) {
      return AppLoading(message: t.chordDetail.loading);
    }
    return _chordBody(controller, mirror);
  }

  Widget _chordBody(ChordDetailController controller, bool mirror) {
    final Translations t = context.t;
    final Chord chord = controller.chord!;
    final ChordInsights? insights = controller.insights;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: <Widget>[
        const SizedBox(height: 12),
        ChordPositionDiagram(
          variant: controller.selectedVariant!,
          mirror: mirror,
        ),
        const SizedBox(height: 12),
        _ChordSummary(
          controller: controller,
          onPractice: () => unawaited(_practice(controller)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ChordPositionGuide(variant: controller.selectedVariant!),
        ),
        if (insights != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ChordNotesSection(chord: chord, insights: insights),
          ),
        SectionHeader(title: t.chordDetail.arpeggios),
        _ArpeggioRow(controller: controller),
        ChordVariantsSection(controller: controller),
        if (insights != null) ...<Widget>[
          ChordRelativesSection(chord: chord, insights: insights),
          ChordUsageSection(chord: chord, insights: insights),
        ],
      ],
    );
  }

  /// Abre la práctica cuerda a cuerda de la posición seleccionada.
  Future<void> _practice(ChordDetailController controller) async {
    final String id = Uri.encodeComponent(controller.chord!.id);
    await context.push(
      '$kChordPracticePath?id=$id&v=${controller.selectedIndex}',
    );
  }
}

/// Nombre, dificultad y botones de escuchar y practicar.
class _ChordSummary extends StatelessWidget {
  const _ChordSummary({required this.controller, required this.onPractice});

  final ChordDetailController controller;
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final Chord chord = controller.chord!;
    return Center(
      child: Column(
        children: <Widget>[
          AppText(chord.name, variant: AppTextVariant.displayLarge),
          AppText(
            chord.displayName,
            variant: AppTextVariant.bodyLarge,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          DifficultyBadge(difficulty: chord.difficulty),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: <Widget>[
              FilledButton.icon(
                onPressed: controller.playSelected,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(t.chordDetail.listen),
              ),
              FilledButton.tonalIcon(
                onPressed: onPractice,
                icon: const Icon(Icons.mic_rounded),
                label: Text(t.chordDetail.practice),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Fila de patrones de arpegio del acorde.
///
/// Si la persona toca con los dedos, el fingerstyle va el primero.
class _ArpeggioRow extends StatelessWidget {
  const _ArpeggioRow({required this.controller});

  final ChordDetailController controller;

  List<ArpeggioPattern> _ordered(PlayingStyle style) {
    if (style != PlayingStyle.fingers) {
      return ArpeggioPattern.all;
    }
    return <ArpeggioPattern>[
      ArpeggioPattern.fingerstyle,
      ...ArpeggioPattern.all.where(
        (ArpeggioPattern p) => p != ArpeggioPattern.fingerstyle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          for (final ArpeggioPattern pattern in _ordered(
            context.watch<ProfileController>().profile.style,
          )) ...<Widget>[
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
