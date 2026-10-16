import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/services/chord_stabilizer.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:test/test.dart';

ChordCandidate _c(
  ChordRoot root,
  ChordQuality quality,
  double score, [
  double confidence = 0.9,
]) => ChordCandidate(
  root: root,
  quality: quality,
  score: score,
  confidence: confidence,
);

final ChordCandidate _cMajor = _c(ChordRoot.c, ChordQuality.major, 0.95);
final ChordCandidate _cMaj7 = _c(ChordRoot.c, ChordQuality.majorSeven, 0.93);
final ChordCandidate _aMinor7 = _c(ChordRoot.a, ChordQuality.minorSeven, 0.92);
final ChordCandidate _gMajor = _c(ChordRoot.g, ChordQuality.major, 0.97);

/// Tests de la histéresis del acorde reconocido.
void main() {
  test('el primer candidato fiable se acepta al instante', () {
    final ChordStabilizer stabilizer = ChordStabilizer();

    expect(stabilizer.update(<ChordCandidate>[_cMajor, _cMaj7]), _cMajor);
  });

  test('no parpadea entre acordes parecidos con puntuaciones que bailan', () {
    final ChordStabilizer stabilizer = ChordStabilizer()
      ..update(<ChordCandidate>[_cMajor, _cMaj7, _aMinor7]);
    final List<String?> shown = <String?>[];

    // Los tres se turnan en cabeza con ventajas mínimas.
    for (int i = 0; i < 12; i++) {
      final List<ChordCandidate> ranked = switch (i % 3) {
        0 => <ChordCandidate>[
          _c(ChordRoot.c, ChordQuality.majorSeven, 0.951),
          _cMajor,
        ],
        1 => <ChordCandidate>[
          _c(ChordRoot.a, ChordQuality.minorSeven, 0.952),
          _cMajor,
        ],
        _ => <ChordCandidate>[_cMajor, _cMaj7],
      };
      shown.add(stabilizer.update(ranked)?.id);
    }

    expect(shown.toSet(), <String?>{'C-maj'});
  });

  test('cambia con ventaja clara tras pocas tramas seguidas', () {
    final ChordStabilizer stabilizer = ChordStabilizer()
      ..update(<ChordCandidate>[_cMajor]);

    // Una trama aislada no basta.
    expect(stabilizer.update(<ChordCandidate>[_gMajor, _cMajor])?.id, 'C-maj');
    // La segunda seguida con ventaja clara (0.97 contra 0.80) sí.
    expect(
      stabilizer.update(<ChordCandidate>[
        _gMajor,
        _c(ChordRoot.c, ChordQuality.major, 0.8),
      ])?.id,
      'G-maj',
    );
  });

  test('con ventaja corta exige más tramas seguidas', () {
    final ChordStabilizer stabilizer = ChordStabilizer()
      ..update(<ChordCandidate>[_cMajor]);
    final ChordCandidate narrow = _c(ChordRoot.a, ChordQuality.minor, 0.97);
    final ChordCandidate held = _c(ChordRoot.c, ChordQuality.major, 0.95);

    for (int i = 0; i < 4; i++) {
      expect(stabilizer.update(<ChordCandidate>[narrow, held])?.id, 'C-maj');
    }
    expect(stabilizer.update(<ChordCandidate>[narrow, held])?.id, 'A-min');
  });

  test('un aspirante que se interrumpe vuelve a empezar la cuenta', () {
    final ChordStabilizer stabilizer = ChordStabilizer()
      ..update(<ChordCandidate>[_cMajor]);
    final ChordCandidate weakC = _c(ChordRoot.c, ChordQuality.major, 0.8);

    stabilizer
      ..update(<ChordCandidate>[_gMajor, weakC])
      ..update(<ChordCandidate>[_cMajor]);

    expect(stabilizer.update(<ChordCandidate>[_gMajor, weakC])?.id, 'C-maj');
  });

  test('suelta el acorde tras varias tramas sin confianza', () {
    final ChordStabilizer stabilizer = ChordStabilizer(dropFrames: 3)
      ..update(<ChordCandidate>[_cMajor]);
    final ChordCandidate weak = _c(ChordRoot.c, ChordQuality.major, 0.6, 0.1);

    expect(stabilizer.update(<ChordCandidate>[weak])?.id, 'C-maj');
    expect(stabilizer.update(<ChordCandidate>[weak])?.id, 'C-maj');
    expect(stabilizer.update(<ChordCandidate>[weak]), isNull);
    expect(stabilizer.current, isNull);
  });

  test('una lista vacía cuenta como trama débil y reset lo olvida todo', () {
    final ChordStabilizer stabilizer = ChordStabilizer()
      ..update(<ChordCandidate>[_cMajor]);

    expect(stabilizer.update(const <ChordCandidate>[])?.id, 'C-maj');

    stabilizer.reset();
    expect(stabilizer.current, isNull);
  });
}
