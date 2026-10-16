import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
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
    this.groupLabelOf,
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

  /// Título del grupo de cada acorde; si se da, los acordes consecutivos con
  /// el mismo título se agrupan bajo un encabezado.
  final String Function(Chord chord)? groupLabelOf;

  /// Columnas de la cuadrícula para un ancho de pantalla.
  static int columnsFor(double width) =>
      width < 420 ? 2 : (width < 720 ? 3 : (width < 1100 ? 4 : 5));

  static const double _aspectRatio = 0.8;
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(16, 12, 16, 24);

  @override
  Widget build(BuildContext context) {
    final int columns = columnsFor(MediaQuery.sizeOf(context).width);
    final String Function(Chord)? labelOf = groupLabelOf;
    if (labelOf != null) {
      return _grouped(context, columns, labelOf);
    }
    return GridView.builder(
      padding: _padding,
      gridDelegate: _delegate(columns),
      itemCount: chords.length,
      itemBuilder: (BuildContext context, int index) =>
          _card(chords[index], index % columns),
    );
  }

  SliverGridDelegate _delegate(int columns) =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: _aspectRatio,
      );

  Widget _card(Chord chord, int entranceIndex) => Entrance(
    index: entranceIndex,
    child: ChordCard(
      chord: chord,
      mirror: mirror,
      playing: playingChordId == chord.id,
      onTap: () => onSelect(chord.id),
      onPlay: () => onPlay(chord.id),
    ),
  );

  Widget _grouped(
    BuildContext context,
    int columns,
    String Function(Chord chord) labelOf,
  ) {
    final List<(String, List<Chord>)> groups = <(String, List<Chord>)>[];
    for (final Chord chord in chords) {
      final String label = labelOf(chord);
      if (groups.isEmpty || groups.last.$1 != label) {
        groups.add((label, <Chord>[]));
      }
      groups.last.$2.add(chord);
    }
    return CustomScrollView(
      slivers: <Widget>[
        for (final (String label, List<Chord> members) in groups) ...<Widget>[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Semantics(
                header: true,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            sliver: SliverGrid.builder(
              gridDelegate: _delegate(columns),
              itemCount: members.length,
              itemBuilder: (BuildContext context, int index) =>
                  _card(members[index], index % columns),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
