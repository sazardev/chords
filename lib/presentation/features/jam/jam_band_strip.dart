import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_mode.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_activity.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/l10n/band_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Tira de instrumentos de la escena: cada uno se enciende al sonar y se
/// silencia o activa al tocarlo, sin parar la sesión.
class JamBandStrip extends StatelessWidget {
  /// Crea la tira.
  const JamBandStrip({
    required this.activity,
    required this.settings,
    super.key,
  });

  /// Qué instrumentos suenan en cada pulso.
  final BandActivity activity;

  /// Ajustes (mezclador) de la banda.
  final BandSettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[activity, settings]),
      builder: (BuildContext context, _) {
        final BandConfig config = settings.config;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppText(t.jamBand.activity, variant: AppTextVariant.labelLarge),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: <Widget>[
                for (final BandChannel channel in <BandChannel>[
                  ...kBandChannels,
                  BandChannel.click,
                ])
                  _ChannelChip(
                    channel: channel,
                    enabled: config.isOn(channel),
                    lit: activity.isActive(channel),
                    onTap: () => settings.toggleChannel(channel),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            AppText(
              t.jamBand.activityTip,
              variant: AppTextVariant.labelMedium,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              maxLines: 2,
            ),
          ],
        );
      },
    );
  }
}

class _ChannelChip extends StatelessWidget {
  const _ChannelChip({
    required this.channel,
    required this.enabled,
    required this.lit,
    required this.onTap,
  });

  final BandChannel channel;
  final bool enabled;
  final bool lit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String name = bandChannelName(t, channel);
    final Color background = !enabled
        ? scheme.surfaceContainerHighest
        : (lit ? scheme.primary : scheme.primaryContainer);
    final Color ink = !enabled
        ? scheme.onSurfaceVariant
        : (lit ? scheme.onPrimary : scheme.onPrimaryContainer);
    return Semantics(
      button: true,
      toggled: enabled,
      label: enabled
          ? t.jamBand.channelOn(name: name)
          : t.jamBand.channelOff(name: name),
      excludeSemantics: true,
      onTap: onTap,
      child: Tooltip(
        message: enabled
            ? t.jamBand.muteChannel(name: name)
            : t.jamBand.unmuteChannel(name: name),
        child: InkWell(
          key: ValueKey<String>('strip-${channel.name}'),
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 110),
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  enabled ? bandChannelIcon(channel) : Icons.volume_off_rounded,
                  size: 20,
                  color: ink,
                ),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: TextStyle(
                    color: ink,
                    fontWeight: FontWeight.w700,
                    decoration: enabled ? null : TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
