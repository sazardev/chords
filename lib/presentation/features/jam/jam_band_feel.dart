import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/l10n/band_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Sensación de la banda: swing, humanización, intensidad y rellenos.
class JamBandFeel extends StatelessWidget {
  /// Crea la sección.
  const JamBandFeel({required this.settings, super.key});

  /// Ajustes de la banda.
  final BandSettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final BandConfig config = settings.config;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ..._swing(t, config),
        ..._humanize(context, t, config),
        const SizedBox(height: 12),
        AppText(t.jamBand.intensity, variant: AppTextVariant.labelLarge),
        const SizedBox(height: 6),
        SegmentedButton<BandIntensity>(
          showSelectedIcon: false,
          segments: <ButtonSegment<BandIntensity>>[
            for (final BandIntensity level in BandIntensity.values)
              ButtonSegment<BandIntensity>(
                value: level,
                label: Text(bandIntensityName(t, level)),
              ),
          ],
          selected: <BandIntensity>{config.intensity},
          onSelectionChanged: (Set<BandIntensity> s) =>
              settings.set(config.copyWith(intensity: s.first)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(t.jamBand.fills),
          value: config.fills,
          onChanged: (bool on) => settings.set(config.copyWith(fills: on)),
        ),
      ],
    );
  }

  /// Interruptor de swing automático y, si no lo es, su control.
  List<Widget> _swing(Translations t, BandConfig config) {
    final int swing = ((config.swing ?? 0) * 100).round();
    return <Widget>[
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(t.jamBand.swingAuto),
        value: config.swing == null,
        onChanged: (bool on) =>
            settings.set(config.copyWith(swing: (value: on ? null : 0.5))),
      ),
      if (config.swing != null) ...<Widget>[
        AppText(t.jamBand.swing(n: swing), variant: AppTextVariant.labelLarge),
        Slider(
          key: const ValueKey<String>('swing'),
          value: config.swing!,
          divisions: 20,
          label: '$swing%',
          onChanged: (double v) =>
              settings.set(config.copyWith(swing: (value: v))),
        ),
      ],
    ];
  }

  /// Humanización con su explicación.
  List<Widget> _humanize(BuildContext context, Translations t, BandConfig c) {
    final int humanize = (c.humanize * 100).round();
    return <Widget>[
      AppText(
        t.jamBand.humanize(n: humanize),
        variant: AppTextVariant.labelLarge,
      ),
      Slider(
        key: const ValueKey<String>('humanize'),
        value: c.humanize,
        divisions: 20,
        label: '$humanize%',
        onChanged: (double v) => settings.set(c.copyWith(humanize: v)),
      ),
      AppText(
        t.jamBand.humanizeHint,
        variant: AppTextVariant.labelMedium,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        maxLines: 3,
      ),
    ];
  }
}
