/// Generador del banco extenso de acordes.
///
/// Transpone las formas movibles del catálogo a las 12 raíces y busca tríadas
/// e inversiones cerradas sobre grupos de cuerdas. El resultado se serializa
/// a `assets/chords/chords_db.json` consumido por la aplicación.
library;

import 'dart:convert';
import 'dart:io';

import 'package:chords/domain/chords/entities/barre_info.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';

import '../src/chord_shape_catalog.dart';
import '../src/chord_theory.dart';

/// Resultado de la generación con estadísticas del banco.
class ChordDatabase {
  /// Crea el resultado de la generación.
  const ChordDatabase({
    required this.chordCount,
    required this.variantCount,
    required this.byDifficulty,
    required this.byQuality,
  });

  /// Número de acordes distintos (raíz + calidad).
  final int chordCount;

  /// Número total de posiciones.
  final int variantCount;

  /// Conteo de acordes por nivel de dificultad mínima.
  final Map<String, int> byDifficulty;

  /// Conteo de posiciones por calidad.
  final Map<String, int> byQuality;

  @override
  String toString() =>
      'ChordDatabase(chords: $chordCount, posiciones: $variantCount)';
}

/// Posición candidata construida por el generador.
class _VariantData {
  _VariantData({
    required this.id,
    required this.positionLabel,
    required this.frets,
    required this.fingers,
    required this.difficulty,
    required this.tags,
    this.barreFret,
    this.barreFrom,
    this.barreToString,
  });

  final String id;
  final String positionLabel;
  final List<int> frets;
  final List<int> fingers;
  final int? barreFret;
  final int? barreFrom;
  final int? barreToString;
  final Difficulty difficulty;
  final List<String> tags;
}

/// Genera el banco completo y lo escribe en [outputPath].
ChordDatabase generateChordDatabase(String outputPath) {
  final List<Chord> chords = <Chord>[];
  for (final ChordRoot root in ChordRoot.values) {
    for (final ChordQuality quality in ChordQuality.values) {
      final List<ChordVariant> variants = _buildVariantsFor(root, quality);
      if (variants.isEmpty) {
        continue;
      }
      chords.add(
        Chord(
          id: '${root.name}-${quality.id}',
          root: root,
          quality: quality,
          variants: variants,
          aliases: <String>[
            '${root.name}${quality.suffix}',
            '${root.displayName} ${quality.label}',
            root.name,
            root.displayName,
          ],
          tags: _chordTags(variants),
        ),
      );
    }
  }

  chords.sort((Chord a, Chord b) => a.id.compareTo(b.id));

  final Map<String, Object> database = <String, Object>{
    'name': 'chords-db',
    'version': '1.0.0',
    'generator': 'chords_cli db generate',
    'chords': chords.map(chordToJson).toList(),
  };
  final File file = File(outputPath);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(database));

  final Map<String, int> byDifficulty = <String, int>{};
  final Map<String, int> byQuality = <String, int>{};
  int variantCount = 0;
  for (final Chord chord in chords) {
    byDifficulty.update(
      chord.difficulty.label,
      (int value) => value + 1,
      ifAbsent: () => 1,
    );
    byQuality.update(
      chord.quality.id,
      (int value) => value + chord.variantCount,
      ifAbsent: () => chord.variantCount,
    );
    variantCount += chord.variantCount;
  }

  return ChordDatabase(
    chordCount: chords.length,
    variantCount: variantCount,
    byDifficulty: byDifficulty,
    byQuality: byQuality,
  );
}

/// Serializa un acorde a JSON plano.
Map<String, Object> chordToJson(Chord chord) => <String, Object>{
  'id': chord.id,
  'root': chord.root.name,
  'quality': chord.quality.id,
  'name': chord.name,
  'displayName': chord.displayName,
  'aliases': chord.aliases,
  'difficulty': chord.difficulty.level,
  'tags': chord.tags,
  'variants': chord.variants.map(variantToJson).toList(),
};

/// Serializa una posición a JSON plano.
Map<String, Object> variantToJson(ChordVariant variant) {
  final Object barreJson = switch (variant.barre) {
    final BarreInfo barre => <String, Object>{
      'fret': barre.fret,
      'from': barre.fromString,
      'to': barre.lastString,
    },
    null => <String, Object>{},
  };
  return <String, Object>{
    'id': variant.id,
    'position': variant.positionLabel,
    'frets': variant.frets,
    'fingers': variant.fingers,
    'difficulty': variant.difficulty.level,
    'barre': barreJson,
    'notes': variant.notes,
    'tags': variant.tags,
  };
}

/// Construye todas las posiciones de un acorde (raíz + calidad).
List<ChordVariant> _buildVariantsFor(ChordRoot root, ChordQuality quality) {
  final List<_VariantData> data = <_VariantData>[
    ..._shapeVariants(root, quality),
    ..._triadVariants(root, quality),
  ];
  final Set<String> seen = <String>{};
  final List<ChordVariant> variants = <ChordVariant>[];
  for (final _VariantData d in data) {
    if (!seen.add(d.frets.join(','))) {
      continue;
    }
    final BarreInfo? barreJson = switch (d.barreFret) {
      final int fret when d.barreFrom != null => BarreInfo(
        fret: fret,
        fromString: d.barreFrom!,
        lastString: d.barreToString ?? d.barreFrom!,
      ),
      _ => null,
    };
    variants.add(
      ChordVariant(
        id: '${root.name}-${quality.id}-${d.id}',
        positionLabel: d.positionLabel,
        frets: d.frets,
        fingers: d.fingers,
        difficulty: d.difficulty,
        barre: barreJson,
        notes: notesForFrets(d.frets),
        tags: d.tags,
      ),
    );
  }
  return variants;
}

/// Posiciones derivadas de las formas movibles transpuestas.
List<_VariantData> _shapeVariants(ChordRoot root, ChordQuality quality) {
  final List<_VariantData> result = <_VariantData>[];
  for (final MovableShapeSpec spec in kMovableShapes) {
    if (spec.qualityId != quality.id) {
      continue;
    }
    final int openPc = kStringTuning[spec.rootString] % 12;
    final int offset = spec.fretOffsets[spec.rootString]!;
    final int barre = (root.pitchClass - openPc - offset) % 12;

    final List<int> frets = <int>[];
    bool tooHigh = false;
    for (int s = 0; s < kStringCount; s++) {
      final int? o = spec.fretOffsets[s];
      if (o == null) {
        frets.add(-1);
        continue;
      }
      final int fret = barre + o;
      if (fret > 14) {
        tooHigh = true;
        break;
      }
      frets.add(fret);
    }
    if (tooHigh) {
      continue;
    }

    final List<int> barredStrings = <int>[
      for (int s = 0; s < kStringCount; s++)
        if (barre > 0 && frets[s] == barre) s,
    ];

    result.add(
      _VariantData(
        id: '${spec.id}-$barre',
        frets: frets,
        fingers: List<int>.of(
          barre == 0 ? spec.fingersOpen : spec.fingersBarre,
        ),
        difficulty: _difficultyForLevel(
          barre == 0 ? spec.difficultyOpen : spec.difficultyBarre,
        ),
        tags: <String>[
          ...spec.tags,
          if (barre == 0) 'open' else 'barre',
          if (barre >= 7) 'high-position',
        ],
        barreFret: barredStrings.length >= 2 ? barre : null,
        barreFrom: barredStrings.isEmpty ? null : barredStrings.first,
        barreToString: barredStrings.isEmpty ? null : barredStrings.last,
        positionLabel: barre == 0
            ? spec.positionLabel
            : '${spec.positionLabel} · traste $barre',
      ),
    );
  }
  return result;
}

/// Posiciones de tríadas e inversiones sobre grupos de cuerdas.
List<_VariantData> _triadVariants(ChordRoot root, ChordQuality quality) {
  if (quality.intervals.length > 3) {
    return const <_VariantData>[];
  }
  final List<_VariantData> result = <_VariantData>[];
  for (final List<int> set in kTriadStringSets) {
    _VariantData? best;
    int bestCost = 1 << 30;
    for (final List<int> assignment in _assignmentsFor(quality.intervals)) {
      final List<int> frets = List<int>.filled(kStringCount, -1);
      bool ok = true;
      for (int i = 0; i < set.length; i++) {
        final int stringIndex = set[i];
        final int? fret = fretForNoteOnString(
          stringIndex,
          noteNameOfPitchClass((root.pitchClass + assignment[i]) % 12),
        );
        if (fret == null || fret > 12) {
          ok = false;
          break;
        }
        frets[stringIndex] = fret;
      }
      if (!ok) {
        continue;
      }
      final List<int> pressed = set.map((int s) => frets[s]).toList();
      final int maxFret = pressed.reduce(_max);
      final int minFret = pressed.reduce(_min);
      final int span = maxFret - minFret;
      final int cost = maxFret * 3 + span * 2 + pressed.fold<int>(0, _add);
      if (cost >= bestCost) {
        continue;
      }
      bestCost = cost;
      final String lowestNote = noteNameOfPitchClass(
        (root.pitchClass + assignment.first) % 12,
      );
      best = _VariantData(
        id: 'triad-${_setId(set)}-$lowestNote',
        frets: frets,
        fingers: _triadFingers(set, frets),
        difficulty: _difficultyForLevel(span <= 2 && maxFret <= 5 ? 2 : 3),
        tags: const <String>['triad', 'inversion'],
        positionLabel: 'Triada ${_setLabel(set)} · bajo en $lowestNote',
      );
    }
    if (best != null) {
      result.add(best);
    }
  }
  return result;
}

/// Dedos para una tríada: por orden de traste dentro del grupo de cuerdas.
List<int> _triadFingers(List<int> set, List<int> frets) {
  final List<int> fingers = List<int>.filled(kStringCount, 0);
  final Map<int, int> byFret = <int, int>{};
  int next = 1;
  for (final int s in set) {
    final int fret = frets[s];
    if (fret == 0) {
      continue;
    }
    fingers[s] = byFret.putIfAbsent(fret, () => next++);
  }
  return fingers;
}

/// Identificador corto del grupo de cuerdas.
String _setId(List<int> set) => switch (set.first) {
  1 => 'adg',
  2 => 'dgb',
  _ => 'gbe',
};

/// Etiqueta legible del grupo de cuerdas.
String _setLabel(List<int> set) => switch (set.first) {
  1 => 'A-D-G',
  2 => 'D-G-B',
  _ => 'G-B-e',
};

/// Permutaciones de los intervalos de la calidad sobre 3 cuerdas.
///
/// Las cualidades de dos notas (power chords) duplican una de las dos notas
/// para cubrir el grupo de 3 cuerdas.
List<List<int>> _assignmentsFor(List<int> intervals) {
  if (intervals.length == 1) {
    return <List<int>>[
      <int>[intervals[0], intervals[0], intervals[0]],
    ];
  }
  if (intervals.length == 2) {
    final int a = intervals[0];
    final int b = intervals[1];
    return <List<int>>[
      <int>[a, b, a],
      <int>[a, a, b],
      <int>[b, a, a],
      <int>[a, b, b],
      <int>[b, a, b],
      <int>[b, b, a],
    ];
  }
  return _permutations(intervals);
}

/// Permutaciones de los intervalos de la calidad (hasta 3 notas).
List<List<int>> _permutations(List<int> items) {
  if (items.length == 1) {
    return <List<int>>[
      <int>[items[0]],
    ];
  }
  if (items.length == 2) {
    return <List<int>>[
      <int>[items[0], items[1]],
      <int>[items[1], items[0]],
    ];
  }
  final List<List<int>> result = <List<int>>[];
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (j == i) {
        continue;
      }
      for (int k = 0; k < 3; k++) {
        if (k == i || k == j) {
          continue;
        }
        result.add(<int>[items[i], items[j], items[k]]);
      }
    }
  }
  return result;
}

/// Etiquetas agregadas de un acorde a partir de sus posiciones.
List<String> _chordTags(List<ChordVariant> variants) =>
    <String>{for (final ChordVariant v in variants) ...v.tags}.toList();

int _max(int a, int b) => a > b ? a : b;

int _min(int a, int b) => a < b ? a : b;

int _add(int a, int b) => a + b;

/// Resuelve un nivel de dificultad tolerante (por defecto intermedio).
Difficulty _difficultyForLevel(int level) =>
    Difficulty.fromLevel(level) ?? Difficulty.medium;
