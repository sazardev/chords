import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Carga del banco desde los assets, en el hilo principal y en otro isolate.
void main() {
  testWidgets('el banco carga y es el mismo en el hilo principal y en un '
      'isolate', (WidgetTester tester) async {
    final ChordRepository inline = ChordRepositoryImpl();
    final ChordRepository isolated = ChordRepositoryImpl(parseInIsolate: true);
    final Stopwatch watch = Stopwatch()..start();
    await tester.runAsync(() async {
      await inline.load();
      watch.stop();
      await isolated.load();
    });
    expect(inline.isLoaded, isTrue);
    expect(isolated.chords.length, inline.chords.length);
    expect(
      isolated.chords.length,
      12 * ChordQuality.values.length,
      reason: 'raíces × tipos de acorde',
    );
    for (int i = 0; i < inline.chords.length; i++) {
      final Chord a = inline.chords[i];
      final Chord b = isolated.chords[i];
      expect(b.id, a.id);
      expect(b.variantCount, a.variantCount);
      expect(b.variants.first.frets, a.variants.first.frets);
      expect(b.variants.first.positionLabel, a.variants.first.positionLabel);
      expect(b.variants.first.tags, a.variants.first.tags);
    }
    // Leer y construir ~400 acordes y ~3.500 posiciones tiene que ser rápido
    // (en la VM de pruebas, en frío, suele estar por debajo de 300 ms).
    expect(watch.elapsedMilliseconds, lessThan(3000));
  });

  testWidgets('el repositorio responde por id, por nivel y por notas', (
    WidgetTester tester,
  ) async {
    final ChordRepository repository = ChordRepositoryImpl();
    await tester.runAsync(repository.load);
    expect(repository.chordById('F#-m7b5')?.name, 'F#m7b5');
    expect(repository.chordById('nada'), isNull);
    final List<Chord> beginners = repository.chordsByLevel(1);
    expect(beginners.length, 8);
    final List<Chord> cMajor = repository.chordsByPitchClasses(<int>{0, 4, 7});
    expect(cMajor.map((Chord c) => c.id), contains('C-maj'));
    expect(
      repository.chordsByGenre('Jazz').length,
      greaterThan(repository.chordsByGenre('Punk').length),
    );
    expect(repository.essentialFirst(repository.chords).first.id, 'C-maj');
  });
}
