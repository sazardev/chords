import 'dart:async' show unawaited;

import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/jam_selection.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Elección de la progresión del jam: primero el género y luego la
/// progresión de ese estilo, para no recorrer cien opciones seguidas.
class JamProgressionPicker extends StatelessWidget {
  /// Crea el selector.
  const JamProgressionPicker({
    required this.selection,
    required this.onChanged,
    super.key,
  });

  /// Selección actual.
  final JamSelection selection;

  /// Se llama al cambiar la selección.
  final ValueChanged<JamSelection> onChanged;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordProgression current = selection.progression;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _GenreChips(
          genre: current.genre,
          onSelected: (String genre) => onChanged(
            selection.copyWith(
              progressionId: progressionsOf(genre).first.id,
              resetTonic: true,
            ),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: ValueKey<String>(current.genre),
          initialValue: current.id,
          isExpanded: true,
          decoration: InputDecoration(labelText: t.jam.chooseTrack),
          items: <DropdownMenuItem<String>>[
            for (final ChordProgression p in progressionsOf(current.genre))
              DropdownMenuItem<String>(
                value: p.id,
                child: Text(
                  '${progressionName(t, p)} · ${p.summary}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (String? id) => onChanged(
            selection.copyWith(progressionId: id, resetTonic: true),
          ),
        ),
        const SizedBox(height: 12),
        AppText(t.jam.key, variant: AppTextVariant.labelLarge),
        const SizedBox(height: 6),
        KeyPicker(
          tonic: selection.progressionTonic,
          onSelected: (int pc) => onChanged(selection.copyWith(tonic: pc)),
        ),
        const SizedBox(height: 6),
        AppText(
          keyName(t, selection.progressionTonic, minor: current.minor),
          variant: AppTextVariant.titleMedium,
        ),
      ],
    );
  }
}

/// Fila desplazable con un chip por género; deja visible el elegido.
class _GenreChips extends StatefulWidget {
  const _GenreChips({required this.genre, required this.onSelected});

  final String genre;
  final ValueChanged<String> onSelected;

  @override
  State<_GenreChips> createState() => _GenreChipsState();
}

class _GenreChipsState extends State<_GenreChips> {
  final GlobalKey _selectedKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _revealSelected();
  }

  @override
  void didUpdateWidget(covariant _GenreChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.genre != widget.genre) {
      _revealSelected();
    }
  }

  void _revealSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? target = _selectedKey.currentContext;
      if (mounted && target != null) {
        unawaited(
          Scrollable.ensureVisible(
            target,
            alignment: 0.5,
            duration: kMotionMedium,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (final GenreGuide guide in kGenreGuides)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                key: guide.id == widget.genre ? _selectedKey : null,
                label: Text('${guide.emoji} ${genreGuideName(t, guide.id)}'),
                selected: guide.id == widget.genre,
                onSelected: (_) => widget.onSelected(guide.id),
              ),
            ),
        ],
      ),
    );
  }
}
