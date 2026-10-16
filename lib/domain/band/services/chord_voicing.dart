import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Primera nota MIDI que sirve de raíz a la guitarra (Mi2).
const int kGuitarLow = 40;

/// Nota más grave del bajo (Mi1).
const int kBassLow = 28;

/// Notas MIDI de cada instrumento armónico para una cifra.
///
/// Sin estado ni dependencias: es la traducción de `ChordSymbol` a notas que
/// comparten el rasgueo, el teclado y los vientos.
class ChordVoicing {
  /// Crea el servicio.
  const ChordVoicing();

  /// Primera nota de clase de tono [pitchClass] a partir de [low].
  int noteAtOrAbove(int pitchClass, int low) =>
      low + ((pitchClass - low) % 12 + 12) % 12;

  /// Notas de una guitarra para el acorde, de grave a aguda.
  ///
  /// La primera es la raíz (Mi2-Re♯3); sigue la quinta, la raíz una octava
  /// arriba, la tercera y la quinta o la séptima: la forma abierta de Do.
  List<int> guitar(ChordSymbol chord) {
    final int root = noteAtOrAbove(chord.root, kGuitarLow);
    final _Tones tones = _Tones.of(chord);
    if (tones.third == null) {
      return <int>[
        root,
        root + tones.fifth,
        root + 12,
        root + 12 + tones.fifth,
      ];
    }
    return <int>[
      root,
      root + tones.fifth,
      root + 12,
      root + 12 + tones.third!,
      root + 12 + (tones.color ?? tones.fifth),
    ];
  }

  /// Power chord de guitarra: raíz, quinta y octava.
  List<int> power(ChordSymbol chord) {
    final int root = noteAtOrAbove(chord.root, kGuitarLow);
    return <int>[root, root + 7, root + 12];
  }

  /// Acorde cerrado de teclado centrado cerca del Do central.
  List<int> keys(ChordSymbol chord) => _closed(chord, 53);

  /// Acorde cerrado de vientos, una octava más arriba.
  List<int> winds(ChordSymbol chord) => _closed(chord, 60);

  /// Acorde de tres o cuatro notas empezando en la raíz a partir de [low].
  List<int> _closed(ChordSymbol chord, int low) {
    final int root = noteAtOrAbove(chord.root, low);
    final _Tones tones = _Tones.of(chord);
    final List<int> notes = <int>[
      root,
      if (tones.third != null) root + tones.third!,
      root + tones.fifth,
      if (tones.color != null) root + tones.color!,
    ];
    // La novena y los intervalos de más de una octava se pliegan.
    return <int>[
      for (final int note in notes)
        if (note - root > 12) note - 12 else note,
    ]..sort();
  }

  /// Raíz del bajo en el registro Mi1-Re♯2.
  int bassRoot(int pitchClass) => noteAtOrAbove(pitchClass, kBassLow);
}

/// Intervalos que definen un acorde: tercera, quinta y color (séptima o
/// sexta).
class _Tones {
  const _Tones(this.third, this.fifth, this.color);

  factory _Tones.of(ChordSymbol chord) {
    final Set<int> intervals = <int>{
      for (final int interval in chord.quality.intervals) interval % 12,
    };
    int? pick(List<int> options) {
      for (final int option in options) {
        if (intervals.contains(option)) {
          return option;
        }
      }
      return null;
    }

    return _Tones(
      pick(<int>[4, 3, 5, 2]),
      pick(<int>[7, 6, 8]) ?? 7,
      pick(<int>[10, 11, 9]),
    );
  }

  final int? third;
  final int fifth;
  final int? color;
}
