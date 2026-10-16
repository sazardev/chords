import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:meta/meta.dart';

/// Fuerza de cada carácter de una pista de batería.
///
/// `-` silencio, `.` fantasma, `o` suave, `x` normal y `X` acento.
const Map<String, double> kDrumLevels = <String, double>{
  '.': 0.3,
  'o': 0.5,
  'x': 0.72,
  'X': 1,
};

/// Un compás de batería en rejilla de semicorcheas: 16 pasos en 4/4 y 12 en
/// 3/4.
///
/// Cada voz tiene su pista de texto (`X---x---`): una letra por paso con la
/// fuerza del golpe (ver [kDrumLevels]) y `-` donde no suena.
@immutable
class DrumPattern {
  /// Crea el patrón a partir de las pistas de cada voz.
  const DrumPattern(this.lanes);

  /// Pista de cada voz.
  final Map<DrumVoice, String> lanes;

  /// Pasos del compás (la longitud de la primera pista).
  int get steps => lanes.values.first.length;

  /// Golpes que caen en el paso [step]: voz y fuerza.
  List<(DrumVoice, double)> hitsAt(int step) => <(DrumVoice, double)>[
    for (final MapEntry<DrumVoice, String> lane in lanes.entries)
      if (step < lane.value.length && kDrumLevels[lane.value[step]] != null)
        (lane.key, kDrumLevels[lane.value[step]]!),
  ];

  /// Todas las voces que aparecen en el patrón.
  Iterable<DrumVoice> get voices => lanes.keys;

  /// El mismo patrón con otras pistas añadidas o sustituidas.
  DrumPattern merged(Map<DrumVoice, String> other) =>
      DrumPattern(<DrumVoice, String>{...lanes, ...other});
}

/// Las tres caras de un ritmo de batería: dos variantes del compás tipo y el
/// relleno que cierra la frase.
@immutable
class DrumGroove {
  /// Crea el ritmo.
  const DrumGroove({required this.a, required this.b, required this.fill});

  /// Compás tipo.
  final DrumPattern a;

  /// Variante con más empuje (más relleno rítmico o platos más abiertos).
  final DrumPattern b;

  /// Relleno del último compás de cada frase.
  final DrumPattern fill;

  /// Todos los patrones.
  List<DrumPattern> get all => <DrumPattern>[a, b, fill];
}
