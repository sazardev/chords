import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guardián del diseño plano: prohíbe degradados, sombras, bordes y
/// elevaciones en la capa de presentación.
void main() {
  test('la UI no usa degradados, sombras ni bordes', () {
    final List<File> files = Directory('lib/presentation')
        .listSync(recursive: true)
        .whereType<File>()
        .where((File file) => file.path.endsWith('.dart'))
        .toList();
    expect(files, isNotEmpty, reason: 'no se encontró la capa de presentación');

    final Map<String, List<String>> offenders = <String, List<String>>{};

    for (final File file in files) {
      final List<String> lines = file.readAsLinesSync();
      for (int i = 0; i < lines.length; i++) {
        final String line = lines[i];
        for (final String pattern in <String>[
          'LinearGradient',
          'RadialGradient',
          'SweepGradient',
          'BoxShadow',
          'BoxBorder',
          'Border.all(',
          'elevation: 1',
          'elevation: 2',
          'elevation: 3',
          'elevation: 4',
          'elevation: 5',
          'elevation: 6',
          'elevation: 7',
          'elevation: 8',
          'elevation: 9',
        ]) {
          if (line.contains(pattern)) {
            offenders
                .putIfAbsent(pattern, () => <String>[])
                .add('${file.path}:${i + 1}');
          }
        }
      }
    }

    final List<String> details = offenders.entries
        .map(
          (MapEntry<String, List<String>> entry) =>
              '${entry.key} en ${entry.value}',
        )
        .toList();
    expect(offenders, isEmpty, reason: 'el diseño plano prohíbe: $details');
  });
}
