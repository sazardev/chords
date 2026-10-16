/// Escritor del banco extenso de acordes.
///
/// Recorre las 12 raíces y todas las calidades, pide las posiciones al
/// constructor de variantes y serializa el resultado a
/// `assets/chords/chords_db.json` consumido por la aplicación.
///
/// El formato es compacto: sin sangrías y solo con lo que no se puede deducir
/// (la app calcula los nombres, los alias, las notas y las etiquetas).
library;

import 'dart:convert';
import 'dart:io';

import 'package:chords/domain/chords/entities/barre_info.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/chord_variant_composer.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

import 'builder/chord_drafts.dart';
import 'chord_variant_draft.dart';

/// Versión del formato del banco.
const String kChordDbVersion = '2.0.0';

/// Resultado de la generación con estadísticas del banco.
class ChordDatabase {
  /// Crea el resultado de la generación.
  const ChordDatabase({
    required this.chordCount,
    required this.variantCount,
    required this.byDifficulty,
    required this.byQuality,
    required this.bytes,
  });

  /// Número de acordes distintos (raíz + calidad).
  final int chordCount;

  /// Número total de posiciones.
  final int variantCount;

  /// Conteo de acordes por nivel de dificultad mínima.
  final Map<String, int> byDifficulty;

  /// Conteo de posiciones por calidad.
  final Map<String, int> byQuality;

  /// Tamaño del archivo escrito, en bytes.
  final int bytes;
}

/// Acordes generados y los nombres de las formas del catálogo que usan.
class GeneratedBank {
  /// Crea el banco generado.
  const GeneratedBank(this.chords, this.shapeLabels);

  /// Todos los acordes, ordenados por identificador.
  final List<Chord> chords;

  /// Nombre de cada forma del catálogo usada (`e-shape` → `Forma de Mi`).
  final Map<String, String> shapeLabels;
}

/// Genera el banco completo y lo escribe en [outputPath].
ChordDatabase generateChordDatabase(String outputPath) {
  final GeneratedBank bank = buildAllChords();
  final List<Chord> chords = bank.chords;
  final int bytes = writeChordDatabase(outputPath, bank);
  return ChordDatabase(
    chordCount: chords.length,
    variantCount: chords.fold<int>(
      0,
      (int sum, Chord c) => sum + c.variantCount,
    ),
    byDifficulty: _countByDifficulty(chords),
    byQuality: _countByQuality(chords),
    bytes: bytes,
  );
}

/// Todos los acordes del banco (12 raíces × todas las calidades).
GeneratedBank buildAllChords() {
  final List<Chord> chords = <Chord>[];
  final Map<String, String> labels = <String, String>{};
  for (final ChordRoot root in ChordRoot.values) {
    for (final ChordQuality quality in ChordQuality.values) {
      final List<ChordVariant> variants = buildChordVariants(
        root,
        quality,
        labels,
      );
      if (variants.isNotEmpty) {
        chords.add(
          Chord(
            id: '${root.name}-${quality.id}',
            root: root,
            quality: quality,
            variants: variants,
          ),
        );
      }
    }
  }
  chords.sort((Chord a, Chord b) => a.id.compareTo(b.id));
  return GeneratedBank(chords, labels);
}

/// Documento JSON del banco.
Map<String, Object> chordDatabaseJson(GeneratedBank bank) => <String, Object>{
  'name': 'chords-db',
  'version': kChordDbVersion,
  'generator': 'chords_cli db generate',
  'labels': <String, String>{
    for (final String key in bank.shapeLabels.keys.toList()..sort())
      key: bank.shapeLabels[key]!,
  },
  'chords': bank.chords.map(chordToJson).toList(),
};

/// Escribe el documento JSON compacto del banco y devuelve su tamaño.
int writeChordDatabase(String outputPath, GeneratedBank bank) {
  final File file = File(outputPath);
  file.parent.createSync(recursive: true);
  final String text = jsonEncode(chordDatabaseJson(bank));
  file.writeAsStringSync('$text\n');
  return utf8.encode(text).length;
}

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
/// Anota en [labels] el nombre de cada forma del catálogo que aparece.
List<ChordVariant> buildChordVariants(
  ChordRoot root,
  ChordQuality quality,
  Map<String, String> labels,
) {
  final String chordId = '${root.name}-${quality.id}';
  return <ChordVariant>[
    for (final VariantDraft draft in buildChordDrafts(root, quality))
      composeVariant(
        chordId: chordId,
        root: root,
        quality: quality,
        id: draft.id,
        frets: draft.frets,
        fingers: draft.fingers,
        difficulty: draft.difficulty.level,
        barre: _barreOf(draft),
        shapeLabels: _registerLabel(draft, labels),
      ),
  ];
}

Map<String, String> _registerLabel(
  VariantDraft draft,
  Map<String, String> labels,
) {
  final String? label = draft.shapeLabel;
  if (label != null) {
    labels[VariantIdentity.parse(draft.id).key] = label;
  }
  return labels;
}

BarreInfo? _barreOf(VariantDraft draft) {
  final int? from = draft.barreFrom;
  return from == null
      ? null
      : BarreInfo(
          fret: draft.barreFret ?? 0,
          fromString: from,
          lastString: draft.barreToString ?? from,
        );
}

/// Serializa un acorde a JSON compacto.
Map<String, Object> chordToJson(Chord chord) => <String, Object>{
  'id': chord.id,
  'root': chord.root.name,
  'quality': chord.quality.id,
  'variants': chord.variants
      .map((ChordVariant v) => variantToJson(v, chord.id))
      .toList(),
};

/// Serializa una posición a JSON compacto.
///
/// Solo guarda lo que no se puede deducir: el identificador (sin el prefijo
/// del acorde), los trastes, los dedos, la dificultad y el cejillo si lo hay.
Map<String, Object> variantToJson(ChordVariant variant, String chordId) =>
    <String, Object>{
      'id': variant.id.substring(chordId.length + 1),
      'frets': variant.frets,
      'fingers': variant.fingers,
      'difficulty': variant.difficulty.level,
      if (variant.barre != null)
        'barre': <int>[
          variant.barre!.fret,
          variant.barre!.fromString,
          variant.barre!.lastString,
        ],
    };
