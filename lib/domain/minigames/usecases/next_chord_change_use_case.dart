import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/generators/chord_pool.dart';
import 'package:chords/domain/minigames/generators/chord_quiz_generators.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Caso de uso: elige el acorde que sigue en "cambios de acorde".
///
/// Los acordes salen del banco según la dificultad (los de posición más fácil
/// primero) y nunca se repite el anterior ni uno que suene lo mismo, para que
/// cada cambio sea de verdad un cambio.
class NextChordChangeUseCase {
  /// Crea el caso de uso; [random] permite fijar la semilla en las pruebas.
  NextChordChangeUseCase(this._repository, {math.Random? random})
    : _random = random ?? math.Random();

  final ChordRepository _repository;
  final math.Random _random;

  /// Acordes que pueden salir en [level].
  List<Chord> poolFor(MiniGameLevel level) {
    final List<Chord> pool = <Chord>[
      for (final Chord chord in chordPoolFor(_repository, level))
        if (chord.quality.intervals.length >= 3) chord,
    ];
    return pool.length >= 3 ? pool : _repository.chords;
  }

  /// Acorde siguiente a [previous] (el primero si es `null`).
  Chord call(MiniGameLevel level, {Chord? previous}) {
    final List<Chord> pool = poolFor(level);
    final List<Chord> options = <Chord>[
      for (final Chord chord in pool)
        if (previous == null || !_sameSound(chord, previous)) chord,
    ];
    final List<Chord> source = options.isEmpty ? pool : options;
    return source[_random.nextInt(source.length)];
  }

  bool _sameSound(Chord a, Chord b) => sameNotes(
    ChordSymbol(a.root.pitchClass, a.quality),
    ChordSymbol(b.root.pitchClass, b.quality),
  );
}
