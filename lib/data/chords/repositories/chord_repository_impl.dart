import 'package:chords/data/chords/datasources/chord_asset_datasource.dart';
import 'package:chords/data/chords/models/chord_model.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/essential_chords.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';

/// Implementación del repositorio de acordes basada en el asset JSON.
class ChordRepositoryImpl implements ChordRepository {
  /// Crea el repositorio con el origen de datos indicado.
  ChordRepositoryImpl({ChordAssetDataSource? dataSource})
    : _dataSource = dataSource ?? const ChordAssetDataSource();

  final ChordAssetDataSource _dataSource;
  final Map<String, Chord> _byId = <String, Chord>{};
  List<Chord> _chords = const <Chord>[];

  @override
  List<Chord> get chords => _chords;

  @override
  bool get isLoaded => _chords.isNotEmpty;

  @override
  Future<void> load() async {
    if (isLoaded) {
      return;
    }
    final Map<String, Object?> database = await _dataSource.fetchDatabase();
    final List<Chord> parsed = _parse(database);
    if (parsed.isEmpty) {
      throw const FormatException('El banco de acordes está vacío');
    }
    _chords = parsed;
    _byId
      ..clear()
      ..addEntries(parsed.map((Chord c) => MapEntry<String, Chord>(c.id, c)));
  }

  @override
  Chord? chordById(String id) => _byId[id];

  @override
  List<Chord> chordsByPitchClasses(Set<int> pitchClasses) {
    if (pitchClasses.isEmpty) {
      return const <Chord>[];
    }
    return _chords.where((Chord chord) {
      final Set<int> notes = chord.easiestVariant.notes
          .map(pitchClassOfNote)
          .toSet();
      return notes.containsAll(pitchClasses);
    }).toList();
  }

  @override
  List<Chord> chordsByGenre(String genre) => _chords
      .where((Chord chord) => chord.quality.genres.contains(genre))
      .toList();

  @override
  List<Chord> chordsByLevel(int level) =>
      _chords
          .where((Chord chord) => LearningLevel.of(chord).level == level)
          .toList()
        ..sort(
          (Chord a, Chord b) => a.root.pitchClass.compareTo(b.root.pitchClass),
        );

  @override
  List<Chord> essentialFirst(List<Chord> chords) {
    final List<Chord> sorted = List<Chord>.of(chords)
      ..sort((Chord a, Chord b) {
        final int byEssential = _essentialRank(b) - _essentialRank(a);
        if (byEssential != 0) {
          return byEssential;
        }
        final int byDifficulty = a.difficulty.level.compareTo(
          b.difficulty.level,
        );
        if (byDifficulty != 0) {
          return byDifficulty;
        }
        return a.root.pitchClass.compareTo(b.root.pitchClass);
      });
    return sorted;
  }

  /// 0 si el acorde es esencial, 1 en caso contrario.
  int _essentialRank(Chord chord) =>
      kEssentialChordIds.contains(chord.id) ? 0 : 1;

  List<Chord> _parse(Map<String, Object?> database) {
    final Object? rawChords = database['chords'];
    if (rawChords is! List<Object?>) {
      throw const FormatException('Falta la lista de acordes');
    }
    final List<Chord> result = <Chord>[];
    for (final Object? item in rawChords) {
      if (item is! Map<String, Object?>) {
        continue;
      }
      final Chord? chord = ChordModel.fromJson(item).toEntity();
      if (chord != null) {
        result.add(chord);
      }
    }
    return result;
  }
}
