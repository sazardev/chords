import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/hub_filter.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:flutter_test/flutter_test.dart';

/// El filtro del catálogo: texto, familia y novedades, en español e inglés.
void main() {
  final Translations es = AppLocale.es.buildSync();
  final Translations en = AppLocale.en.buildSync();

  List<MiniGameKind> games(Translations t, HubFilter filter) =>
      filterGames(t, filter);

  test('sin filtro salen los 39 juegos, por familias y sin repetir', () {
    final List<MiniGameKind> all = games(es, const HubFilter());
    expect(all.length, MiniGameKind.values.length);
    expect(all.toSet().length, all.length);
    final List<MiniGameCategory> order = <MiniGameCategory>[];
    for (final MiniGameKind kind in all) {
      if (order.isEmpty || order.last != kind.category) {
        order.add(kind.category);
      }
    }
    expect(order, kHubCategoryOrder, reason: 'cada familia, un solo bloque');
  });

  test('las familias nuevas van entre el mástil y el micrófono', () {
    expect(kHubCategoryOrder, <MiniGameCategory>[
      MiniGameCategory.ear,
      MiniGameCategory.fretboard,
      MiniGameCategory.chords,
      MiniGameCategory.harmony,
      MiniGameCategory.play,
      MiniGameCategory.theory,
    ]);
    expect(kHubCategoryOrder.toSet().length, MiniGameCategory.values.length);
  });

  test('elegir una familia solo deja sus juegos', () {
    for (final MiniGameCategory category in MiniGameCategory.values) {
      final List<MiniGameKind> found = games(es, HubFilter(category: category));
      expect(found, MiniGameKind.of(category));
    }
  });

  test('las novedades son los juegos marcados como nuevos', () {
    final List<MiniGameKind> news = games(es, const HubFilter(onlyNew: true));
    expect(news.length, 17);
    expect(news.every((MiniGameKind k) => k.isNew), isTrue);
    final HubFilter chosen = const HubFilter(onlyNew: true)
        .withCategory(MiniGameCategory.ear);
    expect(
      chosen.onlyNew,
      isFalse,
      reason: 'elegir familia quita las novedades',
    );
    expect(games(es, chosen), MiniGameKind.of(MiniGameCategory.ear));
    expect(
      games(
        es,
        const HubFilter(onlyNew: true, category: MiniGameCategory.harmony),
      ),
      MiniGameKind.of(MiniGameCategory.harmony),
    );
  });

  test('buscar ignora mayúsculas y tildes', () {
    expect(games(es, const HubFilter(query: 'DELETREA')), <MiniGameKind>[
      MiniGameKind.spellChord,
    ]);
    expect(
      games(es, const HubFilter(query: 'fórmula')),
      games(es, const HubFilter(query: 'formula')),
    );
    expect(games(es, const HubFilter(query: 'formula')), isNotEmpty);
  });

  test('buscar mira el nombre y la descripción en el idioma activo', () {
    expect(
      games(en, const HubFilter(query: 'caged')),
      contains(MiniGameKind.cagedShape),
    );
    expect(games(en, const HubFilter(query: 'spell')), <MiniGameKind>[
      MiniGameKind.spellChord,
    ]);
    expect(games(es, const HubFilter(query: 'spell')), isEmpty);
  });

  test('varias palabras deben aparecer todas', () {
    final List<MiniGameKind> found = games(
      es,
      const HubFilter(query: 'racha séptimas'),
    );
    expect(found, <MiniGameKind>[MiniGameKind.rushSeventh]);
    expect(games(es, const HubFilter(query: 'racha zzz')), isEmpty);
  });

  test('un texto sin resultados deja el catálogo vacío', () {
    expect(games(es, const HubFilter(query: 'xyz123')), isEmpty);
  });

  test('la serie de acordes sigue su propio filtro', () {
    expect(showsChordGame(es, const HubFilter()), isTrue);
    expect(
      showsChordGame(es, const HubFilter(category: MiniGameCategory.ear)),
      isFalse,
    );
    expect(
      showsChordGame(es, const HubFilter(category: MiniGameCategory.play)),
      isTrue,
    );
    expect(showsChordGame(es, const HubFilter(onlyNew: true)), isFalse);
    expect(
      showsChordGame(es, const HubFilter(query: 'Toca el acorde')),
      isTrue,
    );
    expect(showsChordGame(es, const HubFilter(query: 'xyz123')), isFalse);
  });

  test('el filtro sabe si oculta algo', () {
    expect(const HubFilter().isActive, isFalse);
    expect(const HubFilter(query: '  ').isActive, isFalse);
    expect(const HubFilter(query: 'a').isActive, isTrue);
    expect(const HubFilter(onlyNew: true).isActive, isTrue);
    expect(const HubFilter(category: MiniGameCategory.ear).isActive, isTrue);
  });

  test('cada juego es hallable por su propio nombre', () {
    for (final Translations t in <Translations>[es, en]) {
      for (final MiniGameKind kind in MiniGameKind.values) {
        expect(
          games(t, HubFilter(query: gameTitle(t, kind))),
          contains(kind),
          reason: '${t.minigames.hubTitle}: ${kind.id}',
        );
      }
    }
  });
}
