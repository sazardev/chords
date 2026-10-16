/// Buscador de voicings: elige qué nota del acorde toca cada cuerda.
///
/// Para cada plan prueba todas las formas de repartir las notas del acorde
/// entre las cuerdas (cubriendo siempre las imprescindibles), calcula los
/// trastes más cómodos y se queda con la digitación más baja por cada nota
/// del bajo. Es lo que da las tríadas, los shells y los drop 2 / drop 3.
library;

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

import '../chord_theory.dart';
import '../chord_variant_draft.dart';
import '../fingering/fingering_solver.dart';
import 'variant_difficulty.dart';
import 'voicing_kind.dart';
import 'voicing_plan.dart';

/// Traste más alto que se busca.
const int kMaxSearchFret = 14;

/// Posiciones que ofrecen todos los planes aplicables a [quality].
List<VariantDraft> buildSearchedVoicings(
  ChordRoot root,
  ChordQuality quality,
) => <VariantDraft>[
  for (final VoicingPlan plan in kVoicingPlans)
    if (plan.applies(quality)) ..._searchPlan(plan, root, quality),
];

/// Mejor voicing del plan por cada nota posible en el bajo.
List<VariantDraft> _searchPlan(
  VoicingPlan plan,
  ChordRoot root,
  ChordQuality quality,
) {
  final Set<int> allowed = <int>{
    for (final int interval in quality.intervals) interval % 12,
  };
  final Map<int, _Candidate> bestByBass = <int, _Candidate>{};
  for (final List<int> intervals in _assignments(
    allowed.toList()..sort(),
    plan.strings.length,
    quality.requiredIntervals,
  )) {
    final int bass = intervals.first;
    if (!plan.anyBass && bass != 0) {
      continue;
    }
    final _Candidate? candidate = _candidateFor(plan, root, intervals);
    final _Candidate? current = bestByBass[bass];
    if (candidate != null &&
        (current == null || candidate.cost < current.cost)) {
      bestByBass[bass] = candidate;
    }
  }
  return <VariantDraft>[
    for (final MapEntry<int, _Candidate> entry in bestByBass.entries)
      _toDraft(plan, entry.value),
  ];
}

/// Una forma concreta de tocar un reparto de notas.
class _Candidate {
  const _Candidate(this.intervals, this.frets, this.fingers, this.cost);

  final List<int> intervals;
  final List<int> frets;
  final List<int> fingers;
  final int cost;
}

/// Trastes y digitación más cómodos de un reparto, o `null` si no hay.
///
/// Cada nota puede tocarse en su traste más bajo o una octava más arriba;
/// se prueban todas las combinaciones y se queda la de menor coste.
_Candidate? _candidateFor(
  VoicingPlan plan,
  ChordRoot root,
  List<int> intervals,
) {
  final List<int> lows = <int>[
    for (int i = 0; i < plan.strings.length; i++)
      fretForNoteOnString(
            plan.strings[i],
            noteNameOfPitchClass((root.pitchClass + intervals[i]) % 12),
          ) ??
          99,
  ];
  _Candidate? best;
  for (int mask = 0; mask < 1 << lows.length; mask++) {
    final List<int> played = <int>[
      for (int i = 0; i < lows.length; i++) lows[i] + ((mask >> i) & 1) * 12,
    ];
    if (played.any((int f) => f > kMaxSearchFret) || !_comfortable(played)) {
      continue;
    }
    final int cost = _cost(played);
    if (best != null && cost >= best.cost) {
      continue;
    }
    final List<int> frets = List<int>.filled(kStringCount, -1);
    for (int i = 0; i < played.length; i++) {
      frets[plan.strings[i]] = played[i];
    }
    final List<int>? fingers = solveFingering(frets);
    if (fingers != null) {
      best = _Candidate(intervals, frets, fingers, cost);
    }
  }
  return best;
}

/// Una mano cómoda: apertura de cuatro trastes y cuerdas al aire solo cerca
/// de la cejuela.
bool _comfortable(List<int> played) {
  final List<int> pressed = played.where((int f) => f > 0).toList()..sort();
  if (pressed.isEmpty) {
    return true;
  }
  if (pressed.last - pressed.first > 3) {
    return false;
  }
  return played.every((int f) => f > 0) || pressed.last <= 5;
}

/// Coste de una digitación: castiga los trastes altos y los estiramientos.
int _cost(List<int> played) {
  final List<int> sorted = List<int>.of(played)..sort();
  final List<int> pressed = sorted.where((int f) => f > 0).toList();
  final int span = pressed.length < 2 ? 0 : pressed.last - pressed.first;
  final int open = sorted.length - pressed.length;
  return sorted.last * 3 + span * 4 + pressed.fold<int>(0, _add) - open;
}

/// Repartos de [allowed] en [count] cuerdas que cubren los [required].
Iterable<List<int>> _assignments(
  List<int> allowed,
  int count,
  Set<int> required, [
  List<int> prefix = const <int>[],
]) sync* {
  if (prefix.length == count) {
    if (required.every(prefix.contains)) {
      yield prefix;
    }
    return;
  }
  for (final int interval in allowed) {
    yield* _assignments(allowed, count, required, <int>[...prefix, interval]);
  }
}

/// Convierte el mejor reparto en una posición candidata.
///
/// El identificador lleva el tipo, las cuerdas y la nota del bajo:
/// `drop2-4321-b3`.
VariantDraft _toDraft(VoicingPlan plan, _Candidate candidate) {
  final String strings = plan.strings.map((int s) => 6 - s).join();
  final VariantKind kind = voicingKind(plan, candidate.frets);
  return VariantDraft(
    id: '${kind.name}-$strings-b${candidate.intervals.first}',
    frets: candidate.frets,
    fingers: candidate.fingers,
    difficulty: difficultyForLevel(1),
  );
}

int _add(int a, int b) => a + b;
