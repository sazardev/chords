import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_listen_state.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Estado de la escucha: oye, espera el silencio o está lista.
///
/// Con [headline] la primera línea es ese texto (p. ej. el juego elegido) y el
/// estado pasa a la segunda; [trailing] se coloca al final de la fila.
class GuitarStatusLine extends StatelessWidget {
  /// Crea la línea sobre el estado de [listener].
  const GuitarStatusLine({
    required this.listener,
    super.key,
    this.headline,
    this.trailing,
    this.readyText,
  });

  /// Oyente de la guitarra que da el estado.
  final GuitarCommandListener listener;

  /// Texto de contexto que ocupa la primera línea; `null` si no hay.
  final String? headline;

  /// Widget al final de la fila.
  final Widget? trailing;

  /// Texto cuando la guitarra está lista; por defecto «toca una cuerda».
  final String? readyText;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final GuitarListenState state = listener.state;
    final String status = !state.hearing
        ? t.guitar.noMic
        : (state.armed ? (readyText ?? t.guitar.ready) : t.guitar.waiting);
    final Color tint = state.ready ? scheme.primary : scheme.onSurfaceVariant;
    final String? title = headline;
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: kMotionFast,
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: state.ready
                ? scheme.primary.withValues(
                    alpha: 0.18 + 0.5 * state.level.clamp(0.0, 1.0),
                  )
                : scheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            state.hearing ? Icons.mic_rounded : Icons.mic_off_rounded,
            size: 18,
            color: tint,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppText(
                title ?? status,
                variant: AppTextVariant.labelLarge,
                weight: title == null ? null : FontWeight.w700,
                color: title == null ? tint : scheme.onSurface,
                maxLines: 2,
              ),
              if (title != null)
                AppText(
                  status,
                  variant: AppTextVariant.labelMedium,
                  color: tint,
                  maxLines: 2,
                ),
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}
