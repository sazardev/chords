@Timeout(Duration(minutes: 8))
library;

import 'dart:typed_data';

import 'package:chords/data/audio/chord_audio_synthesizer.dart';
import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/essential_chords.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:test/test.dart';

import '../../fakes/chord_bank.dart';
import '../../support/chord_audio_probe.dart';

/// Calidades que un guitarrista rasguea a diario: el vocabulario sobre el que
/// se exige la precisión. El resto de calidades del banco (extensiones,
/// alteradas, suspendidas con séptima…) también se reconocen, pero solo con
/// evidencia clara de su nota extra, y se miden aparte.
const Set<ChordQuality> _common = <ChordQuality>{
  ChordQuality.major,
  ChordQuality.minor,
  ChordQuality.seven,
  ChordQuality.minorSeven,
  ChordQuality.majorSeven,
  ChordQuality.suspendedSecond,
  ChordQuality.suspendedFourth,
  ChordQuality.power,
  ChordQuality.sixth,
  ChordQuality.minorSixth,
  ChordQuality.diminished,
  ChordQuality.augmented,
  ChordQuality.ninth,
};

/// De cada calidad común se prueba una posición de cada [_stride] (todas las
/// formas y las 12 raíces siguen representadas): el banco tiene más de 3.400
/// posiciones y sintetizarlas todas alargaría la suite sin aportar nada.
const int _stride = 4;

/// Posiciones que se prueban de [chord]: una de cada [_stride] y siempre la
/// más fácil, que es la que un guitarrista rasguea de verdad.
List<ChordVariant> _sample(Chord chord) => <ChordVariant>[
  for (int i = 0; i < chord.variants.length; i++)
    if (i % _stride == 0 || chord.variants[i] == chord.easiestVariant)
      chord.variants[i],
];

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

  /// Mismo acorde o uno que suena igual.
  ///
  /// Cuenta como acierto el acorde con exactamente las mismas notas que el
  /// acorde nominal (Am7 y C6, Asus2 y Esus4, C+ y E+) o que las que de verdad
  /// suenan en la posición: un C6 sin quinta (do, mi, la) es físicamente un Am,
  /// y solo el bajo y el contexto los distinguen.
  bool get equivalent {
    final ChordCandidate? got = heard;
    if (got == null) {
      return false;
    }
    final Set<int> nominal = chord.quality.pitchClassesOn(
      chord.root.pitchClass,
    );
    final Set<int> played = <int>{
      for (final String note in variant.notes) pitchClassOfNote(note),
    };
    return strict ||
        _same(got.pitchClasses, nominal) ||
        _same(got.pitchClasses, played);
  }

  static bool _same(Set<int> a, Set<int> b) =>
      a.length == b.length && a.containsAll(b);
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

double _rate(Iterable<_Outcome> group, bool Function(_Outcome) hit) {
  final List<_Outcome> list = group.toList();
  return list.where(hit).length / list.length;
}

/// Precisión del reconocedor sobre el banco de acordes sintetizado.
///
/// Cada posición se sintetiza con [ChordAudioSynthesizer] y se pasa por el
/// reconocedor completo en bloques de 20 ms, como en la app. El reconocedor
/// conoce todas las calidades del banco, pero las raras pagan una penalización
/// por su poca popularidad, de modo que un acorde normal no se lea como una
/// extensión.
void main() {
  late List<_Outcome> all;

  Iterable<_Outcome> common() =>
      all.where((_Outcome o) => _common.contains(o.chord.quality));

  setUpAll(() {
    final List<Chord> bank = loadChordBank().chords;
    all = <_Outcome>[
      for (final Chord chord in bank)
        if (_common.contains(chord.quality))
          for (final ChordVariant variant in _sample(chord))
            _listen(chord, variant)
        else
          _listen(chord, chord.easiestVariant),
    ];
  });

  test('imprime la precisión por calidad', () {
    final StringBuffer table = StringBuffer(
      '\nPrecisión por calidad (nombre exacto / con equivalentes)\n',
    );
    for (final ChordQuality quality in ChordQuality.values) {
      final List<_Outcome> group = <_Outcome>[
        for (final _Outcome o in all)
          if (o.chord.quality == quality) o,
      ];
      final int strict = group.where((_Outcome o) => o.strict).length;
      final int equivalent = group.where((_Outcome o) => o.equivalent).length;
      table.writeln(
        '  ${quality.id.padRight(7)} ${group.length.toString().padLeft(3)} '
        'posiciones${_common.contains(quality) ? '' : ' (rara)'}: '
        '${_percent(strict, group.length).padLeft(7)} / '
        '${_percent(equivalent, group.length).padLeft(7)}',
      );
    }
    final List<_Outcome> usual = common().toList();
    final int usualStrict = usual.where((_Outcome o) => o.strict).length;
    final int usualEquivalent = usual
        .where((_Outcome o) => o.equivalent)
        .length;
    table
      ..writeln(
        '  CALIDADES COMUNES ${usual.length} posiciones: '
        '${_percent(usualStrict, usual.length)}'
        ' / ${_percent(usualEquivalent, usual.length)}',
      )
      ..writeln(
        '  Sin acorde: ${usual.where((_Outcome o) => o.heard == null).length}',
      );
    // ignore: avoid_print
    print(table);
  });

  test('las calidades comunes se reconocen en más del 90 % (equivalentes)', () {
    expect(_rate(common(), (_Outcome o) => o.equivalent), greaterThan(0.90));
  });

  test('con el nombre exacto, las calidades comunes superan el 70 %', () {
    expect(_rate(common(), (_Outcome o) => o.strict), greaterThan(0.70));
  });

  test('los acordes esenciales se leen con su nombre exacto', () {
    final Iterable<_Outcome> essentials = all.where(
      (_Outcome o) =>
          kEssentialChordIds.contains(o.chord.id) &&
          o.variant == o.chord.easiestVariant,
    );

    expect(essentials, hasLength(kEssentialChordIds.length));
    for (final _Outcome o in essentials) {
      expect(o.heard?.id, o.chord.id, reason: o.chord.id);
    }
  });

  test('la posición más fácil de cada acorde común supera el 88 %', () {
    final Iterable<_Outcome> easiest = common().where(
      (_Outcome o) => o.variant == o.chord.easiestVariant,
    );

    expect(_rate(easiest, (_Outcome o) => o.equivalent), greaterThan(0.88));
  });

  test('cada calidad común supera el 70 %', () {
    // Es una red por debajo de la exigencia global (90 %): la séptima menor
    // es la más floja porque en sus posiciones cerradas de cuatro cuerdas
    // agudas la séptima suena en una sola cuerda aguda.
    for (final ChordQuality quality in _common) {
      final Iterable<_Outcome> group = all.where(
        (_Outcome o) => o.chord.quality == quality,
      );

      expect(
        _rate(group, (_Outcome o) => o.equivalent),
        greaterThan(0.70),
        reason: quality.id,
      );
    }
  });

  test('las 12 raíces se reconocen con una precisión parecida', () {
    for (int root = 0; root < 12; root++) {
      final Iterable<_Outcome> group = common().where(
        (_Outcome o) => o.chord.root.pitchClass == root,
      );

      expect(
        _rate(group, (_Outcome o) => o.equivalent),
        greaterThan(0.75),
        reason: 'raíz $root',
      );
    }
  });

  test('un acorde común casi nunca se lee como una extensión rara', () {
    final int stolen = common()
        .where(
          (_Outcome o) =>
              !o.equivalent &&
              o.heard != null &&
              !_common.contains(o.heard!.quality),
        )
        .length;

    expect(stolen / common().length, lessThan(0.03));
  });

  test(
    'las calidades raras también se reconocen cuando la evidencia es clara',
    () {
      final Iterable<_Outcome> rare = all.where(
        (_Outcome o) => !_common.contains(o.chord.quality),
      );

      // Con su nota extra a veces escondida entre armónicos, basta con que
      // una parte razonable salga con el nombre exacto.
      expect(_rate(rare, (_Outcome o) => o.strict), greaterThan(0.35));
    },
  );
}
