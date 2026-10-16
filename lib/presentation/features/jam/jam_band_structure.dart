import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/l10n/band_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Estructura de la sesión: cuenta atrás, vueltas y transposición.
class JamBandStructure extends StatelessWidget {
  /// Crea la sección.
  const JamBandStructure({required this.settings, super.key});

  /// Ajustes de la banda.
  final BandSettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final BandConfig config = settings.config;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppText(t.jamBand.countInLabel, variant: AppTextVariant.labelLarge),
        const SizedBox(height: 6),
        SegmentedButton<int>(
          showSelectedIcon: false,
          segments: <ButtonSegment<int>>[
            for (int bars = 0; bars <= 2; bars++)
              ButtonSegment<int>(
                value: bars,
                label: Text(countInName(t, bars)),
              ),
          ],
          selected: <int>{config.countInBars},
          onSelectionChanged: (Set<int> s) =>
              settings.set(config.copyWith(countInBars: s.first)),
        ),
        const SizedBox(height: 8),
        StepperRow(
          label: t.jamBand.loops(n: config.loops),
          lessTip: t.jamBand.loopsLess,
          moreTip: t.jamBand.loopsMore,
          onLess: config.loops > 1
              ? () => settings.set(config.copyWith(loops: config.loops - 1))
              : null,
          onMore: config.loops < 8
              ? () => settings.set(config.copyWith(loops: config.loops + 1))
              : null,
        ),
        StepperRow(
          label: t.jamBand.transpose(n: signedSemitones(config.transpose)),
          lessTip: t.jamBand.transposeLess,
          moreTip: t.jamBand.transposeMore,
          onLess: config.transpose > -6
              ? () => settings.set(
                  config.copyWith(transpose: config.transpose - 1),
                )
              : null,
          onMore: config.transpose < 6
              ? () => settings.set(
                  config.copyWith(transpose: config.transpose + 1),
                )
              : null,
        ),
      ],
    );
  }
}

/// Etiqueta con un botón de menos y otro de más.
class StepperRow extends StatelessWidget {
  /// Crea el selector.
  const StepperRow({
    required this.label,
    required this.lessTip,
    required this.moreTip,
    required this.onLess,
    required this.onMore,
    super.key,
  });

  /// Texto con el valor actual.
  final String label;

  /// Ayuda del botón de menos.
  final String lessTip;

  /// Ayuda del botón de más.
  final String moreTip;

  /// Acción de menos (`null` si está en el mínimo).
  final VoidCallback? onLess;

  /// Acción de más (`null` si está en el máximo).
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Expanded(
        child: AppText(label, variant: AppTextVariant.labelLarge, maxLines: 2),
      ),
      IconButton.filledTonal(
        tooltip: lessTip,
        icon: const Icon(Icons.remove_rounded),
        onPressed: onLess,
      ),
      const SizedBox(width: 4),
      IconButton.filledTonal(
        tooltip: moreTip,
        icon: const Icon(Icons.add_rounded),
        onPressed: onMore,
      ),
    ],
  );
}
