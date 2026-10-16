import 'package:chords/domain/band/clock/swing_grid.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';
import 'package:chords/domain/band/patterns/band_preset.dart';
import 'package:chords/domain/band/presets/band_preset_catalog.dart';
import 'package:chords/domain/band/services/arranger_context.dart';
import 'package:chords/domain/band/services/bass_arranger.dart';
import 'package:chords/domain/band/services/drum_arranger.dart';
import 'package:chords/domain/band/services/guitar_arranger.dart';
import 'package:chords/domain/band/services/keys_arranger.dart';
import 'package:chords/domain/jam/jam_track.dart';

/// El director de la banda: dice qué toca cada instrumento en cada paso de
/// semicorchea de la pista.
///
/// Es una función pura de la pista, el género y los ajustes: el mismo
/// (compás, paso) siempre da los mismos golpes, así que se puede probar sin
/// audio y recorrer entero para saber qué muestras hay que preparar.
class BandArranger {
  /// Crea el director para [track] con los [config] dados.
  ///
  /// El género es el elegido en los ajustes, el de la pista o, si no hay
  /// ninguno, el que sugiere su rasgueo.
  BandArranger(JamTrack track, BandConfig config)
    : context = ArrangerContext(
        track: track,
        preset: bandPresetFor(bandStyleOf(track, config)),
        config: config,
      );

  /// Contexto resuelto de la sesión.
  final ArrangerContext context;

  static const DrumArranger _drums = DrumArranger();
  static const BassArranger _bass = BassArranger();
  static const GuitarArranger _guitar = GuitarArranger();
  static const KeysArranger _keys = KeysArranger();

  /// Género de la banda.
  BandPreset get preset => context.preset;

  /// Swing efectivo (0 recto, 1 tresillo completo).
  double get swing => context.config.swing ?? preset.swing;

  /// Figuras sobre las que actúa el swing.
  SwingGrid get swingGrid => preset.swingGrid;

  /// Todos los golpes del paso [step] del compás [bar].
  List<BandEvent> eventsAt(int bar, int step) => <BandEvent>[
    ..._drums.eventsAt(context, bar, step),
    ..._bass.eventsAt(context, bar, step),
    ..._guitar.eventsAt(context, bar, step),
    ..._keys.keysAt(context, bar, step),
    ..._keys.windsAt(context, bar, step),
    ...clickAt(step),
  ];

  /// Clic del metrónomo si [step] cae en un pulso; el del primer pulso suena
  /// más agudo.
  List<BandEvent> clickAt(int step) => step % 4 == 0
      ? <BandEvent>[
          BandEvent(
            BandSound.click(
              step == 0 ? ClickAccent.accent : ClickAccent.normal,
            ),
            step == 0 ? 1 : 0.75,
          ),
        ]
      : const <BandEvent>[];

  /// Todas las muestras distintas que pedirá la pista entera, ordenadas.
  List<BandSound> sounds() {
    final Set<BandSound> found = <BandSound>{};
    final JamTrack track = context.track;
    for (int bar = 0; bar < track.bars.length; bar++) {
      for (int step = 0; step < track.stepsPerBar; step++) {
        for (final BandEvent event in eventsAt(bar, step)) {
          found.add(event.sound);
        }
      }
    }
    return found.toList()..sort();
  }
}
