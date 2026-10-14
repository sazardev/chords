import 'dart:async' show unawaited;

import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/theory/scale_explorer_controller.dart';
import 'package:chords/presentation/features/theory/scale_marks.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/organisms/scale_fretboard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Explorador de escalas: cualquier escala en cualquier tono sobre todo el
/// mástil, caja a caja, con notas o grados y sonido.
class ScaleExplorerPage extends StatefulWidget {
  /// Crea la pantalla.
  const ScaleExplorerPage({super.key});

  @override
  State<ScaleExplorerPage> createState() => _ScaleExplorerPageState();
}

class _ScaleExplorerPageState extends State<ScaleExplorerPage> {
  String? _appliedQuery;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Uri uri = GoRouterState.of(context).uri;
    if (uri.query == _appliedQuery) {
      return;
    }
    _appliedQuery = uri.query;
    final ScaleType? scale = ScaleType.fromId(uri.queryParameters['scale']);
    if (scale == null) {
      return;
    }
    final int tonic = int.tryParse(uri.queryParameters['key'] ?? '') ?? 0;
    final int position = int.tryParse(uri.queryParameters['pos'] ?? '') ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ScaleExplorerController>().show(
          scale,
          tonic,
          position: position,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ScaleExplorerController c = context.watch<ScaleExplorerController>();
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    return Scaffold(
      appBar: AppBar(title: Text(t.theory.explorerTitle)),
      floatingActionButton: _PlayButton(controller: c),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: <Widget>[
            _Label(t.theory.explorerTonic),
            KeyPicker(
              tonic: c.tonic,
              onSelected: (int pc) => c.show(c.scale, pc, position: c.position),
            ),
            const SizedBox(height: 12),
            _Label(t.theory.explorerScale),
            _ScalePicker(
              selected: c.scale,
              onSelected: (ScaleType scale) => c.show(scale, c.tonic),
            ),
            const SizedBox(height: 16),
            _Summary(scale: c.scale, tonic: c.tonic),
            const SizedBox(height: 12),
            _PositionHeader(controller: c),
            const SizedBox(height: 8),
            PositionChips(
              count: c.positionCount,
              selected: c.position,
              onSelected: (int p) => c.show(c.scale, c.tonic, position: p),
            ),
            const SizedBox(height: 12),
            ScaleFretboardCard(controller: c, mirror: mirror),
            const SizedBox(height: 8),
            AppText(
              t.theory.explorerHint,
              variant: AppTextVariant.labelMedium,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              maxLines: 3,
            ),
            if (_hasHarmony(c.scale)) ...<Widget>[
              const SizedBox(height: 16),
              HarmonyCard(
                musicalKey: MusicalKey(
                  c.tonic,
                  minor: c.scale == ScaleType.naturalMinor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// `true` si la escala da una tonalidad mayor o menor con sus acordes.
bool _hasHarmony(ScaleType scale) =>
    scale == ScaleType.major || scale == ScaleType.naturalMinor;

/// El mástil del explorador dentro de una tarjeta.
class ScaleFretboardCard extends StatelessWidget {
  /// Crea la tarjeta.
  const ScaleFretboardCard({
    required this.controller,
    required this.mirror,
    super.key,
  });

  /// Controlador del explorador.
  final ScaleExplorerController controller;

  /// Dibujo para zurdos.
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ScaleExplorerController c = controller;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: ScaleFretboard(
        marks: scaleMarks(
          t,
          c.scale,
          c.tonic,
          position: c.position,
          degrees: c.showDegrees,
        ),
        window: positionWindow(c.scale, c.tonic, c.position),
        mirror: mirror,
        semanticLabel: t.theory.fretboardLabel(
          scale: scaleInKey(t, c.scale, c.tonic),
        ),
        onTap: (FretPosition note) => unawaited(c.playNote(note)),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.controller});

  final ScaleExplorerController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final bool playing = controller.isPlaying;
    return FloatingActionButton.extended(
      onPressed: () => unawaited(controller.play()),
      icon: Icon(playing ? Icons.stop_rounded : Icons.play_arrow_rounded),
      label: Text(playing ? t.theory.stopScale : t.theory.playScale),
    );
  }
}

class _PositionHeader extends StatelessWidget {
  const _PositionHeader({required this.controller});

  final ScaleExplorerController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Row(
      children: <Widget>[
        Expanded(child: _Label(t.theory.explorerPosition)),
        SegmentedButton<bool>(
          segments: <ButtonSegment<bool>>[
            ButtonSegment<bool>(value: false, label: Text(t.theory.showNotes)),
            ButtonSegment<bool>(value: true, label: Text(t.theory.showDegrees)),
          ],
          selected: <bool>{controller.showDegrees},
          onSelectionChanged: (_) => controller.toggleLabels(),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: AppText(text, variant: AppTextVariant.labelLarge),
  );
}

class _ScalePicker extends StatelessWidget {
  const _ScalePicker({required this.selected, required this.onSelected});

  final ScaleType selected;
  final ValueChanged<ScaleType> onSelected;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: <Widget>[
        for (final ScaleType scale in ScaleType.values)
          ChoiceChip(
            label: Text(scaleTitle(t, scale)),
            selected: scale == selected,
            onSelected: (_) => onSelected(scale),
          ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.scale, required this.tonic});

  final ScaleType scale;
  final int tonic;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String formula = scale.intervals
        .map((int i) => degreeSymbol(0, i, scale: scale))
        .join(' ');
    final String notes = scale
        .pitchClasses(tonic)
        .map((int pc) => noteLabel(t, pc))
        .join(' · ');
    return AppCard(
      color: scheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            capitalized(scaleInKey(t, scale, tonic)),
            variant: AppTextVariant.titleLarge,
            color: scheme.onPrimaryContainer,
          ),
          const SizedBox(height: 4),
          AppText(
            scaleAbout(t, scale),
            color: scheme.onPrimaryContainer,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          AppText(
            t.theory.formula(formula: formula),
            variant: AppTextVariant.labelLarge,
            color: scheme.onPrimaryContainer,
          ),
          AppText(
            t.theory.notesOf(notes: notes),
            variant: AppTextVariant.labelLarge,
            color: scheme.onPrimaryContainer,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
