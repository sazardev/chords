import 'dart:typed_data';

/// Una muestra ya sintetizada.
///
/// Con [loopStart] la muestra es un sonido sostenido (órgano, cuerdas,
/// acordeón): al llegar al final vuelve a ese punto y empalma sin clic.
class RenderedSound {
  /// Crea la muestra.
  const RenderedSound(this.samples, {this.loopStart});

  /// Muestras normalizadas (-1 a 1).
  final Float64List samples;

  /// Primera muestra del bucle, o `null` si suena una sola vez.
  final int? loopStart;
}
