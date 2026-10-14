import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/jam_selection.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Máximo de acordes de una progresión propia.
const int kCustomMaxChords = 8;

/// Constructor de una progresión propia: se elige un tono y se van tocando
/// los acordes de su paleta (los de la tonalidad y algunos prestados).
class JamCustomBuilder extends StatefulWidget {
  /// Crea el constructor.
  const JamCustomBuilder({
    required this.selection,
    required this.onChanged,
    super.key,
  });

  /// Selección actual (contiene los acordes elegidos).
  final JamSelection selection;

  /// Se llama al cambiar los acordes.
  final ValueChanged<JamSelection> onChanged;

  @override
  State<JamCustomBuilder> createState() => _JamCustomBuilderState();
}

class _JamCustomBuilderState extends State<JamCustomBuilder> {
  int _tonic = 7;

  /// Acordes de la tonalidad más los prestados más habituales (V7, I7,
  /// bVII y iv).
  List<ChordSymbol> _palette() {
    final MusicalKey key = MusicalKey(_tonic);
    return <ChordSymbol>[
      for (final DiatonicChord chord in key.harmony())
        if (chord.symbol.quality != ChordQuality.diminished) chord.symbol,
      ChordSymbol((_tonic + 7) % 12, ChordQuality.seven),
      ChordSymbol(_tonic, ChordQuality.seven),
      ChordSymbol((_tonic + 10) % 12, ChordQuality.major),
      ChordSymbol((_tonic + 5) % 12, ChordQuality.minor),
    ];
  }

  void _add(ChordSymbol chord) {
    final List<ChordSymbol> current = widget.selection.custom;
    if (current.length >= kCustomMaxChords) {
      return;
    }
    widget.onChanged(
      widget.selection.copyWith(custom: <ChordSymbol>[...current, chord]),
    );
  }

  void _removeLast() {
    final List<ChordSymbol> current = widget.selection.custom;
    widget.onChanged(
      widget.selection.copyWith(
        custom: current.take(current.length - 1).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<ChordSymbol> chosen = widget.selection.custom;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppText(t.jam.customHint, maxLines: 3),
        const SizedBox(height: 8),
        KeyPicker(
          tonic: _tonic,
          onSelected: (int pc) => setState(() => _tonic = pc),
        ),
        const SizedBox(height: 4),
        AppText(keyName(t, _tonic), variant: AppTextVariant.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: <Widget>[
            for (final ChordSymbol chord in _palette())
              ActionChip(
                avatar: const Icon(Icons.add_rounded, size: 18),
                label: Text(chord.name),
                onPressed: () => _add(chord),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _ChosenCard(
          chosen: chosen,
          onRemoveLast: _removeLast,
          onClear: () => widget.onChanged(
            widget.selection.copyWith(custom: <ChordSymbol>[]),
          ),
        ),
      ],
    );
  }
}

class _ChosenCard extends StatelessWidget {
  const _ChosenCard({
    required this.chosen,
    required this.onRemoveLast,
    required this.onClear,
  });

  final List<ChordSymbol> chosen;
  final VoidCallback onRemoveLast;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            chosen.isEmpty
                ? t.jam.customEmpty
                : chosen.map((ChordSymbol c) => c.name).join('  →  '),
            variant: AppTextVariant.titleMedium,
            color: scheme.onSecondaryContainer,
            maxLines: 3,
          ),
          if (chosen.isNotEmpty)
            Wrap(
              spacing: 4,
              children: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.backspace_rounded),
                  label: Text(t.jam.removeLast),
                  onPressed: onRemoveLast,
                ),
                TextButton(onPressed: onClear, child: Text(t.jam.clear)),
              ],
            ),
        ],
      ),
    );
  }
}
