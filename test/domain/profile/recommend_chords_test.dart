import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/usecases/recommend_chords_use_case.dart';
import 'package:chords/domain/profile/entities/experience_level.dart';
import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:chords/domain/profile/entities/player_profile.dart';
import 'package:test/test.dart';

Chord _chord(
  String id,
  ChordRoot root,
  ChordQuality quality,
  int level, {
  List<String> tags = const <String>['open'],
}) => Chord(
  id: id,
  root: root,
  quality: quality,
  variants: <ChordVariant>[
    ChordVariant(
      id: '$id-1',
      positionLabel: 'p',
      frets: const <int>[0, 0, 0, 0, 0, 0],
      fingers: const <int>[0, 0, 0, 0, 0, 0],
      difficulty: Difficulty.fromLevel(level)!,
      tags: tags,
    ),
  ],
);

/// Tests de las recomendaciones según el perfil.
void main() {
  const RecommendChordsUseCase recommend = RecommendChordsUseCase();

  final List<Chord> chords = <Chord>[
    _chord('C-maj', ChordRoot.c, ChordQuality.major, 1),
    _chord('A-min', ChordRoot.a, ChordQuality.minor, 1),
    _chord(
      'F-maj',
      ChordRoot.f,
      ChordQuality.major,
      3,
      tags: <String>['barre'],
    ),
    _chord('E-9', ChordRoot.e, ChordQuality.ninth, 5, tags: <String>['jazz']),
    _chord('E-5', ChordRoot.e, ChordQuality.power, 2, tags: <String>['power']),
  ];

  test('nunca recomienda por encima de la dificultad de su experiencia', () {
    final List<Chord> result = recommend(chords, const PlayerProfile());
    expect(
      result.every((Chord c) => c.difficulty.level <= 2),
      isTrue,
      reason: result.toString(),
    );
    expect(result.map((Chord c) => c.id), isNot(contains('E-9')));
  });

  test('un principiante recibe primero los esenciales fáciles', () {
    final List<Chord> result = recommend(chords, const PlayerProfile());
    expect(result.first.id, anyOf('C-maj', 'A-min'));
  });

  test('el género favorito sube los acordes que suenan en él', () {
    final List<Chord> result = recommend(
      chords,
      const PlayerProfile(
        genres: <String>{'Jazz'},
        experience: ExperienceLevel.advanced,
      ),
    );
    expect(result.first.id, 'E-9');
  });

  test('un avanzado ve acordes más difíciles que un principiante', () {
    final List<Chord> beginner = recommend(chords, const PlayerProfile());
    final List<Chord> advanced = recommend(
      chords,
      const PlayerProfile(experience: ExperienceLevel.advanced),
    );
    expect(advanced.map((Chord c) => c.id), contains('F-maj'));
    expect(beginner.map((Chord c) => c.id), isNot(contains('F-maj')));
  });

  test('guitarra eléctrica favorece power chords; clásica los evita', () {
    final List<Chord> electric = recommend(
      chords,
      const PlayerProfile(
        guitar: GuitarType.electric,
        genres: <String>{'Rock'},
      ),
    );
    final List<Chord> classical = recommend(
      chords,
      const PlayerProfile(guitar: GuitarType.classical),
    );
    final List<Chord> acoustic = recommend(
      chords,
      const PlayerProfile(genres: <String>{'Rock'}),
    );
    expect(
      electric.indexWhere((Chord c) => c.id == 'E-5'),
      lessThanOrEqualTo(acoustic.indexWhere((Chord c) => c.id == 'E-5')),
    );
    expect(classical.last.id, 'E-5');
  });

  test('los acordes dominados no se recomiendan y se respeta el límite', () {
    final List<Chord> result = recommend(
      chords,
      const PlayerProfile(),
      mastered: <String>{'C-maj'},
      limit: 1,
    );
    expect(result, hasLength(1));
    expect(result.single.id, isNot('C-maj'));
  });
}
