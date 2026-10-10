import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Lectura grande del tono detectado con medidor de cents.
class LivePitchReadout extends StatelessWidget {
  /// Crea la lectura en vivo.
  const LivePitchReadout({required this.status, super.key, this.reading});

  /// Estado del micrófono.
  final MicStatus status;

  /// Última lectura de tono.
  final PitchReading? reading;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final AppChordColors colors = chordColorsOf(context);
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String note = reading?.note ?? '—';
    final double cents = reading?.cents ?? 0;
    final bool inTune = cents.abs() < 5;
    final Color meterColor = reading == null
        ? scheme.outline
        : (inTune ? colors.inTune : colors.outOfTune);

    return Column(
      children: <Widget>[
        AppText(
          status == MicStatus.listening
              ? t.live.listening
              : _statusLabel(t, status),
          variant: AppTextVariant.labelLarge,
          color: scheme.onSurfaceVariant,
        ),
        const SizedBox(height: 8),
        Text(
          note,
          style: Theme.of(context).textTheme.displayLarge
              ?.copyWith(color: meterColor, fontSize: 72),
        ),
        const SizedBox(height: 4),
        AppText(
          reading == null
              ? t.live.idleMessage
              : '${reading!.frequency.toStringAsFixed(1)} Hz · '
                    '${cents.toStringAsFixed(0)} cents',
          color: scheme.onSurfaceVariant,
        ),
        const SizedBox(height: 12),
        _CentsMeter(cents: cents, color: meterColor),
      ],
    );
  }

  String _statusLabel(Translations t, MicStatus status) => switch (status) {
    MicStatus.idle => t.live.idleTitle,
    MicStatus.listening => t.live.listening,
    MicStatus.permissionDenied => t.live.deniedTitle,
    MicStatus.error => t.live.errorTitle,
  };
}

/// Medidor lineal de desviación en cents (-50..50).
class _CentsMeter extends StatelessWidget {
  const _CentsMeter({required this.cents, required this.color});

  final double cents;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double value = (cents / 50).clamp(-1.0, 1.0);
    return SizedBox(
      height: 14,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Align(
            alignment: Alignment(value, 0),
            child: Container(
              width: 6,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
