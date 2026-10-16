import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/note_labels.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:flutter/material.dart';

/// Las 12 notas en vivo: una barra por nota con la energía que suena.
///
/// Las notas del acorde reconocido se pintan con el color principal y su
/// nombre en negrita; el resto, en gris. Una marca bajo la nota del bajo dice
/// cuál es la más grave que suena. Las barras se animan para que la lectura
/// sea fluida aunque lleguen 10 lecturas por segundo.
class ChromaBars extends StatelessWidget {
  /// Crea las barras del cromagrama.
  const ChromaBars({
    required this.chroma,
    required this.chordNotes,
    super.key,
    this.bass,
  });

  /// Energía de cada nota (0-1), con el Do en la posición 0.
  final List<double> chroma;

  /// Clases de nota del acorde reconocido (vacío si no hay ninguno).
  final Set<int> chordNotes;

  /// Clase de nota del bajo, si se distingue.
  final int? bass;

  /// Alto máximo de una barra.
  static const double maxBarHeight = 76;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Semantics(
      container: true,
      label: t.liveChords.notesLabel,
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            for (int note = 0; note < 12; note++)
              Expanded(
                child: _NoteBar(
                  label: noteLabel(context, note),
                  value: note < chroma.length ? chroma[note] : 0,
                  inChord: chordNotes.contains(note),
                  isBass: bass == note,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NoteBar extends StatelessWidget {
  const _NoteBar({
    required this.label,
    required this.value,
    required this.inChord,
    required this.isBass,
  });

  final String label;
  final double value;
  final bool inChord;
  final bool isBass;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double height = 4 + ChromaBars.maxBarHeight * value.clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedContainer(
            duration: kMotionFast,
            curve: kStandardCurve,
            height: height,
            decoration: BoxDecoration(
              color: inChord ? scheme.primary : scheme.outlineVariant,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: inChord ? scheme.primary : scheme.onSurfaceVariant,
                fontWeight: inChord ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            height: 3,
            width: 14,
            decoration: BoxDecoration(
              color: isBass ? scheme.tertiary : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
