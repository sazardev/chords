import 'dart:typed_data';

/// Destino de las muestras que `MicPitchAnalyzer` deja pasar de la entrada.
///
/// El analizador decodifica el PCM una sola vez y, tras la puerta de eco,
/// reparte las muestras a quien quiera analizarlas por su cuenta (p. ej. el
/// reconocedor de acordes), sin que cada uno repita la decodificación ni
/// consulte la puerta por separado.
abstract interface class MicSampleSink {
  /// Recibe un bloque de muestras (-1..1) que la puerta de eco admitió.
  void addSamples(Float64List samples);

  /// La puerta de eco está cerrada: el altavoz suena y no hay que escuchar.
  void hold();

  /// Descarta lo acumulado (al detener la captura).
  void reset();
}
