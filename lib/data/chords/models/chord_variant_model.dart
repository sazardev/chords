import 'package:chords/domain/chords/entities/barre_info.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';

/// Modelo de serialización de una posición de acorde.
class ChordVariantModel {
  /// Crea el modelo desde un mapa JSON.
  factory ChordVariantModel.fromJson(Map<String, Object?> json) {
    final Object? barre = json['barre'];
    return ChordVariantModel._(
      id: _string(json['id']),
      positionLabel: _string(json['position']),
      frets: _intList(json['frets']),
      fingers: _intList(json['fingers']),
      difficultyLevel: _int(json['difficulty']),
      barre: barre is Map<String, Object?> && barre.isNotEmpty
          ? BarreInfo(
              fret: _int(barre['fret']),
              fromString: _int(barre['from']),
              lastString: _int(barre['to']),
            )
          : null,
      notes: _stringList(json['notes']),
      tags: _stringList(json['tags']),
    );
  }

  const ChordVariantModel._({
    required this.id,
    required this.positionLabel,
    required this.frets,
    required this.fingers,
    required this.difficultyLevel,
    required this.barre,
    required this.notes,
    required this.tags,
  });

  /// Identificador de la posición.
  final String id;

  /// Etiqueta de posición.
  final String positionLabel;

  /// Trastes por cuerda.
  final List<int> frets;

  /// Dedos por cuerda.
  final List<int> fingers;

  /// Nivel de dificultad (1-5).
  final int difficultyLevel;

  /// Información de cejillo si aplica.
  final BarreInfo? barre;

  /// Notas contenidas.
  final List<String> notes;

  /// Etiquetas descriptivas.
  final List<String> tags;

  /// Convierte el modelo a entidad de dominio.
  ChordVariant toEntity() => ChordVariant(
    id: id,
    positionLabel: positionLabel,
    frets: frets,
    fingers: fingers,
    difficulty: Difficulty.fromLevel(difficultyLevel) ?? Difficulty.medium,
    barre: barre,
    notes: notes,
    tags: tags,
  );

  static String _string(Object? value) => value is String ? value : '';

  static int _int(Object? value) => value is int ? value : 0;

  static List<int> _intList(Object? value) =>
      value is List<Object?> ? value.whereType<int>().toList() : const <int>[];

  static List<String> _stringList(Object? value) => value is List<Object?>
      ? value.whereType<String>().toList()
      : const <String>[];
}
