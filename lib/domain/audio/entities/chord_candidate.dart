import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:meta/meta.dart';

/// Acorde propuesto por el reconocedor polifónico: raíz y calidad.
///
/// No depende del banco cargado: el reconocedor compara contra todas las
/// raíces y calidades posibles y la interfaz resuelve después la ficha por
/// [id] (el mismo identificador que usa el banco, p. ej. `C-maj`).
@immutable
class ChordCandidate {
  /// Crea un candidato con su puntuación y su confianza.
  const ChordCandidate({
    required this.root,
    required this.quality,
    required this.score,
    required this.confidence,
  });

  /// Raíz del acorde.
  final ChordRoot root;

  /// Calidad del acorde.
  final ChordQuality quality;

  /// Parecido bruto con la plantilla (0-1); sirve para ordenar candidatos.
  final double score;

  /// Confianza (0-1) de que este candidato es lo que suena.
  final double confidence;

  /// Identificador estable del acorde en el banco (p. ej. `C-maj`).
  String get id => '${root.name}-${quality.id}';

  /// Nombre estándar (p. ej. `Cm7`).
  String get name => '${root.name}${quality.suffix}';

  /// Nombre en español (p. ej. `Do Séptima menor`).
  String get displayName => '${root.displayName} ${quality.label}';

  /// Clases de tono (0-11) que contiene el acorde.
  Set<int> get pitchClasses => <int>{
    for (final int interval in quality.intervals)
      (root.pitchClass + interval) % 12,
  };

  /// Copia con otra confianza.
  ChordCandidate withConfidence(double value) => ChordCandidate(
    root: root,
    quality: quality,
    score: score,
    confidence: value,
  );

  @override
  bool operator ==(Object other) => other is ChordCandidate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ChordCandidate($name, ${score.toStringAsFixed(2)}, '
      '${confidence.toStringAsFixed(2)})';
}
