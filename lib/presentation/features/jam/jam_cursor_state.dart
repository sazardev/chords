import 'package:chords/domain/jam/jam_timeline.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';

/// El estado de la sesión tras llegar la semicorchea [cursor].
///
/// Devuelve el mismo [state] si nada que se vea cambia (la mayoría de las
/// semicorcheas), para que el controlador solo avise a la pantalla cuando
/// cambia el pulso, el compás o la fase.
JamState advanceTo(JamState state, JamCursor cursor) {
  final int slot = cursor.step ~/ 2;
  switch (cursor.kind) {
    case CursorKind.countIn:
      if (state.phase == JamPhase.countIn &&
          state.countdown == cursor.countdown &&
          state.slot == slot) {
        return state;
      }
      return state.copyWith(
        phase: JamPhase.countIn,
        slot: slot,
        countdown: cursor.countdown,
      );
    case CursorKind.playing:
      if (state.phase == JamPhase.playing &&
          state.bar == cursor.bar &&
          state.slot == slot) {
        return state;
      }
      return state.copyWith(
        phase: JamPhase.playing,
        countdown: 0,
        bar: cursor.bar,
        slot: slot,
      );
    case CursorKind.finished:
      return state;
  }
}
