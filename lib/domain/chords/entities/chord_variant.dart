import 'package:chords/domain/chords/entities/barre_info.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';
import 'package:meta/meta.dart';

/// Posición concreta (voicing) de un acorde en el mástil.
@immutable
class ChordVariant {
  /// Crea una posición de acorde.
  const ChordVariant({
    required this.id,
    required this.positionLabel,
    required this.frets,
    required this.fingers,
    required this.difficulty,
    this.barre,
    this.notes = const <String>[],
    this.tags = const <String>[],
    this.kind = VariantKind.shape,
  });

  /// Identificador estable de la posición.
  final String id;

  /// Etiqueta de la posición (p. ej. `Forma de Mi`).
  final String positionLabel;

  /// Trastes por cuerda (6 entradas, índice 0 = sexta).
  ///
  /// `-1` = cuerda muda, `0` = al aire, `n` = traste pulsado.
  final List<int> frets;

  /// Dedos por cuerda (6 entradas); `0` = sin dedo específico.
  final List<int> fingers;

  /// Nivel de dificultad de la posición.
  final Difficulty difficulty;

  /// Información del cejillo si la posición lo requiere.
  final BarreInfo? barre;

  /// Nombres de nota que contiene la posición.
  final List<String> notes;

  /// Etiquetas descriptivas (`open`, `barre`, `triad`, ...).
  final List<String> tags;

  /// Cómo se construyó: forma del catálogo o voicing buscado.
  final VariantKind kind;

  /// `true` si es una forma del catálogo (CAGED, abierta o movible).
  bool get isShape => kind == VariantKind.shape;

  /// Traste más grave pulsado (excluyendo cuerdas al aire).
  int get baseFret {
    final List<int> pressed = frets.where((int f) => f > 0).toList();
    if (pressed.isEmpty) {
      return 0;
    }
    return pressed.reduce((int a, int b) => a < b ? a : b);
  }

  @override
  bool operator ==(Object other) =>
      other is ChordVariant &&
      other.id == id &&
      other.positionLabel == positionLabel &&
      other.baseFret == baseFret;

  @override
  int get hashCode => Object.hash(id, positionLabel, baseFret);

  @override
  String toString() => 'ChordVariant($id, $positionLabel, frets: $frets)';
}
