import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/patterns/band_preset.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Timbre de cada instrumento: lo que pide el usuario o, si lo deja en
/// automático, lo que trae el género.
class ResolvedKinds {
  /// Resuelve los timbres de [preset] con los ajustes de [config].
  const ResolvedKinds(this._preset, this._config);

  final BandPreset _preset;
  final BandConfig _config;

  /// Kit de batería.
  DrumKit get kit => _config.kit ?? _preset.kit;

  /// Tipo de bajo.
  BassKind get bass => _config.bass ?? _preset.bassKind;

  /// Tipo de guitarra.
  GuitarKind get guitar => _config.guitar ?? _preset.guitarKind;

  /// Tipo de teclado.
  KeysKind get keys => _config.keys ?? _preset.keysKind;

  /// Tipo de viento.
  WindKind get wind => _config.wind ?? _preset.windKind;
}

/// Lo que los arreglistas de cada instrumento necesitan saber de la sesión:
/// la pista, el género y los ajustes ya resueltos (el automático pasa al
/// valor del género).
class ArrangerContext {
  /// Crea el contexto.
  const ArrangerContext({
    required this.track,
    required this.preset,
    required this.config,
  });

  /// Pista que suena (ya transpuesta).
  final JamTrack track;

  /// Género de la banda.
  final BandPreset preset;

  /// Ajustes del usuario.
  final BandConfig config;

  /// Pulsos por compás (4 o 3).
  int get beats => track.strum.beatsPerBar;

  /// Timbre de cada instrumento: el elegido o el del género.
  ResolvedKinds get kinds => ResolvedKinds(preset, config);

  /// Ganancia general de la banda: carácter del género e intensidad.
  double get gain =>
      preset.punch *
      switch (config.intensity) {
        BandIntensity.soft => 0.72,
        BandIntensity.normal => 0.92,
        BandIntensity.strong => 1.0,
      };

  /// Compases de una frase (entre relleno y relleno).
  int get phrase {
    final int fill = preset.fillEvery;
    final int loop = track.loopBars;
    return loop >= fill ? fill : (fill ~/ loop) * loop;
  }

  /// `true` si el compás [bar] abre una vuelta.
  bool isLoopStart(int bar) => bar % track.loopBars == 0;

  /// `true` si el compás [bar] cierra una frase y lleva relleno.
  bool isFillBar(int bar) {
    if (!config.fills) {
      return false;
    }
    final int number = bar + 1;
    return number % phrase == 0 ||
        (track.loopBars >= 4 && number % track.loopBars == 0);
  }

  /// `true` si el compás [bar] usa la variante con más empuje.
  bool isLift(int bar) {
    final int position = bar % phrase;
    return switch (config.intensity) {
      BandIntensity.soft => false,
      BandIntensity.normal => position * 2 >= phrase,
      BandIntensity.strong => position != 0,
    };
  }

  /// Acorde del paso [step] del compás [bar].
  ChordSymbol chordAt(int bar, int step) => track.chordAtStep(bar, step);

  /// Siguiente acorde distinto del que suena en ese paso.
  ///
  /// Al final de la pista da la vuelta al principio, como en el bucle.
  ChordSymbol nextChord(int bar, int step) {
    final ChordSymbol now = chordAt(bar, step);
    final int count = track.bars.length;
    final int parts = track.bars[bar].chords.length;
    final int part = step * parts ~/ track.stepsPerBar;
    for (final ChordSymbol chord in track.bars[bar].chords.skip(part + 1)) {
      if (chord != now) {
        return chord;
      }
    }
    for (int offset = 1; offset <= count; offset++) {
      for (final ChordSymbol chord
          in track.bars[(bar + offset) % count].chords) {
        if (chord != now) {
          return chord;
        }
      }
    }
    return now;
  }
}
