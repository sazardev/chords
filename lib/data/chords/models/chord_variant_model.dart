import 'package:chords/domain/chords/entities/barre_info.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/chord_variant_composer.dart';

/// Modelo de serialización de una posición de acorde.
///
/// El banco solo guarda lo que no se puede deducir (identificador, trastes,
/// dedos, dificultad y cejillo); el nombre, las notas y las etiquetas las
/// compone `composeVariant`.
class ChordVariantModel {
  /// Crea el modelo desde un mapa JSON.
  factory ChordVariantModel.fromJson(Map<String, Object?> json) {
    final Object? barre = json['barre'];
    return ChordVariantModel._(
      id: _string(json['id']),
      frets: _intList(json['frets']),
      fingers: _intList(json['fingers']),
      difficultyLevel: _int(json['difficulty']),
      barre: barre is List<Object?> && barre.length == 3
          ? BarreInfo(
              fret: _int(barre[0]),
              fromString: _int(barre[1]),
              lastString: _int(barre[2]),
            )
          : null,
    );
  }

  const ChordVariantModel._({
    required this.id,
    required this.frets,
    required this.fingers,
    required this.difficultyLevel,
    required this.barre,
  });

  /// Identificador de la posición (sin el prefijo del acorde).
  final String id;

  /// Trastes por cuerda.
  final List<int> frets;

  /// Dedos por cuerda.
  final List<int> fingers;

  /// Nivel de dificultad (1-5).
  final int difficultyLevel;

  /// Información de cejillo si aplica.
  final BarreInfo? barre;

  /// Convierte el modelo a entidad de dominio.
  ChordVariant toEntity({
    required String chordId,
    required ChordRoot root,
    required ChordQuality quality,
    required Map<String, String> shapeLabels,
  }) => composeVariant(
    chordId: chordId,
    root: root,
    quality: quality,
    id: id,
    frets: frets,
    fingers: fingers,
    difficulty: difficultyLevel,
    barre: barre,
    shapeLabels: shapeLabels,
  );

  static String _string(Object? value) => value is String ? value : '';

  static int _int(Object? value) => value is int ? value : 0;

  static List<int> _intList(Object? value) =>
      value is List<Object?> ? value.whereType<int>().toList() : const <int>[];
}
