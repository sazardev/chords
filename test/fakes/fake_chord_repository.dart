import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';

/// Repositorio de acordes en memoria para pruebas.
class FakeChordRepository implements ChordRepository {
  /// Crea el repositorio con los acordes indicados.
  FakeChordRepository(this._chords);

  final List<Chord> _chords;
  bool _loaded = false;

  @override
  List<Chord> get chords => _chords;

  @override
  bool get isLoaded => _loaded;

  @override
  Future<void> load() async {
    _loaded = true;
  }

  @override
  Chord? chordById(String id) {
    for (final Chord chord in _chords) {
      if (chord.id == id) {
        return chord;
      }
    }
    return null;
  }

  @override
  List<Chord> chordsByPitchClasses(Set<int> pitchClasses) => _chords
      .where(
        (Chord chord) => chord.easiestVariant.notes
            .map(_pitchClass)
            .toSet()
            .containsAll(pitchClasses),
      )
      .toList();

  @override
  List<Chord> chordsByGenre(String genre) => _chords
      .where((Chord chord) => chord.quality.genres.contains(genre))
      .toList();

  @override
  List<Chord> chordsByLevel(int level) =>
      _chords.where((Chord chord) => levelOf(chord) == level).toList();

  @override
  List<Chord> essentialFirst(List<Chord> chords) => chords;

  /// Nivel asignado al acorde según su dificultad.
  int levelOf(Chord chord) => chord.difficulty.level;

  int _pitchClass(String note) {
    const List<String> names = <String>[
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B',
    ];
    return names.indexOf(note);
  }
}
