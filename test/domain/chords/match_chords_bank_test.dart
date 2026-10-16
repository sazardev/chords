import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/usecases/match_chords_by_pitch_classes_use_case.dart';
import 'package:test/test.dart';

import '../../support/real_bank.dart';

/// El reconocimiento de acordes por notas con el banco completo.
void main() {
  const MatchChordsByPitchClassesUseCase match =
      MatchChordsByPitchClassesUseCase();

  test('las notas de un acorde sugieren el acorde, los habituales primero', () {
    final List<Chord> result = match(realBank(), <int>{0, 4, 7});
    expect(result.first.id, 'C-maj');
    expect(result.length, lessThanOrEqualTo(12));
  });

  test('una séptima menor se reconoce como tal', () {
    final List<Chord> result = match(realBank(), <int>{0, 3, 7, 10});
    expect(result.first.id, 'C-m7');
    expect(result.map((Chord c) => c.id), contains('C-m7'));
  });

  test('con pocas notas no se llena la lista de rarezas', () {
    final List<Chord> result = match(realBank(), <int>{0, 4, 7, 10, 2, 9});
    expect(result.length, lessThanOrEqualTo(12));
    expect(match(realBank(), <int>{0, 4, 7, 10, 2, 9}, limit: 3).length, 3);
    expect(match(realBank(), <int>{}), isEmpty);
  });
}
