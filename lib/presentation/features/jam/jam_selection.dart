import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:meta/meta.dart';

/// De dónde sale la pista del jam.
enum JamSource {
  /// Una progresión del catálogo.
  progression,

  /// Una canción del cancionero.
  song,

  /// Acordes elegidos a mano.
  custom,
}

/// Lo que se ha elegido para tocar: origen, tono y acordes propios.
@immutable
class JamSelection {
  /// Crea la selección.
  const JamSelection({
    this.source = JamSource.progression,
    this.progressionId = 'popAxis',
    this.songId = 'bamba',
    this.tonic,
    this.transpose = 0,
    this.custom = const <ChordSymbol>[],
  });

  /// Selección a partir de los parámetros de la ruta.
  factory JamSelection.fromQuery(Map<String, String> query) {
    final String? song = query['song'];
    if (song != null && songById(song) != null) {
      return JamSelection(
        source: JamSource.song,
        songId: song,
        transpose: int.tryParse(query['transpose'] ?? '') ?? 0,
      );
    }
    final String? prog = query['prog'];
    return JamSelection(
      progressionId: progressionById(prog) == null ? 'popAxis' : prog!,
      tonic: int.tryParse(query['key'] ?? ''),
    );
  }

  /// Origen.
  final JamSource source;

  /// Progresión elegida.
  final String progressionId;

  /// Canción elegida.
  final String songId;

  /// Tónica de la progresión; `null` = la suya por defecto.
  final int? tonic;

  /// Semitonos de transporte de la canción.
  final int transpose;

  /// Acordes de la progresión propia.
  final List<ChordSymbol> custom;

  /// Progresión elegida.
  ChordProgression get progression => progressionById(progressionId)!;

  /// Canción elegida.
  Song get song => songById(songId)!;

  /// Tónica efectiva de la progresión.
  int get progressionTonic => tonic ?? progression.tonic;

  /// Copia con cambios.
  JamSelection copyWith({
    JamSource? source,
    String? progressionId,
    String? songId,
    int? tonic,
    bool resetTonic = false,
    int? transpose,
    List<ChordSymbol>? custom,
  }) => JamSelection(
    source: source ?? this.source,
    progressionId: progressionId ?? this.progressionId,
    songId: songId ?? this.songId,
    tonic: resetTonic ? null : (tonic ?? this.tonic),
    transpose: transpose ?? this.transpose,
    custom: custom ?? this.custom,
  );

  /// Pista lista para el controlador; `null` si la progresión propia está
  /// vacía.
  JamTrack? toTrack(Translations t) => switch (source) {
    JamSource.progression => JamTrack.fromProgression(
      progression,
      tonic: progressionTonic,
      title: progressionName(t, progression),
    ),
    JamSource.song => JamTrack.fromSong(
      song,
      transpose: transpose,
      title: songTitle(t, song),
    ),
    JamSource.custom =>
      custom.isEmpty ? null : JamTrack.custom(custom, title: t.jam.customTitle),
  };
}
