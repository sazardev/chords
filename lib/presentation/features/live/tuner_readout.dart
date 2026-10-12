import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_level_bar.dart';
import 'package:flutter/material.dart';

/// Instrucción bajo el dial: qué hacer con la clavija o qué tocar.
///
/// Mantiene una altura mínima para que la pantalla no salte al cambiar de
/// estado.
class TunerReadout extends StatelessWidget {
  /// Crea la zona de instrucción.
  const TunerReadout({
    required this.state,
    required this.onActivate,
    super.key,
  });

  /// Estado del afinador.
  final TunerState state;

  /// Acción para activar el micrófono cuando está en reposo.
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 120),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: KeyedSubtree(key: ValueKey<String>(_keyOf()), child: _content()),
    ),
  );

  String _keyOf() {
    final StringTuningReading? reading = state.reading;
    if (reading != null) {
      return 'reading-${reading.zone.name}-${reading.direction.name}';
    }
    if (state.allTuned) {
      return 'done';
    }
    if (!state.isListening) {
      return 'idle';
    }
    return state.heardOther != null ? 'other' : 'prompt';
  }

  Widget _content() {
    final StringTuningReading? reading = state.reading;
    if (reading != null) {
      return _Instruction(reading: reading);
    }
    if (state.allTuned) {
      return const _AllTuned();
    }
    if (!state.isListening) {
      return _Activate(onActivate: onActivate);
    }
    return _Prompt(state: state);
  }
}

/// Titular grande con flecha y la acción sobre la clavija.
class _Instruction extends StatelessWidget {
  const _Instruction({required this.reading});

  final StringTuningReading reading;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AppChordColors colors = chordColorsOf(context);
    final ({String headline, String? action}) message = tuningMessage(
      t,
      reading,
    );
    final Color tone = switch (reading.zone) {
      TuningZone.inTune => colors.inTune,
      TuningZone.near => colors.nearTune,
      TuningZone.off || TuningZone.far => colors.outOfTune,
    };
    final IconData icon = switch (reading.direction) {
      TuneDirection.up => Icons.arrow_upward_rounded,
      TuneDirection.down => Icons.arrow_downward_rounded,
      TuneDirection.none => Icons.check_circle_rounded,
    };
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: tone, size: 40),
            const SizedBox(width: 8),
            Flexible(
              child: AppText(
                message.headline,
                variant: AppTextVariant.headlineMedium,
                color: tone,
                weight: FontWeight.w800,
              ),
            ),
          ],
        ),
        if (message.action != null)
          AppText(
            message.action!,
            color: scheme.onSurfaceVariant,
            align: TextAlign.center,
          ),
      ],
    );
  }
}

/// Qué hacer cuando aún no suena nada reconocible.
class _Prompt extends StatelessWidget {
  const _Prompt({required this.state});

  final TunerState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final GuitarString? target = state.target;
    final GuitarString? other = state.heardOther;
    final String prompt = target == null
        ? t.tuner.pluckPrompt
        : t.tuner.pluckString(string: stringShort(t, target.number));
    return Column(
      children: <Widget>[
        AppText(
          prompt,
          variant: AppTextVariant.titleLarge,
          align: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        if (other != null && target != null) ...<Widget>[
          const SizedBox(height: 4),
          AppText(
            t.tuner.heardOther(
              heard: stringShort(t, other.number),
              target: stringShort(t, target.number),
            ),
            color: scheme.error,
            align: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
        ],
        const SizedBox(height: 16),
        MicLevelBar(level: state.level),
      ],
    );
  }
}

/// Las seis cuerdas afinadas.
class _AllTuned extends StatelessWidget {
  const _AllTuned();

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final AppChordColors colors = chordColorsOf(context);
    return Column(
      children: <Widget>[
        Icon(Icons.celebration_rounded, size: 44, color: colors.inTune),
        AppText(
          t.tuner.allTunedTitle,
          variant: AppTextVariant.headlineMedium,
          color: colors.inTune,
          weight: FontWeight.w800,
          align: TextAlign.center,
        ),
        AppText(
          t.tuner.allTunedMessage,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          align: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}

/// Micrófono en reposo: único botón de la pantalla.
class _Activate extends StatelessWidget {
  const _Activate({required this.onActivate});

  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) => Center(
    child: FilledButton.icon(
      onPressed: onActivate,
      icon: const Icon(Icons.mic_rounded),
      label: Text(context.t.tuner.activate),
    ),
  );
}
