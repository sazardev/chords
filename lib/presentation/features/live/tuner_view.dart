import 'dart:async' show unawaited;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/features/live/tuner_readout.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:chords/presentation/widgets/organisms/guitar_headstock.dart';
import 'package:chords/presentation/widgets/organisms/tuner_dial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Afinador automático: cabezal, dial y una instrucción clara.
///
/// No tiene botones de control: escucha solo, reconoce la cuerda, y el fondo
/// se tiñe de verde cuando está afinada. Tocar una clavija la fija y suena su
/// nota; tocarla otra vez vuelve al modo automático. Lo usan la pestaña de
/// afinación y la hoja "Reafinar" del modo práctica, por eso no lleva
/// `Scaffold` propio.
class TunerView extends StatelessWidget {
  /// Crea el afinador. [minHeight] hace que el fondo teñido llene la pantalla.
  const TunerView({super.key, this.minHeight = 0});

  /// Alto mínimo del contenido.
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final TunerController controller = context.watch<TunerController>();
    final TunerState state = controller.state;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: <Widget>[
            if (MicProblemCard.isProblem(state.status)) ...<Widget>[
              MicProblemCard(
                status: state.status,
                onRetry: () => unawaited(controller.start()),
              ),
              const SizedBox(height: 12),
            ],
            GuitarHeadstock(
              tuned: state.tuned,
              active: state.reading?.string.number,
              zone: state.reading?.zone,
              target: state.target?.number,
              onSelect: (GuitarString string) =>
                  unawaited(controller.tapString(string)),
              height: 212,
            ),
            const SizedBox(height: 6),
            _ModeLabel(controller: controller),
            const SizedBox(height: 20),
            _Dial(state: state),
            const SizedBox(height: 16),
            TunerReadout(
              state: state,
              onActivate: () => unawaited(controller.start()),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dial con la nota de la cuerda reconocida o fijada.
class _Dial extends StatelessWidget {
  const _Dial({required this.state});

  final TunerState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final StringTuningReading? reading = state.reading;
    final GuitarString? string = reading?.string ?? state.target;
    return TunerDial(
      reading: reading,
      note: string == null ? '–' : openNoteName(t, string),
      caption: reading != null
          ? '${stringShort(t, reading.string.number)} · '
                '${reading.frequency.toStringAsFixed(1)} Hz'
          : (string == null ? null : stringTitle(t, string)),
    );
  }
}

/// Indica si el afinador está en automático o con una cuerda fijada.
class _ModeLabel extends StatelessWidget {
  const _ModeLabel({required this.controller});

  final TunerController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final GuitarString? target = controller.state.target;
    if (target == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: AppText(
          t.tuner.modeAuto,
          variant: AppTextVariant.labelMedium,
          color: scheme.onSurfaceVariant,
          align: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
      );
    }
    return TextButton.icon(
      onPressed: () => controller.selectString(target),
      icon: const Icon(Icons.close_rounded, size: 18),
      label: Text(t.tuner.modeManual(string: stringShort(t, target.number))),
    );
  }
}
