import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_tone.dart';
import 'package:chords/domain/chords/services/chord_insights.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/services/chord_key_roles.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Máximo de tonalidades que se enseñan en la ficha.
const int kMaxKeyChips = 8;

/// Qué es el acorde: sus notas con el grado de cada una, la fórmula y las
/// tonalidades en las que aparece.
class ChordNotesSection extends StatelessWidget {
  /// Crea la sección del [chord] con su información [insights].
  const ChordNotesSection({
    required this.chord,
    required this.insights,
    super.key,
  });

  /// Acorde mostrado.
  final Chord chord;

  /// Notas, tonalidades y demás datos del acorde.
  final ChordInsights insights;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            t.chordTheory.notesTitle,
            variant: AppTextVariant.titleMedium,
          ),
          const SizedBox(height: 4),
          AppText(
            qualityDescription(t, chord.quality),
            color: scheme.onSurfaceVariant,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final ChordTone tone in insights.tones)
                _ToneChip(tone: tone),
            ],
          ),
          const SizedBox(height: 10),
          AppText(
            t.chordTheory.formulaLine(
              formula: chord.quality.formula.join('  '),
            ),
            variant: AppTextVariant.labelLarge,
          ),
          if (insights.keyRoles.isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            AppText(
              t.chordTheory.keysTitle,
              variant: AppTextVariant.labelLarge,
            ),
            AppText(
              t.chordTheory.keysHint,
              variant: AppTextVariant.labelMedium,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            _KeyChips(roles: insights.keyRoles),
          ],
        ],
      ),
    );
  }
}

/// Una nota del acorde con su grado debajo; las que se pueden omitir van
/// atenuadas.
class _ToneChip extends StatelessWidget {
  const _ToneChip({required this.tone});

  final ChordTone tone;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool root = tone.degree == '1';
    final Color fill = root ? scheme.primary : scheme.secondaryContainer;
    final Color ink = root ? scheme.onPrimary : scheme.onSecondaryContainer;
    final String interval =
        t.chordTheory.intervalNames[tone.degree] ?? tone.degree;
    final String note = noteLabel(t, tone.pitchClass);
    final String meaning = t.chordTheory.noteMeaning(
      note: note,
      interval: interval,
    );
    return Tooltip(
      message: tone.isOptional
          ? '$meaning · ${t.chordTheory.optionalNote}'
          : meaning,
      child: Semantics(
        label: meaning,
        child: Container(
          constraints: const BoxConstraints(minWidth: 56),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: tone.isOptional ? fill.withValues(alpha: 0.55) : fill,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                noteLabel(t, tone.pitchClass),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: ink, fontWeight: FontWeight.w800),
              ),
              Text(
                tone.degree,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tonalidades donde el acorde cae en un grado (las mayores primero).
class _KeyChips extends StatelessWidget {
  const _KeyChips({required this.roles});

  final List<ChordKeyRole> roles;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final ChordKeyRole role in roles.take(kMaxKeyChips))
          Chip(
            label: Text(
              t.chordTheory.keyChip(roman: role.roman, key: _keyName(t, role)),
            ),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }

  String _keyName(Translations t, ChordKeyRole role) {
    final String note = noteLabel(t, role.tonic);
    return role.scale == ScaleType.major
        ? t.chordTheory.keyMajor(note: note)
        : t.chordTheory.keyMinor(note: note);
  }
}
