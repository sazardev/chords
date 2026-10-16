import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:meta/meta.dart';

/// Orden de las familias en el catálogo de juegos.
const List<MiniGameCategory> kHubCategoryOrder = <MiniGameCategory>[
  MiniGameCategory.ear,
  MiniGameCategory.fretboard,
  MiniGameCategory.chords,
  MiniGameCategory.harmony,
  MiniGameCategory.play,
  MiniGameCategory.theory,
];

/// Qué se ve del catálogo: texto buscado, familia elegida y solo novedades.
@immutable
class HubFilter {
  /// Crea el filtro (por defecto, todo visible).
  const HubFilter({this.query = '', this.category, this.onlyNew = false});

  /// Texto que se busca en el nombre y la descripción de cada juego.
  final String query;

  /// Familia elegida; `null` para todas.
  final MiniGameCategory? category;

  /// Si solo se ven los juegos marcados como nuevos.
  final bool onlyNew;

  /// `true` si el filtro oculta algo.
  bool get isActive => query.trim().isNotEmpty || category != null || onlyNew;

  /// Copia con otro texto buscado.
  HubFilter withQuery(String value) =>
      HubFilter(query: value, category: category, onlyNew: onlyNew);

  /// Copia con otra familia; elegirla quita el filtro de novedades.
  HubFilter withCategory(MiniGameCategory? value) =>
      HubFilter(query: query, category: value);

  /// Copia que solo muestra novedades (o vuelve a mostrar todo).
  HubFilter withOnlyNew({required bool value}) =>
      HubFilter(query: query, onlyNew: value);
}

/// Minúsculas y sin tildes, para buscar sin fijarse en ellas.
String foldText(String text) {
  const String from = 'áàäâéèëêíìïîóòöôúùüûñ';
  const String to = 'aaaaeeeeiiiioooouuuun';
  final StringBuffer out = StringBuffer();
  for (final int rune in text.toLowerCase().runes) {
    final String char = String.fromCharCode(rune);
    final int at = from.indexOf(char);
    out.write(at < 0 ? char : to[at]);
  }
  return out.toString();
}

/// `true` si todas las palabras de [query] aparecen en alguno de [texts].
bool matchesQuery(String query, Iterable<String> texts) {
  final String haystack = foldText(texts.join(' '));
  return foldText(query)
      .split(RegExp(r'\s+'))
      .where((String word) => word.isNotEmpty)
      .every(haystack.contains);
}

/// Juegos que deja ver [filter], en el orden del catálogo.
List<MiniGameKind> filterGames(Translations t, HubFilter filter) =>
    <MiniGameKind>[
      for (final MiniGameCategory category in kHubCategoryOrder)
        if (filter.category == null || filter.category == category)
          for (final MiniGameKind kind in MiniGameKind.of(category))
            if ((!filter.onlyNew || kind.isNew) &&
                matchesQuery(filter.query, <String>[
                  gameTitle(t, kind),
                  gameDescription(t, kind),
                ]))
              kind,
    ];

/// `true` si la serie de "toca el acorde" se ve con [filter].
bool showsChordGame(Translations t, HubFilter filter) =>
    !filter.onlyNew &&
    (filter.category == null || filter.category == MiniGameCategory.play) &&
    matchesQuery(filter.query, <String>[
      t.minigames.chordGameTitle,
      t.minigames.chordGameSubtitle,
    ]);
