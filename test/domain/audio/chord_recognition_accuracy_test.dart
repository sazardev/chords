@Timeout(Duration(minutes: 5))
library;

import 'dart:typed_data';

import 'package:chords/data/audio/chord_audio_synthesizer.dart';
import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:test/test.dart';

import '../../fakes/chord_bank.dart';
import '../../support/chord_audio_probe.dart';

/// Resultado de reconocer una posición del banco.
class _Outcome {
  const _Outcome(this.chord, this.variant, this.heard);

  final Chord chord;
  final ChordVariant variant;
  final ChordCandidate? heard;

  /// Mismo acorde: misma raíz y calidad.
  bool get strict =>
      heard != null &&
      heard!.root == chord.root &&
      heard!.quality == chord.quality;

  /// Mismo acorde o uno con exactamente las mismas notas.
  ///
  /// Am7 y C6, Asus2 y Esus4 o C+, E+ y G#+ suenan igual: solo el bajo (y el
  /// contexto) los distingue, así que el equivalente cuenta como acierto.
  bool get equivalent {
    final ChordCandidate? got = heard;
    if (got == null) {
      return false;
    }
    final Set<int> wanted = <int>{
      for (final int i in chord.quality.intervals)
        (chord.root.pitchClass + i) % 12,
    };
    return strict ||
        (got.pitchClasses.length == wanted.length &&
            got.pitchClasses.containsAll(wanted));
  }
}

/// Sintetiza [variant] como un rasgueo y devuelve el acorde reconocido a 1.5 s.
_Outcome _listen(Chord chord, ChordVariant variant) {
  final Float64List audio = const ChordAudioSynthesizer().synthesize(
    variant,
    duration: 1.6,
  );
  final List<ChordReading> readings = recognize(audio);
  return _Outcome(chord, variant, readingAt(readings, 1.5).chord);
}

String _percent(int hits, int total) =>
    '${(100 * hits / total).toStringAsFixed(1)} %';

/// Precisión del reconocedor sobre todo el banco de acordes sintetizado.
///
/// Cada posición del banco (cejillas, abiertos, power chords, séptimas, sus,
/// menores… en las 12 raíces) se sintetiza con [ChordAudioSynthesizer] y se
/// pasa por el reconocedor completo en bloques de 20 ms, como en la app.
void main() {
  late List<_Outcome> all;
  late List<_Outcome> easiest;

  setUpAll(() {
    final List<Chord> bank = loadChordBank().chords;
    all = <_Outcome>[
      for (final Chord chord in bank)
        for (final ChordVariant variant in chord.variants)
          _listen(chord, variant),
    ];
    easiest = <_Outcome>[
      for (final _Outcome outcome in all)
        if (outcome.variant == outcome.chord.easiestVariant) outcome,
    ];
  });

  test('imprime la precisión por calidad', () {
    final StringBuffer table = StringBuffer(
      '\nPrecisión por calidad (acierto estricto / con equivalentes)\n',
    );
    for (final ChordQuality quality in ChordQuality.values) {
      final List<_Outcome> group = <_Outcome>[
        for (final _Outcome o in all)
          if (o.chord.quality == quality) o,
      ];
      final int strict = group.where((_Outcome o) => o.strict).length;
      final int equivalent = group.where((_Outcome o) => o.equivalent).length;
      table.writeln(
        '  ${quality.id.padRight(5)} ${group.length.toString().padLeft(3)} '
        'posiciones: ${_percent(strict, group.length).padLeft(7)} / '
        '${_percent(equivalent, group.length).padLeft(7)}',
      );
    }
    final int strict = all.where((_Outcome o) => o.strict).length;
    final int equivalent = all.where((_Outcome o) => o.equivalent).length;
    table.writeln(
      '  TOTAL ${all.length} posiciones: '
      '${_percent(strict, all.length)} / ${_percent(equivalent, all.length)}',
    );
    final int easiestHits = easiest.where((_Outcome o) => o.equivalent).length;
    table.writeln(
      '  Posición más fácil de cada acorde: '
      '$easiestHits/${easiest.length} (${_percent(easiestHits, easiest.length)})',
    );
    // ignore: avoid_print
    print(table);
  });

  test('acierta más del 90 % del banco sintetizado (con equivalentes)', () {
    final int hits = all.where((_Outcome o) => o.equivalent).length;

    expect(hits / all.length, greaterThan(0.90));
  });

  test('acierta con el nombre exacto en la gran mayoría', () {
    final int hits = all.where((_Outcome o) => o.strict).length;

    expect(hits / all.length, greaterThan(0.78));
  });

  test('la posición más fácil de cada acorde (sin novenas) supera el 92 %', () {
    final List<_Outcome> common = <_Outcome>[
      for (final _Outcome o in easiest)
        if (o.chord.quality != ChordQuality.ninth) o,
    ];
    final int hits = common.where((_Outcome o) => o.equivalent).length;

    expect(hits / common.length, greaterThan(0.92));
  });

  test('cada calidad común supera el 80 %', () {
    // El acorde de novena queda fuera a propósito: en sus posiciones la 9.ª
    // es la nota aguda de una sola cuerda y coincide con el 3.er armónico de
    // la quinta, así que suena igual que la séptima de dominante.
    const Set<ChordQuality> ambiguous = <ChordQuality>{ChordQuality.ninth};
    for (final ChordQuality quality in ChordQuality.values) {
      if (ambiguous.contains(quality)) {
        continue;
      }
      final List<_Outcome> group = <_Outcome>[
        for (final _Outcome o in all)
          if (o.chord.quality == quality) o,
      ];
      final int hits = group.where((_Outcome o) => o.equivalent).length;

      expect(hits / group.length, greaterThan(0.80), reason: quality.id);
    }
  });

  test('las 12 raíces se reconocen con una precisión parecida', () {
    for (int root = 0; root < 12; root++) {
      final List<_Outcome> group = <_Outcome>[
        for (final _Outcome o in all)
          if (o.chord.root.pitchClass == root) o,
      ];
      final int hits = group.where((_Outcome o) => o.equivalent).length;

      expect(hits / group.length, greaterThan(0.75), reason: 'raíz $root');
    }
  });
}
