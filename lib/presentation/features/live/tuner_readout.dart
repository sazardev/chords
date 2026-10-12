import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_level_bar.dart';
import 'package:chords/presentation/widgets/organisms/tuning_meter.dart';
import 'package:flutter/material.dart';

/// Zona central del afinador: qué cuerda suena y qué hacer con la clavija.
///
/// Mantiene una altura mínima para que la pantalla no salte al aparecer o
/// desaparecer la lectura.
class TunerReadout extends StatelessWidget {
  /// Crea la zona de lectura.
  const TunerReadout({required this.state, super.key});

  /// Estado del afinador.
  final TunerState state;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 215),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: KeyedSubtree(
        key: ValueKey<String>(_keyOf()),
        child: _content(context),
      ),
    ),
  );

  String _keyOf() {
    if (state.allTuned) {
      return 'done';
    }
    final StringTuningReading? reading = state.reading;
    if (reading != null) {
      return 'reading';
    }
    return state.heardOther != null ? 'other' : 'prompt';
  }

  Widget _content(BuildContext context) {
    if (state.allTuned) {
      return const _AllTunedCard();
    }
    final StringTuningReading? reading = state.reading;
    if (reading != null) {
      return _ReadingPanel(reading: reading);
    }
    return _PromptPanel(state: state);
  }
}

/// Lectura activa: nota, cuerda, instrucción y medidor.
class _ReadingPanel extends StatelessWidget {
  const _ReadingPanel({required this.reading});

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
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(
              openNoteName(t, reading.string),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: tone,
                fontWeight: FontWeight.w800,
                fontSize: 72,
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            AppText(
              '${reading.frequency.toStringAsFixed(1)} Hz',
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
        AppText(
          stringTitle(t, reading.string),
          variant: AppTextVariant.titleMedium,
          color: scheme.onSurfaceVariant,
        ),
        const SizedBox(height: 12),
        TuningMeter(reading: reading),
        const SizedBox(height: 12),
        _Instruction(
          headline: message.headline,
          action: message.action,
          direction: reading.direction,
          tone: tone,
        ),
      ],
    );
  }
}

/// Titular grande con flecha y la acción sobre la clavija.
class _Instruction extends StatelessWidget {
  const _Instruction({
    required this.headline,
    required this.action,
    required this.direction,
    required this.tone,
  });

  final String headline;
  final String? action;
  final TuneDirection direction;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final IconData icon = switch (direction) {
      TuneDirection.up => Icons.arrow_upward_rounded,
      TuneDirection.down => Icons.arrow_downward_rounded,
      TuneDirection.none => Icons.check_circle_rounded,
    };
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: tone, size: 34),
            const SizedBox(width: 8),
            Flexible(
              child: AppText(
                headline,
                variant: AppTextVariant.headlineMedium,
                color: tone,
                weight: FontWeight.w800,
              ),
            ),
          ],
        ),
        if (action != null)
          AppText(
            action!,
            color: scheme.onSurfaceVariant,
            align: TextAlign.center,
          ),
      ],
    );
  }
}

/// Qué hacer cuando aún no suena nada reconocible.
class _PromptPanel extends StatelessWidget {
  const _PromptPanel({required this.state});

  final TunerState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final GuitarString? target = state.target;
    final GuitarString? other = state.heardOther;
    final String prompt = state.isListening
        ? (target == null
              ? t.tuner.pluckPrompt
              : t.tuner.pluckString(string: stringShort(t, target.number)))
        : t.tuner.autoHint;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 28),
        Icon(
          state.isListening ? Icons.graphic_eq_rounded : Icons.mic_none_rounded,
          size: 44,
          color: scheme.primary,
        ),
        const SizedBox(height: 12),
        AppText(
          prompt,
          variant: AppTextVariant.titleLarge,
          align: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        if (other != null && target != null) ...<Widget>[
          const SizedBox(height: 8),
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
        const SizedBox(height: 20),
        if (state.isListening) MicLevelBar(level: state.level),
      ],
    );
  }
}

/// Celebración al tener las seis cuerdas afinadas.
class _AllTunedCard extends StatelessWidget {
  const _AllTunedCard();

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.primaryContainer,
      child: Column(
        children: <Widget>[
          Icon(
            Icons.celebration_rounded,
            size: 48,
            color: scheme.onPrimaryContainer,
          ),
          const SizedBox(height: 8),
          AppText(
            t.tuner.allTunedTitle,
            variant: AppTextVariant.headlineMedium,
            color: scheme.onPrimaryContainer,
            weight: FontWeight.w800,
            align: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AppText(
            t.tuner.allTunedMessage,
            color: scheme.onPrimaryContainer,
            align: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }
}
