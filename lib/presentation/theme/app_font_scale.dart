/// Escalas de tamaño de texto de la aplicación.
///
/// Ajustan la escala tipográfica del tema sin perder las proporciones del
/// sistema Material 3, de modo que toda la interfaz crece de forma uniforme.
enum AppFontScale {
  /// Texto reducido, para pantallas densas.
  pequena(0.9, 'Pequeño'),

  /// Tamaño de referencia del sistema.
  normal(1, 'Normal'),

  /// Texto ampliado.
  grande(1.12, 'Grande'),

  /// Texto muy ampliado, máxima accesibilidad.
  extraGrande(1.25, 'Muy grande');

  /// Crea una escala con su multiplicador y su etiqueta visible.
  const AppFontScale(this.scale, this.label);

  /// Multiplicador aplicado a la escala tipográfica del tema.
  final double scale;

  /// Nombre legible de la escala.
  final String label;
}
