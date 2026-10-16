import 'package:chords/domain/audio/services/chord_template.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';

/// Plantillas de todos los acordes posibles: 12 raíces × cada calidad.
///
/// Itera por [ChordQuality.values], así que una calidad nueva en el banco
/// entra sola en el reconocimiento.
class ChordTemplateBank {
  /// Crea el banco completo.
  ChordTemplateBank()
    : templates = List<ChordTemplate>.unmodifiable(<ChordTemplate>[
        for (final ChordQuality quality in ChordQuality.values)
          for (final ChordRoot root in ChordRoot.values)
            ChordTemplate(root, quality),
      ]);

  /// Todas las plantillas.
  final List<ChordTemplate> templates;

  /// Número de plantillas.
  int get length => templates.length;
}
