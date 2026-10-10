import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/chord_play_button.dart';
import 'package:chords/presentation/widgets/atoms/difficulty_badge.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';

/// Fila horizontal de acorde para listas y niveles.
class ChordTile extends StatelessWidget {
  /// Crea la fila.
  const ChordTile({
    required this.chord,
    required this.onTap,
    required this.onPlay,
    super.key,
    this.mastered = false,
    this.onToggleMastered,
    this.trailingNote,
  });

  /// Acorde mostrado.
  final Chord chord;

  /// Acción al pulsar la fila.
  final VoidCallback onTap;

  /// Acción al reproducir el acorde.
  final VoidCallback onPlay;

  /// Si el acorde está marcado como dominado.
  final bool mastered;

  /// Acción para marcar/desmarcar como dominado.
  final VoidCallback? onToggleMastered;

  /// Nota adicional mostrada bajo el nombre.
  final String? trailingNote;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final AppChordColors colors = chordColorsOf(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: ChordDiagram(
        variant: chord.easiestVariant,
        showFingers: false,
        width: 46,
        height: 60,
      ),
      title: AppText(
        chord.name,
        variant: AppTextVariant.titleMedium,
        maxLines: 1,
      ),
      subtitle: AppText(
        trailingNote ?? t.chords.positionCount(n: chord.variantCount),
        variant: AppTextVariant.labelMedium,
        maxLines: 1,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DifficultyBadge(difficulty: chord.difficulty, compact: true),
          const SizedBox(width: 6),
          ChordPlayButton(
            onPressed: onPlay,
            size: 38,
            tooltip: t.chordDetail.listenPosition(position: chord.name),
          ),
          if (onToggleMastered != null)
            IconButton(
              tooltip: mastered
                  ? t.chordDetail.unmarkMastered
                  : t.chordDetail.markMastered,
              icon: Icon(
                mastered ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: mastered ? colors.openString : null,
              ),
              onPressed: onToggleMastered,
            ),
        ],
      ),
    );
  }
}
