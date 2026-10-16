import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';
import 'package:chords/domain/band/patterns/chord_pattern.dart';
import 'package:chords/domain/band/services/arranger_context.dart';
import 'package:chords/domain/band/services/chord_voicing.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Escribe el teclado y los vientos: acordes largos, medios y golpes cortos.
class KeysArranger {
  /// Crea el arreglista.
  const KeysArranger([this._voicing = const ChordVoicing()]);

  final ChordVoicing _voicing;

  /// Acorde de teclado en el paso [step] del compás [bar], si hay.
  List<BandEvent> keysAt(ArrangerContext context, int bar, int step) {
    final ChordPattern? pattern = context.preset.keysFor(context.beats);
    final (NoteLength, double)? hit = _hit(pattern, step);
    if (hit == null) {
      return const <BandEvent>[];
    }
    final ChordSymbol chord = context.chordAt(bar, step);
    return <BandEvent>[
      BandEvent(
        BandSound.keys(context.kinds.keys, hit.$1, _voicing.keys(chord)),
        (hit.$2 * context.gain).clamp(0.05, 1.0),
      ),
    ];
  }

  /// Acorde de vientos en el paso [step] del compás [bar], si hay.
  List<BandEvent> windsAt(ArrangerContext context, int bar, int step) {
    final ChordPattern? pattern = context.preset.windsFor(context.beats);
    final (NoteLength, double)? hit = _hit(pattern, step);
    if (hit == null) {
      return const <BandEvent>[];
    }
    final ChordSymbol chord = context.chordAt(bar, step);
    return <BandEvent>[
      BandEvent(
        BandSound.wind(context.kinds.wind, hit.$1, _voicing.winds(chord)),
        (hit.$2 * context.gain).clamp(0.05, 1.0),
      ),
    ];
  }

  (NoteLength, double)? _hit(ChordPattern? pattern, int step) {
    if (pattern == null) {
      return null;
    }
    return switch (pattern.at(step)) {
      'X' => (NoteLength.long, 0.8),
      'x' => (NoteLength.medium, 0.78),
      's' => (NoteLength.short, 0.82),
      'g' => (NoteLength.short, 0.4),
      _ => null,
    };
  }
}
