import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_mode.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/features/jam/jam_band_feel.dart';
import 'package:chords/presentation/features/jam/jam_band_mixer.dart';
import 'package:chords/presentation/features/jam/jam_band_structure.dart';
import 'package:chords/presentation/features/jam/jam_band_voices.dart';
import 'package:chords/presentation/l10n/band_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Panel "Banda" de la preparación del jam: atajos de mezcla, mezclador por
/// instrumento, estilo y tipo de cada instrumento, sensación y estructura.
class JamBandPanel extends StatelessWidget {
  /// Crea el panel; [scoreMode] avisa de que en "puntuar" la banda calla.
  const JamBandPanel({required this.scoreMode, super.key});

  /// `true` si la sesión es de puntuar (la banda no suena).
  final bool scoreMode;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final BandSettingsController settings = context
        .watch<BandSettingsController>();
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _Header(onReset: settings.reset),
          AppText(
            t.jamBand.subtitle,
            color: scheme.onSurfaceVariant,
            maxLines: 2,
          ),
          if (scoreMode) ...<Widget>[
            const SizedBox(height: 6),
            AppText(
              t.jamBand.scoreSilent,
              variant: AppTextVariant.labelMedium,
              color: scheme.tertiary,
              maxLines: 4,
            ),
          ],
          const SizedBox(height: 12),
          _QuickModes(settings: settings),
          const SizedBox(height: 12),
          JamBandMixer(settings: settings),
          _Section(
            title: t.jamBand.instruments,
            child: JamBandVoices(settings: settings),
          ),
          _Section(
            title: t.jamBand.feel,
            child: JamBandFeel(settings: settings),
          ),
          _Section(
            title: t.jamBand.structure,
            child: JamBandStructure(settings: settings),
          ),
        ],
      ),
    );
  }
}

/// Título del panel con el botón de valores de fábrica.
class _Header extends StatelessWidget {
  const _Header({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Row(
      children: <Widget>[
        const Icon(Icons.queue_music_rounded),
        const SizedBox(width: 8),
        Expanded(
          child: AppText(t.jamBand.title, variant: AppTextVariant.titleMedium),
        ),
        IconButton(
          tooltip: t.jamBand.reset,
          icon: const Icon(Icons.restart_alt_rounded),
          onPressed: onReset,
        ),
      ],
    );
  }
}

/// Botones de modo: banda completa, solo ritmo, sin guitarra y solo clic.
class _QuickModes extends StatelessWidget {
  const _QuickModes({required this.settings});

  final BandSettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final BandConfig config = settings.config;
    final BandMode? active = bandModeOf(config);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText(t.jamBand.modeHint, variant: AppTextVariant.labelLarge),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: <Widget>[
            for (final BandMode mode in BandMode.values)
              ChoiceChip(
                key: ValueKey<String>('mode-${mode.name}'),
                label: Text(bandModeName(t, mode)),
                selected: active == mode,
                onSelected: (_) => settings.applyMode(mode),
              ),
          ],
        ),
        if (active == BandMode.rhythm) ...<Widget>[
          const SizedBox(height: 4),
          AppText(
            t.jamBand.rhythmTip,
            variant: AppTextVariant.labelMedium,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            maxLines: 3,
          ),
        ],
      ],
    );
  }
}

/// Sección plegable del panel.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => ExpansionTile(
    tilePadding: EdgeInsets.zero,
    shape: const Border(),
    collapsedShape: const Border(),
    title: Text(title),
    childrenPadding: const EdgeInsets.only(bottom: 12),
    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[child],
  );
}
