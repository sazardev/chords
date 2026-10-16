/// Familia de una calidad de acorde: agrupa las calidades en filtros y
/// selectores.
enum ChordFamily {
  /// Triadas: mayor, menor, disminuida y aumentada.
  triad,

  /// Power chords (quintas).
  power,

  /// Acordes con sexta: 6, m6 y 6/9.
  sixth,

  /// Séptimas: 7, m7, maj7, mMaj7, m7b5 y dim7.
  seventh,

  /// Extendidos: novenas, oncenas y trecenas.
  extended,

  /// Suspendidos y con notas añadidas: sus2, sus4, 7sus4, add9…
  suspendedAdded,

  /// Alterados: 7b9, 7#9, 7#5, 7b5, maj7#11…
  altered,
}
