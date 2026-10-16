import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Fila de chips tocables con acordes: alternativas probables o historial.
///
/// Cada chip dice el nombre del acorde (y, si [showConfidence], lo seguro que
/// es) y abre su ficha al tocarlo. El primero puede resaltarse como el más
/// reciente con [highlightFirst].
class ChordChipRow extends StatelessWidget {
  /// Crea la fila para [chords]; [onOpen] abre la ficha de uno.
  const ChordChipRow({
    required this.chords,
    required this.onOpen,
    super.key,
    this.showConfidence = false,
    this.highlightFirst = false,
  });

  /// Acordes a mostrar, en orden.
  final List<ChordCandidate> chords;

  /// Se llama con el acorde pulsado.
  final void Function(ChordCandidate chord) onOpen;

  /// Si cada chip añade su porcentaje de confianza.
  final bool showConfidence;

  /// Si el primer chip se pinta relleno (el más reciente).
  final bool highlightFirst;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (int i = 0; i < chords.length; i++)
          Semantics(
            button: true,
            label: t.liveChords.openChord(name: chords[i].name),
            child: ExcludeSemantics(
              child: ActionChip(
                onPressed: () => onOpen(chords[i]),
                backgroundColor: highlightFirst && i == 0
                    ? scheme.secondaryContainer
                    : null,
                label: AppText(
                  showConfidence
                      ? '${chords[i].name} · '
                            '${(chords[i].confidence * 100).round()} %'
                      : chords[i].name,
                  variant: AppTextVariant.labelLarge,
                  weight: highlightFirst && i == 0
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
