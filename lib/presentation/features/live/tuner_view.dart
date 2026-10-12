import 'dart:async' show unawaited;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/features/live/tuner_readout.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:chords/presentation/widgets/organisms/guitar_headstock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Afinador por cuerdas: cabezal, lectura guiada y controles.
///
/// Lo usa la pestaña de afinación y la hoja "Reafinar" del modo práctica,
/// por eso no lleva `Scaffold` propio.
class TunerView extends StatelessWidget {
  /// Crea el afinador. Con [showToggle] falso el botón de empezar/detener
  /// se omite (la pantalla lo fija en otro sitio con [TunerToggleButton]).
  const TunerView({super.key, this.showToggle = true});

  /// Si se muestra el botón de empezar/detener dentro del afinador.
  final bool showToggle;

  @override
  Widget build(BuildContext context) {
    final TunerController controller = context.watch<TunerController>();
    final TunerState state = controller.state;
    return Column(
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
          onSelect: controller.selectString,
          height: 220,
        ),
        const SizedBox(height: 4),
        AppText(
          context.t.tuner.selectHint,
          variant: AppTextVariant.labelMedium,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          align: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        const SizedBox(height: 12),
        TunerReadout(state: state),
        const SizedBox(height: 12),
        if (showToggle) ...<Widget>[
          const TunerToggleButton(),
          const SizedBox(height: 8),
        ],
        _Controls(controller: controller),
        const SizedBox(height: 16),
        _Progress(state: state),
      ],
    );
  }
}

/// Barra de progreso: cuántas cuerdas llevas afinadas.
class _Progress extends StatelessWidget {
  const _Progress({required this.state});

  final TunerState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: state.tuned.length / kStandardTuning.length,
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 6),
        AppText(
          t.tuner.progress(count: state.tuned.length),
          variant: AppTextVariant.labelMedium,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

/// Botón principal: empezar o detener la escucha del afinador.
class TunerToggleButton extends StatelessWidget {
  /// Crea el botón.
  const TunerToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final TunerController controller = context.watch<TunerController>();
    final bool listening = controller.state.isListening;
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: controller.toggleListening,
        icon: Icon(listening ? Icons.stop_rounded : Icons.mic_rounded),
        label: Text(listening ? t.tuner.stop : t.tuner.start),
      ),
    );
  }
}

/// Opciones: modo automático, nota de referencia y reinicio.
class _Controls extends StatelessWidget {
  const _Controls({required this.controller});

  final TunerController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final TunerState state = controller.state;
    final GuitarString? known = state.target ?? state.reading?.string;
    return Column(
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: <Widget>[
            FilterChip(
              avatar: const Icon(Icons.auto_awesome_rounded, size: 18),
              label: Text(t.tuner.auto),
              selected: state.target == null,
              onSelected: (_) => controller.selectString(state.target),
            ),
            ActionChip(
              avatar: const Icon(Icons.volume_up_rounded, size: 18),
              label: Text(t.tuner.playReference),
              onPressed: known == null
                  ? null
                  : () => unawaited(controller.playReference(known)),
            ),
            if (state.tuned.isNotEmpty)
              ActionChip(
                avatar: const Icon(Icons.restart_alt_rounded, size: 18),
                label: Text(t.tuner.startOver),
                onPressed: controller.resetProgress,
              ),
          ],
        ),
      ],
    );
  }
}
