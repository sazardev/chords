import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/services/chord_quality_aliases.dart';
import 'package:chords/domain/chords/services/note_name_parser.dart';
import 'package:chords/domain/chords/services/search_text.dart';
import 'package:meta/meta.dart';

/// Búsqueda de acordes ya interpretada.
///
/// Entiende el cifrado (`Cm7`, `F#maj9`, `Bb7`), los nombres en español
/// (`Do mayor`, `Re menor 7`, `Lam`), las listas de notas (`C E G`, `do mi
/// sol`) y el texto libre (nombre, género, tipo de posición). Cada acorde
/// recibe una relevancia: 0 si es justo el que se pide, 1 si empieza por lo
/// escrito o lo contiene, 2 si solo coincide con alguna otra pista.
@immutable
class ChordQuery {
  const ChordQuery._({
    required this.text,
    this.root,
    this.quality,
    this.notes = const <int>{},
    this.bareRoot = false,
  });

  /// Interpreta el texto escrito en el buscador.
  factory ChordQuery.parse(String raw) {
    final String text = normalizeSearchText(raw);
    if (text.isEmpty) {
      return const ChordQuery._(text: '');
    }
    final Set<int>? notes = _noteList(raw);
    if (notes != null) {
      return ChordQuery._(text: text, notes: notes);
    }
    final ParsedNote? note = parseLeadingNote(raw);
    if (note == null) {
      return ChordQuery._(text: text);
    }
    final ChordRoot root = ChordRoot.values[note.pitchClass];
    final bool bare = note.rest.trim().isEmpty;
    final ChordQuality? quality = const ChordQualityAliases().lookup(note.rest);
    return ChordQuery._(
      text: text,
      root: quality == null ? null : root,
      quality: quality,
      bareRoot: bare,
    );
  }

  /// Texto normalizado (minúsculas, sin tildes).
  final String text;

  /// Raíz pedida (`Cm7` → Do), si el texto empieza por una nota seguida de un
  /// tipo de acorde reconocido.
  final ChordRoot? root;

  /// Tipo de acorde pedido (`m7`), si se reconoció.
  final ChordQuality? quality;

  /// Clases de tono de una lista de notas (`C E G` → 0, 4, 7).
  final Set<int> notes;

  /// `true` si solo se escribió una nota (`C`): se muestran todos los acordes
  /// de esa raíz con el mayor primero.
  final bool bareRoot;

  /// `true` si no hay nada que buscar.
  bool get isEmpty => text.isEmpty;

  /// Relevancia de [chord] (0 la mejor) o `null` si no coincide.
  int? relevance(Chord chord) {
    if (isEmpty) {
      return 0;
    }
    final int? structured = _structured(chord);
    final int? free = _free(chord);
    if (structured == null) {
      return free == null ? null : _demoted(chord, free);
    }
    return free == null || structured < free ? structured : free;
  }

  /// Si el texto se entendió como un acorde concreto (`CM7`), los demás que
  /// solo se le parecen por el nombre no pueden competir con él (`Cm7`), y
  /// con una raíz sola (`C`) tampoco los de otras raíces (`C#`).
  int _demoted(Chord chord, int relevance) {
    if (quality != null && relevance < 1) {
      return 1;
    }
    return bareRoot && chord.root != root && relevance < 2 ? 2 : relevance;
  }

  int? _structured(Chord chord) {
    if (notes.isNotEmpty) {
      final Set<int> tones = chord.quality.pitchClassesOn(
        chord.root.pitchClass,
      );
      if (tones.length == notes.length && tones.containsAll(notes)) {
        return 0;
      }
      return tones.containsAll(notes) ? 1 : null;
    }
    if (root == null || chord.root != root) {
      return null;
    }
    if (bareRoot) {
      return chord.quality == ChordQuality.major ? 0 : 1;
    }
    return chord.quality == quality ? 0 : null;
  }

  int? _free(Chord chord) {
    final String name = normalizeSearchText(chord.name);
    if (name == text) {
      return 0;
    }
    if (name.startsWith(text)) {
      return 1;
    }
    final String display = normalizeSearchText(chord.displayName);
    if (display.startsWith(text) || _qualityWords(chord).any(_startsWithText)) {
      return 1;
    }
    return _haystack(chord).any((String item) => item.contains(text))
        ? 2
        : null;
  }

  bool _startsWithText(String word) => word.startsWith(text);

  Iterable<String> _qualityWords(Chord chord) =>
      const ChordQualityAliases().wordsOf(chord.quality);

  Iterable<String> _haystack(Chord chord) => <String>[
    normalizeSearchText(chord.displayName),
    ...chord.aliases.map(normalizeSearchText),
    ..._qualityWords(chord),
    ...chord.quality.genres.map(normalizeSearchText),
    ...chord.variants.map(
      (ChordVariant v) => normalizeSearchText(v.positionLabel),
    ),
  ];

  /// Lista de notas (`C E G`, `do, mi, sol`): al menos dos y todas notas.
  static Set<int>? _noteList(String raw) {
    final List<String> tokens = raw
        .split(RegExp(r'[\s,;+/]+'))
        .where((String t) => t.isNotEmpty)
        .toList();
    if (tokens.length < 2) {
      return null;
    }
    final Set<int> notes = <int>{};
    for (final String token in tokens) {
      final int? pitchClass = parseWholeNote(token);
      if (pitchClass == null) {
        return null;
      }
      notes.add(pitchClass);
    }
    return notes;
  }
}
