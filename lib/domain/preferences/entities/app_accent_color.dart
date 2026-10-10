import 'package:flutter/material.dart';

/// Colores de acento disponibles para generar el esquema Material 3.
///
/// Cada valor actúa como semilla de `ColorScheme.fromSeed`, de modo que la
/// aplicación completa (superficies, contenedores y estados) se deriva del
/// acento elegido y mantiene coherencia entre los temas claro y oscuro.
enum AppAccentColor {
  /// Violeta de la línea base de Material 3.
  violeta(Color(0xFF6750A4), 'Violeta', Icons.circle),

  /// Azul profundo.
  azul(Color(0xFF0B57D0), 'Azul', Icons.circle),

  /// Añil intenso.
  anil(Color(0xFF4F46E5), 'Añil', Icons.circle),

  /// Cian oscuro.
  cian(Color(0xFF00696D), 'Cian', Icons.circle),

  /// Verde bosque.
  verde(Color(0xFF1E6C41), 'Verde', Icons.circle),

  /// Verde lima.
  lima(Color(0xFF4C662B), 'Lima', Icons.circle),

  /// Ámbar tostado.
  ambar(Color(0xFF8B5000), 'Ámbar', Icons.circle),

  /// Naranja cálido.
  naranja(Color(0xFF9A4600), 'Naranja', Icons.circle),

  /// Rojo Material.
  rojo(Color(0xFFB3261E), 'Rojo', Icons.circle),

  /// Rosa magenta.
  rosa(Color(0xFFB3166B), 'Rosa', Icons.circle);

  /// Crea un acento con su semilla y su etiqueta visible.
  const AppAccentColor(this.seed, this.label, this.icon);

  /// Color semilla del esquema tonal.
  final Color seed;

  /// Nombre legible del acento.
  final String label;

  /// Icono mostrado en el selector de acento.
  final IconData icon;
}
