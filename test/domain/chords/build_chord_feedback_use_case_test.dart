import 'package:chords/domain/chords/entities/chord_match_feedback.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:chords/domain/chords/usecases/build_chord_feedback_use_case.dart';
import 'package:test/test.dart';

/// Tests del feedback del objetivo: notas, cuerdas y sobrantes.
void main() {
  const BuildChordFeedbackUseCase buildFeedback = BuildChordFeedbackUseCase();

  // Do mayor abierto x32010: 6ª muda, 5ª traste 3 = C, 4ª 2 = E,
  // 3ª 0 = G, 2ª 1 = C, 1ª 0 = E.
  const List<int> openCMajor = <int>[-1, 3, 2, 0, 1, 0];
  const List<String> cMajorNotes = <String>['C', 'E', 'G'];

  test('marca acertadas, faltantes y sus cuerdas', () {
    final ChordMatchFeedback feedback = buildFeedback(
      frets: openCMajor,
      targetNotes: cMajorNotes,
      heardNotes: <String>{'C', 'E'},
    );

    expect(feedback.total, 3);
    expect(feedback.heardCount, 2);
    expect(feedback.isComplete, isFalse);
    final TargetNoteFeedback missing = feedback.missing.single;
    expect(missing.note, 'G');
    expect(missing.strings, <int>[3]);
    expect(
      feedback.notes
          .firstWhere((TargetNoteFeedback n) => n.note == 'C')
          .strings,
      <int>[5, 2],
    );
    expect(feedback.extraNotes, isEmpty);
  });

  test('detecta las notas que suenan de más', () {
    final ChordMatchFeedback feedback = buildFeedback(
      frets: openCMajor,
      targetNotes: cMajorNotes,
      heardNotes: <String>{'C', 'E', 'G', 'D'},
    );

    expect(feedback.isComplete, isTrue);
    expect(feedback.missing, isEmpty);
    expect(feedback.extraNotes, <String>['D']);
  });

  test('sin objetivo devuelve un feedback vacío', () {
    final ChordMatchFeedback feedback = buildFeedback(
      frets: const <int>[],
      targetNotes: const <String>[],
      heardNotes: <String>{'C'},
    );

    expect(feedback.total, 0);
    expect(feedback.isComplete, isFalse);
    expect(feedback.extraNotes, <String>['C']);
  });

  test('estado por cuerda: mudas, reconocidas y pendientes', () {
    final List<PracticeStringStatus> statuses = buildFeedback.stringStatuses(
      frets: openCMajor,
      heardNotes: <String>{'C', 'G'},
    );

    expect(statuses, <PracticeStringStatus>[
      PracticeStringStatus.muted,
      PracticeStringStatus.matched, // 5ª: C
      PracticeStringStatus.pending, // 4ª: E
      PracticeStringStatus.matched, // 3ª: G
      PracticeStringStatus.matched, // 2ª: C
      PracticeStringStatus.pending, // 1ª: E
    ]);
  });
}
