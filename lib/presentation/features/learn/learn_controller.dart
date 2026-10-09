import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:flutter/foundation.dart';

/// Estado de la pantalla de aprendizaje.
enum LearnStatus {
  /// Cargando el itinerario.
  loading,

  /// Itinerario listo.
  ready,

  /// Falló la carga.
  error,
}

/// Controlador del itinerario de aprendizaje por niveles.
class LearnController extends ChangeNotifier {
  /// Crea el controlador.
  LearnController(this._repository, this._preferences);

  final ChordRepository _repository;
  final PreferencesService _preferences;

  Set<String> _mastered = <String>{};
  LearnStatus _status = LearnStatus.loading;

  /// Estado actual.
  LearnStatus get status => _status;

  /// Niveles del itinerario.
  List<LearningLevel> get levels => LearningLevel.values;

  /// Acordes dominados.
  Set<String> get mastered => _mastered;

  /// Acordes del nivel indicado (máximo 10).
  List<Chord> chordsOfLevel(int level) =>
      _repository.chordsByLevel(level).take(10).toList();

  /// Progreso global (0-1).
  double get progress {
    int total = 0;
    int done = 0;
    for (final LearningLevel level in LearningLevel.values) {
      final List<Chord> chords = chordsOfLevel(level.level);
      total += chords.length;
      done += chords
          .map((Chord chord) => chord.id)
          .where(_mastered.contains)
          .length;
    }
    if (total == 0) {
      return 0;
    }
    return done / total;
  }

  /// Progreso de un nivel concreto (0-1).
  double progressOfLevel(int level) {
    final List<Chord> chords = chordsOfLevel(level);
    if (chords.isEmpty) {
      return 0;
    }
    final int done = chords
        .map((Chord chord) => chord.id)
        .where(_mastered.contains)
        .length;
    return done / chords.length;
  }

  /// Siguiente acorde pendiente del itinerario.
  String? get nextChordId {
    for (final LearningLevel level in LearningLevel.values) {
      for (final Chord chord in chordsOfLevel(level.level)) {
        if (!_mastered.contains(chord.id)) {
          return chord.id;
        }
      }
    }
    return null;
  }

  /// Carga el banco y el progreso persistido.
  Future<void> load() async {
    _status = LearnStatus.loading;
    notifyListeners();
    try {
      if (!_repository.isLoaded) {
        await _repository.load();
      }
      _mastered = _preferences.masteredChordIds;
      _status = LearnStatus.ready;
    } on Object {
      _status = LearnStatus.error;
    }
    notifyListeners();
  }

  /// Marca un acorde como dominado (o lo desmarca).
  Future<void> toggleMastered(String chordId) async {
    final Set<String> updated = <String>{..._mastered};
    if (!updated.add(chordId)) {
      updated.remove(chordId);
    }
    _mastered = updated;
    await _preferences.setMasteredChordIds(updated);
    notifyListeners();
  }
}
