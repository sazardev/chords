import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:chords/domain/theory/services/scale_positions.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/theory/scale_explorer_controller.dart';
import 'package:chords/presentation/features/theory/scale_marks.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/organisms/scale_fretboard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Ruta de la ficha de un acorde del banco.
String chordDetailRoute(String chordId) =>
    '$kChordDetailPath?id=${Uri.encodeComponent(chordId)}';

/// Fila desplazable con las 12 notas para elegir una tónica.
class KeyPicker extends StatelessWidget {
  /// Crea el selector.
  const KeyPicker({required this.tonic, required this.onSelected, super.key});

  /// Tónica elegida (0 = Do).
  final int tonic;

  /// Se llama al elegir otra tónica.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (int pc = 0; pc < 12; pc++) ...<Widget>[
            if (pc > 0) const SizedBox(width: 6),
            ChoiceChip(
              label: Text(noteLabel(t, pc)),
              selected: pc == tonic,
              onSelected: (_) => onSelected(pc),
            ),
          ],
        ],
      ),
    );
  }
}

/// Los siete acordes de una tonalidad con su grado; al tocarlos abre su ficha.
class HarmonyCard extends StatelessWidget {
  /// Crea la tarjeta de la tonalidad [musicalKey].
  const HarmonyCard({required this.musicalKey, super.key});

  /// Tonalidad.
  final MusicalKey musicalKey;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<DiatonicChord> chords = musicalKey.harmony();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            t.theory.harmonyTitle(
              key: keyName(t, musicalKey.tonic, minor: musicalKey.minor),
            ),
            variant: AppTextVariant.titleMedium,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final DiatonicChord chord in chords)
                ActionChip(
                  avatar: CircleAvatar(
                    backgroundColor: chord.degree == 1
                        ? scheme.primary
                        : scheme.secondaryContainer,
                    child: Text(
                      chord.roman,
                      style: TextStyle(
                        fontSize: 9,
                        color: chord.degree == 1
                            ? scheme.onPrimary
                            : scheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  label: Text(chord.symbol.name),
                  onPressed: () => unawaited(
                    context.push(chordDetailRoute(chord.symbol.chordId)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Patrón de rasgueo con flechas; resalta el hueco [active] si se indica.
class StrumPatternView extends StatelessWidget {
  /// Crea la vista.
  const StrumPatternView({required this.pattern, super.key, this.active});

  /// Patrón.
  final StrumPattern pattern;

  /// Hueco que suena ahora.
  final int? active;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<StrumStroke> strokes = pattern.strokes;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < strokes.length; i++)
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: i == active
                    ? scheme.primary
                    : (i.isEven
                          ? scheme.surfaceContainerHighest
                          : scheme.surfaceContainerHigh),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    strumGlyph(pattern, i),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: i == active ? scheme.onPrimary : scheme.onSurface,
                    ),
                  ),
                  Text(
                    i.isEven ? '${i ~/ 2 + 1}' : '+',
                    style: TextStyle(
                      fontSize: 11,
                      color: i == active
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Demostración de una escala en el mástil, con sus posiciones si se piden
/// y un enlace al explorador.
class ScaleDemo extends StatefulWidget {
  /// Crea la demostración.
  const ScaleDemo({
    required this.scale,
    required this.tonic,
    super.key,
    this.showPositions = false,
  });

  /// Escala.
  final ScaleType scale;

  /// Tónica.
  final int tonic;

  /// `true` para ofrecer el selector de posiciones.
  final bool showPositions;

  @override
  State<ScaleDemo> createState() => _ScaleDemoState();
}

class _ScaleDemoState extends State<ScaleDemo> {
  late int _position = widget.showPositions ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    final int count = ScalePositions(
      widget.scale,
      widget.tonic,
    ).positions().length;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            capitalized(scaleInKey(t, widget.scale, widget.tonic)),
            variant: AppTextVariant.titleMedium,
          ),
          AppText(
            scaleAbout(t, widget.scale),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          ScaleFretboard(
            marks: scaleMarks(
              t,
              widget.scale,
              widget.tonic,
              position: _position,
            ),
            window: positionWindow(widget.scale, widget.tonic, _position),
            mirror: mirror,
            semanticLabel: t.theory.fretboardLabel(
              scale: scaleInKey(t, widget.scale, widget.tonic),
            ),
            onTap: (FretPosition note) => unawaited(
              context.read<ScaleExplorerController>().playNote(note),
            ),
          ),
          if (widget.showPositions) ...<Widget>[
            const SizedBox(height: 8),
            PositionChips(
              count: count,
              selected: _position,
              onSelected: (int p) => setState(() => _position = p),
            ),
          ],
          const SizedBox(height: 8),
          TextButton.icon(
            icon: const Icon(Icons.open_in_new_rounded),
            label: Text(t.theory.openExplorer),
            onPressed: () => unawaited(
              context.push(
                '$kScalesPath?scale=${widget.scale.id}'
                '&key=${widget.tonic}&pos=$_position',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chips de posición reutilizables (todo el mástil y cada caja).
class PositionChips extends StatelessWidget {
  /// Crea los chips.
  const PositionChips({
    required this.count,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Número de posiciones.
  final int count;

  /// Posición elegida (0 = todas).
  final int selected;

  /// Se llama al elegir.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (int p = 0; p <= count; p++) ...<Widget>[
            if (p > 0) const SizedBox(width: 6),
            ChoiceChip(
              label: Text(p == 0 ? t.theory.allPositions : '$p'),
              selected: p == selected,
              onSelected: (_) => onSelected(p),
            ),
          ],
        ],
      ),
    );
  }
}
