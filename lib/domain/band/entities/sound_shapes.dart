/// Forma concreta de cada golpe: cómo se ataca y cuánto dura.
library;

/// Familia de sonido: decide qué sintetizador lo genera.
enum SoundFamily {
  /// Batería y percusión.
  drum,

  /// Bajo.
  bass,

  /// Guitarra rítmica.
  guitar,

  /// Teclados.
  keys,

  /// Vientos.
  wind,

  /// Clic del metrónomo.
  click,
}

/// Golpe de la mano derecha en la guitarra.
enum GuitarStroke {
  /// Rasgueo hacia abajo con todo el acorde.
  down,

  /// Rasgueo hacia arriba (las cuerdas agudas), más suave.
  up,

  /// Rasgueo con la palma apoyada (palm-mute).
  mute,

  /// Golpe seco con la mano izquierda aflojada (chop de reggae o funk).
  chop,

  /// Solo el bajo del acorde (nota grave).
  bass,

  /// Power chord (raíz, quinta y octava) que suena largo.
  power,

  /// Power chord con palm-mute.
  powerMute,

  /// Rasgueado rápido de flamenco (varios golpes seguidos).
  roll,
}

/// Duración de una nota de bajo, tecla o viento.
enum NoteLength {
  /// Seca: unas décimas de segundo.
  short,

  /// Media: se apaga sola en medio segundo.
  medium,

  /// Larga: suena hasta que otra nota la corta.
  long,
}

/// Cuánto suena un clic.
enum ClickAccent {
  /// Pulso normal.
  normal,

  /// Primer pulso del compás: más agudo.
  accent,
}
