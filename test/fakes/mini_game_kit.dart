import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/preferences/repositories/preferences_repository.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_mic_keeper.dart';
import 'package:chords/presentation/features/minigames/build_chord_controller.dart';
import 'package:chords/presentation/features/minigames/mic_game_controller.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/minigames/quiz_controller.dart';
import 'package:chords/presentation/features/minigames/sound_cue_player.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Controladores de los minijuegos listos para pruebas.
///
/// El reproductor no espera entre notas para que las preguntas con
/// secuencia de sonidos terminen al instante. [clock] gobierna el tiempo del
/// oyente de órdenes de guitarra.
class MiniGameKit {
  /// Construye los controladores sobre los repositorios indicados.
  factory MiniGameKit({
    required ChordRepository chords,
    required AudioRepository audio,
    required PreferencesRepository preferences,
    DateTime Function()? clock,
  }) {
    final MiniGameProgressController progress = MiniGameProgressController(
      preferences,
    );
    final SoundCuePlayer player = SoundCuePlayer(
      audio,
      chords,
      wait: (Duration duration) async {},
    );
    final GuitarCommandListener guitar = GuitarCommandListener(
      audio,
      clock: clock,
    );
    return MiniGameKit._(
      progress: progress,
      quiz: QuizController(chords, player, progress),
      build: BuildChordController(chords, audio, progress),
      mic: MicGameController(
        audio,
        player,
        progress,
        confirmations: 1,
        guitar: guitar,
      ),
      guitar: guitar,
      keeper: GuitarMicKeeper(audio, guitar),
    );
  }

  MiniGameKit._({
    required this.progress,
    required this.quiz,
    required this.build,
    required this.mic,
    required this.guitar,
    required this.keeper,
  });

  /// Progreso y estrellas.
  final MiniGameProgressController progress;

  /// Juegos de opciones.
  final QuizController quiz;

  /// Arma el acorde.
  final BuildChordController build;

  /// Juegos con micrófono.
  final MicGameController mic;

  /// Oyente de las órdenes de guitarra.
  final GuitarCommandListener guitar;

  /// Guardián del micrófono del catálogo.
  final GuitarMicKeeper keeper;

  /// Providers para montar las pantallas.
  List<SingleChildWidget> get providers => <SingleChildWidget>[
    ChangeNotifierProvider<MiniGameProgressController>.value(value: progress),
    ChangeNotifierProvider<QuizController>.value(value: quiz),
    ChangeNotifierProvider<BuildChordController>.value(value: build),
    ChangeNotifierProvider<MicGameController>.value(value: mic),
    ChangeNotifierProvider<GuitarCommandListener>.value(value: guitar),
    Provider<GuitarMicKeeper>.value(value: keeper),
  ];
}
