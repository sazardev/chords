/// Escritor del banco extenso de acordes.
///
/// Recorre las 12 raíces y todas las calidades, pide las posiciones al
/// constructor de variantes y serializa el resultado a
/// `assets/chords/chords_db.json` consumido por la aplicación.
library;

import 'dart:convert';
import 'dart:io';

import 'package:chords/domain/chords/entities/barre_info.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';

import 'chord_theory.dart';
import 'chord_variant_builder.dart';
import 'chord_variant_draft.dart';

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
}

/// Genera el banco completo y lo escribe en [outputPath].
ChordDatabase generateChordDatabase(String outputPath) {
  final List<Chord> chords = <Chord>[];
  for (final ChordRoot root in ChordRoot.values) {
    for (final ChordQuality quality in ChordQuality.values) {
      final List<ChordVariant> variants = buildChordVariants(root, quality);
      if (variants.isEmpty) {
        continue;
      }
      chords.add(_buildChord(root, quality, variants));
    }
  }

  chords.sort((Chord a, Chord b) => a.id.compareTo(b.id));
  writeChordDatabase(outputPath, chords);

  return ChordDatabase(
    chordCount: chords.length,
    variantCount: chords.fold<int>(
      0,
      (int sum, Chord c) => sum + c.variantCount,
    ),
    byDifficulty: _countByDifficulty(chords),
    byQuality: _countByQuality(chords),
  );
}

/// Construye el acorde con sus alias y etiquetas.
Chord _buildChord(
  ChordRoot root,
  ChordQuality quality,
  List<ChordVariant> variants,
) => Chord(
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
  tags: chordTags(variants),
);

/// Documento JSON del banco para la lista de acordes indicada.
Map<String, Object> chordDatabaseJson(List<Chord> chords) => <String, Object>{
  'name': 'chords-db',
  'version': '1.0.0',
  'generator': 'chords_cli db generate',
  'chords': chords.map(chordToJson).toList(),
};

/// Escribe el documento JSON del banco en [outputPath].
void writeChordDatabase(String outputPath, List<Chord> chords) {
  final File file = File(outputPath);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(chordDatabaseJson(chords)),
  );
}

/// Conteo de acordes por dificultad mínima.
Map<String, int> _countByDifficulty(List<Chord> chords) {
  final Map<String, int> counts = <String, int>{};
  for (final Chord chord in chords) {
    counts.update(
      chord.difficulty.label,
      (int value) => value + 1,
      ifAbsent: () => 1,
    );
  }
  return counts;
}

/// Conteo de posiciones por calidad.
Map<String, int> _countByQuality(List<Chord> chords) {
  final Map<String, int> counts = <String, int>{};
  for (final Chord chord in chords) {
    counts.update(
      chord.quality.id,
      (int value) => value + chord.variantCount,
      ifAbsent: () => chord.variantCount,
    );
  }
  return counts;
}

/// Construye todas las posiciones de un acorde (raíz + calidad).
///
/// Combina las formas transportadas y las tríadas, descartando digitaciones
/// duplicadas y enlazando cada candidata con su acorde.
List<ChordVariant> buildChordVariants(ChordRoot root, ChordQuality quality) {
  final List<VariantDraft> drafts = <VariantDraft>[
    ...buildShapeVariants(root, quality),
    ...buildTriadVariants(root, quality),
  ];
  final Set<String> seen = <String>{};
  final List<ChordVariant> variants = <ChordVariant>[];
  for (final VariantDraft draft in drafts) {
    if (!seen.add(draft.frets.join(','))) {
      continue;
    }
    variants.add(_toVariant(root, quality, draft));
  }
  return variants;
}

/// Convierte una candidata en posición del acorde.
ChordVariant _toVariant(
  ChordRoot root,
  ChordQuality quality,
  VariantDraft draft,
) {
  final int? barreFrom = draft.barreFrom;
  final BarreInfo? barre = barreFrom == null
      ? null
      : BarreInfo(
          fret: draft.barreFret ?? 0,
          fromString: barreFrom,
          lastString: draft.barreToString ?? barreFrom,
        );
  return ChordVariant(
    id: '${root.name}-${quality.id}-${draft.id}',
    positionLabel: draft.positionLabel,
    frets: draft.frets,
    fingers: draft.fingers,
    difficulty: draft.difficulty,
    barre: barre,
    notes: notesForFrets(draft.frets),
    tags: draft.tags,
  );
}

/// Etiquetas agregadas de un acorde a partir de sus posiciones.
List<String> chordTags(List<ChordVariant> variants) =>
    <String>{for (final ChordVariant v in variants) ...v.tags}.toList();

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
