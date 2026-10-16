import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/services/search_text.dart';
import 'package:chords/domain/theory/entities/chord_suffixes.dart';

/// Reconoce el tipo de acorde que se escribe tras la raíz: `m7`, `maj9`,
/// `menor 7`, `minor seventh`, `sus`, `7#9`…
///
/// Primero se prueba la cifra tal cual (distingue `M7` de `m7`); si no, el
/// nombre en palabras, en español o en inglés, sin tildes ni mayúsculas.
class ChordQualityAliases {
  /// Crea el reconocedor.
  const ChordQualityAliases();

  /// Calidad que corresponde al texto [text] (sin la raíz), o `null`.
  ///
  /// El texto vacío es la calidad mayor.
  ChordQuality? lookup(String text) {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) {
      return ChordQuality.major;
    }
    return qualityOfSuffix(trimmed.replaceAll(' ', '')) ??
        _words[compactSearchText(trimmed)];
  }

  /// Todas las formas normalizadas de nombrar [quality] (para buscar por
  /// texto parcial: `menor`, `minor`, `septima`…).
  List<String> wordsOf(ChordQuality quality) => _wordsByQuality[quality]!;

  static final Map<String, ChordQuality> _words = _buildWords();

  static final Map<ChordQuality, List<String>> _wordsByQuality =
      <ChordQuality, List<String>>{
        for (final ChordQuality quality in ChordQuality.values)
          quality: <String>[
            for (final String raw in _rawNames(quality))
              if (_isWord(raw)) normalizeSearchText(raw),
          ],
      };

  static Map<String, ChordQuality> _buildWords() {
    final Map<String, ChordQuality> words = <String, ChordQuality>{};
    for (final ChordQuality quality in ChordQuality.values) {
      for (final String raw in _rawNames(quality)) {
        if (_isWord(raw)) {
          words.putIfAbsent(compactSearchText(raw), () => quality);
        }
      }
    }
    return words;
  }

  static Iterable<String> _rawNames(ChordQuality quality) => <String>[
    quality.label,
    quality.suffix,
    quality.id,
    ...quality.info.aliases,
  ];

  /// Las cifras de una letra o con `M` mayúscula son ambiguas al pasarlas a
  /// minúsculas (`M7` y `m7`); solo se aceptan como cifra exacta.
  static bool _isWord(String raw) =>
      raw.length > 1 && !raw.contains('M') && raw.trim().isNotEmpty;
}
