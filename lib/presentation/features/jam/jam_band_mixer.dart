import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/channel_mix.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/l10n/band_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Mezclador de la banda: una fila por canal con su interruptor y su
/// volumen.
class JamBandMixer extends StatelessWidget {
  /// Crea el mezclador.
  const JamBandMixer({required this.settings, super.key});

  /// Ajustes de la banda.
  final BandSettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final BandConfig config = settings.config;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppText(t.jamBand.mixer, variant: AppTextVariant.labelLarge),
        for (final BandChannel channel in BandChannel.values)
          MixerRow(
            channel: channel,
            mix: config.mixOf(channel),
            onToggle: () => settings.toggleChannel(channel),
            onVolume: (double v) => settings.setVolume(channel, v),
          ),
      ],
    );
  }
}

/// Fila del mezclador: botón de silencio, nombre, volumen y porcentaje.
class MixerRow extends StatelessWidget {
  /// Crea la fila.
  const MixerRow({
    required this.channel,
    required this.mix,
    required this.onToggle,
    required this.onVolume,
    super.key,
  });

  /// Canal que regula.
  final BandChannel channel;

  /// Su ajuste actual.
  final ChannelMix mix;

  /// Se llama al pulsar el botón de silencio.
  final VoidCallback onToggle;

  /// Se llama al mover el volumen.
  final ValueChanged<double> onVolume;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final String name = bandChannelName(t, channel);
    final String action = mix.enabled
        ? t.jamBand.muteChannel(name: name)
        : t.jamBand.unmuteChannel(name: name);
    final int percent = (mix.volume * 100).round();
    return Row(
      children: <Widget>[
        Semantics(
          label: mix.enabled
              ? t.jamBand.channelOn(name: name)
              : t.jamBand.channelOff(name: name),
          child: IconButton.filledTonal(
            key: ValueKey<String>('mute-${channel.name}'),
            tooltip: action,
            isSelected: mix.enabled,
            icon: Icon(
              mix.enabled ? bandChannelIcon(channel) : Icons.volume_off_rounded,
            ),
            onPressed: onToggle,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppText(
                name,
                variant: AppTextVariant.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 28,
                child: Slider(
                  key: ValueKey<String>('volume-${channel.name}'),
                  value: mix.volume,
                  label: '$percent%',
                  semanticFormatterCallback: (double v) =>
                      '${t.jamBand.channelVolume(name: name)} '
                      '${(v * 100).round()}%',
                  onChanged: mix.enabled ? onVolume : null,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 44,
          child: AppText(
            '$percent%',
            variant: AppTextVariant.labelMedium,
            align: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
