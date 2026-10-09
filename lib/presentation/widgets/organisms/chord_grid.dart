import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/presentation/widgets/molecules/chord_card.dart';
import 'package:flutter/material.dart';

/// Cuadrícula adaptable de tarjetas de acorde.
class ChordGrid extends StatelessWidget {
  /// Crea la cuadrícula.
  const ChordGrid({
    required this.chords,
    required this.onSelect,
    required this.onPlay,
    super.key,
    this.playingChordId,
    this.mirror = false,
  });

  /// Acordes a mostrar.
  final List<Chord> chords;

  /// Acción al seleccionar una tarjeta.
  final ValueChanged<String> onSelect;

  /// Acción al reproducir un acorde.
  final ValueChanged<String> onPlay;

  /// Identificador del acorde que está sonando.
  final String? playingChordId;

  /// Si los diagramas se muestran en espejo.
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final int columns = width < 420
        ? 2
        : (width < 720 ? 3 : (width < 1100 ? 4 : 5));
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: chords.length,
      itemBuilder: (BuildContext context, int index) {
        final Chord chord = chords[index];
        return ChordCard(
          chord: chord,
          mirror: mirror,
          playing: playingChordId == chord.id,
          onTap: () => onSelect(chord.id),
          onPlay: () => onPlay(chord.id),
        );
      },
    );
  }
}
