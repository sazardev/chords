import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:meta/meta.dart';

/// Lectura polifónica: lo que suena en el micrófono interpretado como acorde.
///
/// Lleva el cromagrama (energía de las 12 notas, 0-1, para dibujar las
/// barras), los candidatos ordenados y, si hay uno estable y fiable, el
/// acorde reconocido.
@immutable
class ChordReading {
  /// Crea una lectura.
  const ChordReading({
    required this.chroma,
    required this.candidates,
    this.chord,
    this.bass,
    this.level = 0,
    this.isSilent = false,
  });

  /// Lectura de silencio: no hay nada que reconocer.
  static const ChordReading silence = ChordReading(
    chroma: <double>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    candidates: <ChordCandidate>[],
    isSilent: true,
  );

  /// Energía de las 12 clases de nota (0 = Do), normalizada a 0-1.
  final List<double> chroma;

  /// Candidatos de mejor a peor (puede estar vacío).
  final List<ChordCandidate> candidates;

  /// Acorde estable y fiable (con histéresis); `null` si aún no hay ninguno.
  final ChordCandidate? chord;

  /// Clase de nota (0-11) del bajo, si se distingue.
  final int? bass;

  /// Nivel de la señal de entrada (0-1).
  final double level;

  /// `true` si la señal está por debajo de la puerta de ruido.
  final bool isSilent;

  /// Confianza (0-1) del acorde reconocido; 0 si no hay.
  double get confidence => chord?.confidence ?? 0;

  /// Candidatos distintos del acorde reconocido (las alternativas probables).
  List<ChordCandidate> get alternatives => <ChordCandidate>[
    for (final ChordCandidate candidate in candidates)
      if (candidate != chord) candidate,
  ];

  @override
  String toString() =>
      'ChordReading(${chord?.name ?? '—'}, '
      '${confidence.toStringAsFixed(2)}, nivel ${level.toStringAsFixed(2)})';
}
