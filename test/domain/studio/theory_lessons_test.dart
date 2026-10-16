import 'package:chords/domain/studio/theory_lesson.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:flutter_test/flutter_test.dart';

/// La escuela de guitarra: ≥ 22 lecciones completas en los cuatro bloques.
void main() {
  test('hay al menos 22 lecciones y cada bloque tiene varias', () {
    expect(kTheoryLessons.length, greaterThanOrEqualTo(22));
    for (final LessonUnit unit in LessonUnit.values) {
      expect(
        kTheoryLessons.where((TheoryLesson l) => l.unit == unit).length,
        greaterThanOrEqualTo(3),
        reason: unit.name,
      );
    }
  });

  test('las lecciones de construcción de acordes, cadencias y afinaciones', () {
    for (final String id in <String>[
      'triads',
      'extensions',
      'inversions',
      'circleFifths',
      'cadences',
      'relativeParallel',
      'intervalSongs',
      'subdivision',
      'modesPractical',
      'styleComping',
      'transposeCapo',
      'tunings',
    ]) {
      expect(lessonById(id), isNotNull, reason: id);
    }
  });

  test('identificadores únicos y progresiones de práctica existentes', () {
    final Set<String> ids = <String>{};
    for (final TheoryLesson lesson in kTheoryLessons) {
      expect(ids.add(lesson.id), isTrue, reason: lesson.id);
      expect(lesson.emoji, isNotEmpty);
      final String? progression = lesson.progressionId;
      if (progression != null) {
        expect(progressionById(progression), isNotNull, reason: lesson.id);
      }
    }
  });

  test('cada lección ofrece una demostración o una práctica', () {
    for (final TheoryLesson lesson in kTheoryLessons) {
      final bool hasDemo = lesson.scale != null || lesson.showHarmony;
      final bool hasPractice =
          lesson.game != null || lesson.progressionId != null;
      expect(hasDemo || hasPractice, isTrue, reason: lesson.id);
    }
  });

  for (final AppLocale locale in AppLocale.values) {
    test('${locale.languageCode}: texto completo de cada lección', () {
      final Translations t = locale.buildSync();
      for (final TheoryLesson lesson in kTheoryLessons) {
        expect(t.theory.lessonTitles[lesson.id], isNotEmpty, reason: lesson.id);
        expect(
          t.theory.lessonSummaries[lesson.id],
          isNotEmpty,
          reason: lesson.id,
        );
        expect(
          t.theory.lessonBodies[lesson.id]!.split('\n\n').length,
          greaterThanOrEqualTo(2),
          reason: lesson.id,
        );
        expect(
          t.theory.lessonPoints[lesson.id]!.split('\n').length,
          greaterThanOrEqualTo(4),
          reason: lesson.id,
        );
      }
      expect(t.theory.unitTechnique, isNotEmpty);
    });
  }
}
