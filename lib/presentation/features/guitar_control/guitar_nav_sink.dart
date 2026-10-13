import 'package:flutter/foundation.dart';

/// Lo que el oyente de la guitarra necesita del menú global.
///
/// El oyente reconoce las notas; el menú decide qué hacer con las que no son
/// órdenes de la pantalla: la nota aguda lo abre y lo cierra y, con el menú
/// abierto, cada nota elige una opción.
abstract interface class GuitarNavSink implements Listenable {
  /// Si el modo guitarra global está encendido.
  bool get active;

  /// Si el menú está abierto: las órdenes de la pantalla quedan en pausa.
  bool get menuOpen;

  /// Se tocó la nota aguda: abre o cierra el menú.
  void onWake();

  /// Se tocó una nota normal con el menú abierto.
  void onMenuNote(int pitchClass);

  /// Avanza el reloj (para cerrar el menú si nadie lo usa).
  void tick(DateTime now);
}
