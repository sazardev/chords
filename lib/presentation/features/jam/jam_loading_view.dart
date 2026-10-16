import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Pantalla de preparación de la banda: barra de progreso mientras se
/// sintetizan y cargan los instrumentos.
class JamLoadingView extends StatelessWidget {
  /// Crea la vista con el avance [progress] (0-1).
  const JamLoadingView({required this.progress, super.key});

  /// Avance de la preparación.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final int percent = (progress * 100).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppCard(
          color: scheme.secondaryContainer,
          child: Semantics(
            liveRegion: true,
            label: '${t.jamBand.loading} ${t.jamBand.loadingBody(n: percent)}',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppText(
                  t.jamBand.loading,
                  variant: AppTextVariant.titleLarge,
                  color: scheme.onSecondaryContainer,
                  align: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 12),
                AppText(
                  t.jamBand.loadingBody(n: percent),
                  color: scheme.onSecondaryContainer,
                ),
                const SizedBox(height: 8),
                AppText(
                  t.jamBand.loadingTip,
                  variant: AppTextVariant.labelMedium,
                  color: scheme.onSecondaryContainer,
                  align: TextAlign.center,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
