import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:flutter/foundation.dart';

/// Qué instrumentos acaban de sonar: alimenta los indicadores del pulso en
/// la pantalla del jam.
///
/// Se avisa en cada semicorchea (hasta ~14 veces por segundo), por eso es un
/// notificador aparte del estado de la sesión: solo se reconstruyen las
/// luces, no la pantalla entera.
class BandActivity extends ChangeNotifier {
  Set<BandChannel> _active = const <BandChannel>{};
  int _pulse = 0;

  /// Canales con un golpe en la última semicorchea.
  Set<BandChannel> get active => _active;

  /// Contador que sube en cada semicorchea (para animar al ritmo).
  int get pulse => _pulse;

  /// `true` si [channel] acaba de sonar.
  bool isActive(BandChannel channel) => _active.contains(channel);

  /// Registra los canales que suenan en esta semicorchea.
  void mark(Set<BandChannel> channels) {
    _active = channels;
    _pulse++;
    notifyListeners();
  }

  /// Apaga todas las luces.
  void clear() {
    if (_active.isEmpty) {
      return;
    }
    _active = const <BandChannel>{};
    notifyListeners();
  }
}
