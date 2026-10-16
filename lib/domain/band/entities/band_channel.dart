/// Canal del mezclador de la banda: cada uno se activa, silencia y regula
/// por separado.
enum BandChannel {
  /// Batería: bombo, caja, charles, platos y toms.
  drums,

  /// Percusión menor: shaker, pandereta, cencerro, congas, palmas…
  percussion,

  /// Bajo.
  bass,

  /// Guitarra rítmica.
  guitar,

  /// Teclados: piano, piano eléctrico, órgano o cuerdas.
  keys,

  /// Vientos: acordeón o metales.
  winds,

  /// Metrónomo: el clic.
  click,
}
