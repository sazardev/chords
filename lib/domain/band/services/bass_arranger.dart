import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';
import 'package:chords/domain/band/patterns/bass_pattern.dart';
import 'package:chords/domain/band/services/arranger_context.dart';
import 'package:chords/domain/band/services/bass_line.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Escribe el bajo: sigue la raíz y la quinta del acorde que suena.
class BassArranger {
  /// Crea el arreglista.
  const BassArranger([this._line = const BassLine()]);

  final BassLine _line;

  /// Nota de bajo en el paso [step] del compás [bar], si hay.
  List<BandEvent> eventsAt(ArrangerContext context, int bar, int step) {
    final BassPattern pattern = context.preset.bassFor(
      context.beats,
      lift: context.isLift(bar),
    );
    if (step >= pattern.steps) {
      return const <BandEvent>[];
    }
    final String token = pattern.notation[step];
    final int? note = pattern.walking
        ? _walk(context, bar, step, token)
        : _line.noteFor(
            token,
            context.chordAt(bar, step),
            context.nextChord(bar, step),
          );
    if (note == null) {
      return const <BandEvent>[];
    }
    final bool dead = token == 'r';
    final NoteLength length = dead
        ? NoteLength.short
        : (pattern.walking ? NoteLength.long : _length(pattern, step));
    final double base = dead ? 0.4 : (step % 4 == 0 ? 0.92 : 0.78);
    return <BandEvent>[
      BandEvent(
        BandSound.bass(context.kinds.bass, note, length),
        (base * context.gain).clamp(0.05, 1.0),
      ),
    ];
  }

  /// Nota caminante de la negra que cae en [step], o `null` si no es `W`.
  int? _walk(ArrangerContext context, int bar, int step, String token) {
    if (token != 'W') {
      return null;
    }
    int? previous;
    for (int beat = 0; beat <= step ~/ 4; beat++) {
      final int at = beat * 4;
      final ChordSymbol chord = context.chordAt(bar, at);
      previous = _line.walking(
        beat,
        bar,
        chord,
        context.nextChord(bar, at),
        previous: previous,
      );
    }
    return previous;
  }

  /// Duración según lo que tarda en llegar la siguiente nota o silencio.
  NoteLength _length(BassPattern pattern, int step) {
    int next = step + 1;
    while (next < pattern.steps && pattern.notation[next] == '-') {
      next++;
    }
    final int gap = next - step;
    if (gap <= 2) {
      return NoteLength.short;
    }
    return gap <= 6 ? NoteLength.medium : NoteLength.long;
  }
}
