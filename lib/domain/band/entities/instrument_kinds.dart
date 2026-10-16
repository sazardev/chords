/// Variantes de timbre de cada instrumento de la banda.
///
/// Son datos puros: el sintetizador de `data/` decide cómo suena cada una.
library;

/// Kit de batería.
enum DrumKit {
  /// Batería acústica de estudio: bombo con pegada y caja viva.
  acoustic,

  /// Kit pequeño de jazz: bombo agudo y breve, caja suelta y ride abierto.
  jazz,

  /// Caja de ritmos electrónica: bombo grave largo, caja seca y clap.
  electronic,
}

/// Tipo de bajo.
enum BassKind {
  /// Eléctrico tocado con los dedos: redondo y cálido.
  finger,

  /// Eléctrico tocado con púa: más ataque y brillo.
  pick,

  /// Contrabajo: madera, ataque seco y caída rápida.
  upright,

  /// Sintetizado: sierra filtrada con sub, o sub largo.
  synth,
}

/// Tipo de guitarra rítmica.
enum GuitarKind {
  /// Acústica de cuerdas de acero (la misma del resto de la app).
  acoustic,

  /// Eléctrica limpia con un coro suave.
  clean,

  /// Eléctrica saturada: power chords y palm-mute.
  distorted,

  /// Clásica de cuerdas de nailon, también para flamenco.
  nylon,
}

/// Tipo de teclado.
enum KeysKind {
  /// Piano acústico.
  piano,

  /// Piano eléctrico tipo Rhodes.
  rhodes,

  /// Órgano de ruedas fónicas.
  organ,

  /// Colchón de cuerdas.
  pad,
}

/// Tipo de viento.
enum WindKind {
  /// Acordeón (cumbia, ranchera, tango).
  accordion,

  /// Metales cortos (salsa, ska, soul).
  brass,
}

/// Cuánto empuja la banda.
enum BandIntensity {
  /// Suave: menos fuerza y sin variaciones.
  soft,

  /// Normal.
  normal,

  /// Fuerte: más fuerza y variaciones más a menudo.
  strong,
}
