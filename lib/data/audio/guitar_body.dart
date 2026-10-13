import 'dart:math' as math;
import 'dart:typed_data';

/// Caja de resonancia de una guitarra acústica y un poco de sala.
///
/// Una cuerda sola suena fina y "de ordenador"; la madera de la caja refuerza
/// unas zonas del espectro. Aquí se imita con resonadores en las frecuencias
/// típicas de una acústica (aire de la boca, tapa armónica y sus armónicos),
/// un recorte suave de los agudos más ásperos, un filtro que quita el
/// retumbo inaudible y una reverberación corta que da aire sin alargar la
/// nota.
class GuitarBody {
  /// Crea la caja para la frecuencia de muestreo [sampleRate].
  const GuitarBody({this.sampleRate = 44100});

  /// Frecuencia de muestreo en Hz.
  final int sampleRate;

  /// Resonancias de la caja: frecuencia (Hz), calidad y ganancia.
  static const List<({double hz, double q, double gain})> _modes =
      <({double hz, double q, double gain})>[
        (hz: 98, q: 5, gain: 0.55),
        (hz: 196, q: 6, gain: 0.45),
        (hz: 392, q: 7, gain: 0.3),
        (hz: 780, q: 6, gain: 0.16),
        (hz: 1560, q: 5, gain: 0.1),
      ];

  /// Devuelve [dry] pasado por la caja; no modifica la entrada.
  Float64List process(Float64List dry) {
    final Float64List colored = Float64List.fromList(dry);
    for (final ({double hz, double q, double gain}) mode in _modes) {
      final _Biquad resonator = _Biquad.bandPass(mode.hz, mode.q, sampleRate);
      for (int i = 0; i < dry.length; i++) {
        colored[i] += mode.gain * resonator.next(dry[i]);
      }
    }
    _filter(colored, _Biquad.lowPass(6500, 0.7, sampleRate));
    _filter(colored, _Biquad.highPass(60, 0.7, sampleRate));
    return _room(colored);
  }

  void _filter(Float64List samples, _Biquad filter) {
    for (int i = 0; i < samples.length; i++) {
      samples[i] = filter.next(samples[i]);
    }
  }

  /// Reverberación corta tipo Schroeder: cuatro peines y dos pasa-todo.
  Float64List _room(Float64List dry) {
    final double scale = sampleRate / 44100;
    final List<_Comb> combs = <_Comb>[
      for (final int delay in <int>[1116, 1188, 1277, 1356])
        _Comb((delay * scale).round(), 0.74, 0.3),
    ];
    final List<_AllpassStage> stages = <_AllpassStage>[
      for (final int delay in <int>[556, 441])
        _AllpassStage((delay * scale).round(), 0.5),
    ];
    final Float64List out = Float64List(dry.length);
    for (int i = 0; i < dry.length; i++) {
      double wet = 0;
      for (final _Comb comb in combs) {
        wet += comb.next(dry[i]);
      }
      wet *= 0.25;
      for (final _AllpassStage stage in stages) {
        wet = stage.next(wet);
      }
      out[i] = dry[i] * 0.9 + wet * 0.16;
    }
    return out;
  }
}

/// Filtro de segundo orden (fórmulas del Audio EQ Cookbook).
class _Biquad {
  _Biquad(this._b0, this._b1, this._b2, double a0, this._a1, this._a2) {
    _b0 /= a0;
    _b1 /= a0;
    _b2 /= a0;
    _a1 /= a0;
    _a2 /= a0;
  }

  /// Paso de banda con ganancia 1 en el pico.
  factory _Biquad.bandPass(double hz, double q, int rate) {
    final double w = 2 * math.pi * hz / rate;
    final double alpha = math.sin(w) / (2 * q);
    return _Biquad(alpha, 0, -alpha, 1 + alpha, -2 * math.cos(w), 1 - alpha);
  }

  /// Paso bajo.
  factory _Biquad.lowPass(double hz, double q, int rate) {
    final double w = 2 * math.pi * hz / rate;
    final double alpha = math.sin(w) / (2 * q);
    final double c = math.cos(w);
    return _Biquad(
      (1 - c) / 2,
      1 - c,
      (1 - c) / 2,
      1 + alpha,
      -2 * c,
      1 - alpha,
    );
  }

  /// Paso alto.
  factory _Biquad.highPass(double hz, double q, int rate) {
    final double w = 2 * math.pi * hz / rate;
    final double alpha = math.sin(w) / (2 * q);
    final double c = math.cos(w);
    return _Biquad(
      (1 + c) / 2,
      -(1 + c),
      (1 + c) / 2,
      1 + alpha,
      -2 * c,
      1 - alpha,
    );
  }

  double _b0;
  double _b1;
  double _b2;
  double _a1;
  double _a2;
  double _x1 = 0;
  double _x2 = 0;
  double _y1 = 0;
  double _y2 = 0;

  double next(double x) {
    final double y = _b0 * x + _b1 * _x1 + _b2 * _x2 - _a1 * _y1 - _a2 * _y2;
    _x2 = _x1;
    _x1 = x;
    _y2 = _y1;
    _y1 = y;
    return y;
  }
}

/// Peine con pérdidas: una repetición que se apaga y se oscurece.
class _Comb {
  _Comb(int delay, this._feedback, this._damp) : _buffer = Float64List(delay);

  final Float64List _buffer;
  final double _feedback;
  final double _damp;
  int _index = 0;
  double _filtered = 0;

  double next(double x) {
    final double out = _buffer[_index];
    _filtered = out * (1 - _damp) + _filtered * _damp;
    _buffer[_index] = x + _filtered * _feedback;
    _index = (_index + 1) % _buffer.length;
    return out;
  }
}

/// Pasa-todo de Schroeder para difuminar los ecos.
class _AllpassStage {
  _AllpassStage(int delay, this._gain) : _buffer = Float64List(delay);

  final Float64List _buffer;
  final double _gain;
  int _index = 0;

  double next(double x) {
    final double delayed = _buffer[_index];
    final double out = delayed - _gain * x;
    _buffer[_index] = x + _gain * delayed;
    _index = (_index + 1) % _buffer.length;
    return out;
  }
}
