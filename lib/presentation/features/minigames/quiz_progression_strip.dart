import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Los acordes de una progresión en una fila de fichas; la que falta se
/// marca con `?`.
class QuizProgressionStrip extends StatelessWidget {
  /// Crea la tira con los acordes [bars] (`?` es el que falta).
  const QuizProgressionStrip({required this.bars, super.key});

  /// Texto de cada acorde, en orden.
  final List<String> bars;

  /// Marca del acorde oculto.
  static const String hidden = '?';

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final String bar in bars)
          DecoratedBox(
            decoration: BoxDecoration(
              color: bar == hidden
                  ? scheme.tertiaryContainer
                  : scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Center(
                  widthFactor: 1,
                  child: AppText(
                    bar,
                    variant: AppTextVariant.titleMedium,
                    color: bar == hidden
                        ? scheme.onTertiaryContainer
                        : scheme.onSecondaryContainer,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
