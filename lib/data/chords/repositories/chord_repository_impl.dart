import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/data/chords/datasources/chord_asset_datasource.dart';
import 'package:chords/data/chords/models/chord_database_parser.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/services/chord_sorter.dart';
import 'package:flutter/foundation.dart' show compute;

/// Implementación del repositorio de acordes basada en el asset JSON.
class ChordRepositoryImpl implements ChordRepository {
  /// Crea el repositorio con el origen de datos indicado.
  ///
  /// Con [parseInIsolate] el banco se decodifica y se construye en otro
  /// isolate para no bloquear la interfaz durante el arranque.
  ChordRepositoryImpl({
    ChordAssetDataSource? dataSource,
    this.parseInIsolate = false,
  }) : _dataSource = dataSource ?? const ChordAssetDataSource();

  /// Si el banco se lee en un isolate aparte.
  final bool parseInIsolate;

  final ChordAssetDataSource _dataSource;
  static const ChordSorter _sorter = ChordSorter();
  final Map<String, Chord> _byId = <String, Chord>{};
  List<Chord> _chords = const <Chord>[];

  @override
  List<Chord> get chords => _chords;

  @override
  bool get isLoaded => _chords.isNotEmpty;

  /// Carga en curso: las llamadas simultáneas esperan a la misma lectura.
  Future<void>? _loading;

  @override
  Future<void> load() {
    if (isLoaded) {
      return Future<void>.value();
    }
    return _loading ??= _read().whenComplete(() => _loading = null);
  }

  Future<void> _read() async {
    final Stopwatch watch = Stopwatch()..start();
    final String raw = await _dataSource.fetchRaw();
    final ParsedChordDatabase database = parseInIsolate
        ? await compute(parseChordDatabaseText, raw)
        : parseChordDatabaseText(raw);
    final List<Chord> parsed = database.chords;
    if (database.discarded > 0) {
      appLogger.warning(
        '${database.discarded} elementos del banco descartados',
        channel: LogChannel.chords,
        context: <String, Object?>{
          'discarded': database.discarded,
          'parsed': parsed.length,
        },
      );
    }
    if (parsed.isEmpty) {
      throw const FormatException('El banco de acordes está vacío');
    }
    _chords = parsed;
    _byId
      ..clear()
      ..addEntries(parsed.map((Chord c) => MapEntry<String, Chord>(c.id, c)));
    watch.stop();
    appLogger.info(
      'banco de acordes cargado',
      channel: LogChannel.chords,
      context: <String, Object?>{
        'count': parsed.length,
        'durationMs': watch.elapsed.inMilliseconds,
      },
    );
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
  List<Chord> chordsByLevel(int level) => _sorter.learningOrder(<Chord>[
    for (final Chord chord in _chords)
      if (LearningLevel.of(chord).level == level) chord,
  ]);

  @override
  List<Chord> essentialFirst(List<Chord> chords) =>
      _sorter.sort(chords, ChordSort.essentials);
}
