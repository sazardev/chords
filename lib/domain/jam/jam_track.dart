import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:meta/meta.dart';

/// Un compás de la pista: sus acordes y la letra que empieza en él.
typedef JamBar = ({List<ChordSymbol> chords, String lyric});

/// Lo que suena en una sesión de jam: compases, tempo, ritmo y escala.
@immutable
class JamTrack {
  /// Crea la pista.
  const JamTrack({
    required this.key,
    required this.title,
    required this.bars,
    required this.bpm,
    required this.strum,
    required this.tonic,
    this.scale,
  });

  /// Pista a partir de una progresión en la tónica [tonic], repetida [loops]
  /// veces.
  factory JamTrack.fromProgression(
    ChordProgression progression, {
    required int tonic,
    required String title,
    int loops = 4,
  }) {
    final List<List<ChordSymbol>> once = progression.barsIn(tonic);
    return JamTrack(
      key: 'prog:${progression.id}',
      title: title,
      bars: <JamBar>[
        for (int loop = 0; loop < loops; loop++)
          for (final List<ChordSymbol> bar in once) (chords: bar, lyric: ''),
      ],
      bpm: progression.bpm,
      strum: progression.strum,
      tonic: tonic,
      scale: progression.scale,
    );
  }

  /// Pista a partir de una canción transportada [transpose] semitonos.
  ///
  /// [title] sustituye al título de la canción (p. ej. ya traducido).
  factory JamTrack.fromSong(Song song, {int transpose = 0, String? title}) {
    final List<JamBar> bars = <JamBar>[];
    for (final SongSection section in song.sections) {
      for (final SongLine line in section.lines) {
        for (int i = 0; i < line.bars.length; i++) {
          bars.add((
            chords: <ChordSymbol>[
              for (final String token in line.bars[i].split(' '))
                ChordSymbol.parse(token).transpose(transpose),
            ],
            lyric: i == 0 ? line.lyric : '',
          ));
        }
      }
    }
    final ChordSymbol first = bars.first.chords.first;
    return JamTrack(
      key: 'song:${song.id}',
      title: title ?? song.title,
      bars: bars,
      bpm: song.bpm,
      strum: song.strum,
      tonic: first.root,
      scale: first.quality.intervals.contains(3)
          ? ScaleType.minorPentatonic
          : ScaleType.majorPentatonic,
    );
  }

  /// Pista con acordes elegidos a mano, un compás por acorde.
  factory JamTrack.custom(
    List<ChordSymbol> chords, {
    required String title,
    int bpm = 80,
    StrumPattern strum = StrumPattern.quarters,
    int loops = 4,
  }) => JamTrack(
    key: 'custom',
    title: title,
    bars: <JamBar>[
      for (int loop = 0; loop < loops; loop++)
        for (final ChordSymbol chord in chords)
          (chords: <ChordSymbol>[chord], lyric: ''),
    ],
    bpm: bpm,
    strum: strum,
    tonic: chords.first.root,
  );

  /// Identificador para guardar el récord (`song:bamba`).
  final String key;

  /// Título que se muestra.
  final String title;

  /// Compases en orden.
  final List<JamBar> bars;

  /// Tempo recomendado.
  final int bpm;

  /// Rasgueo y compás.
  final StrumPattern strum;

  /// Tónica (0 = Do).
  final int tonic;

  /// Escala sugerida para improvisar encima, si la hay.
  final ScaleType? scale;

  /// Huecos de corchea por compás.
  int get slotsPerBar => strum.notation.length;

  /// Acorde que suena en el hueco [slot] del compás [bar].
  ChordSymbol chordAt(int bar, int slot) {
    final List<ChordSymbol> chords = bars[bar].chords;
    final int part = slot * chords.length ~/ slotsPerBar;
    return chords[part.clamp(0, chords.length - 1)];
  }

  /// La misma pista a otro tempo.
  JamTrack withBpm(int value) => JamTrack(
    key: key,
    title: title,
    bars: bars,
    bpm: value,
    strum: strum,
    tonic: tonic,
    scale: scale,
  );
}
