import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_listen_state.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Tarjeta de una acción: la nota que la activa y qué hace.
///
/// En su forma normal es una fila (nota, etiqueta y cuerda); en la compacta
/// apila la nota sobre la etiqueta para que quepan cuatro en una sola fila.
class GuitarKeyCard extends StatelessWidget {
  /// Crea la tarjeta de [action] sobre el estado de [listener].
  const GuitarKeyCard({
    required this.action,
    required this.listener,
    this.compact = false,
    super.key,
  });

  /// Acción que representa.
  final GuitarAction action;

  /// Oyente que dice si la guitarra está lista y qué se tocó último.
  final GuitarCommandListener listener;

  /// Si se dibuja apilada y sin la pista de la cuerda.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final GuitarListenState state = listener.state;
    final bool lit = !listener.enabled || state.armed;
    final bool fired = state.lastFired == action.command;
    final (Color background, Color ink) = _colors(scheme, lit: lit);
    final String hint = t.guitar.openString(
      string: stringShort(t, action.command.stringNumber),
    );
    return Semantics(
      button: true,
      label: '${action.label}. $hint',
      child: ExcludeSemantics(
        child: AnimatedScale(
          scale: fired ? 1.05 : 1,
          duration: kMotionFast,
          curve: kSpringCurve,
          child: AnimatedContainer(
            duration: kMotionMedium,
            curve: kStandardCurve,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => listener.trigger(action.command),
                child: Padding(
                  padding: EdgeInsets.all(compact ? 8 : 10),
                  child: compact
                      ? _CompactContent(
                          action: action,
                          showNote: listener.enabled,
                          ink: ink,
                          fill: scheme.surface.withValues(alpha: 0.28),
                        )
                      : _RowContent(
                          action: action,
                          showNote: listener.enabled,
                          hint: hint,
                          ink: ink,
                          fill: scheme.surface.withValues(alpha: 0.28),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  (Color, Color) _colors(ColorScheme scheme, {required bool lit}) {
    if (!lit) {
      return (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant.withValues(alpha: 0.7),
      );
    }
    return action.emphasized
        ? (scheme.primary, scheme.onPrimary)
        : (scheme.secondaryContainer, scheme.onSecondaryContainer);
  }
}

/// Interior normal: la nota, lo que hace y qué cuerda tocar.
class _RowContent extends StatelessWidget {
  const _RowContent({
    required this.action,
    required this.showNote,
    required this.hint,
    required this.ink,
    required this.fill,
  });

  final GuitarAction action;
  final bool showNote;
  final String hint;
  final Color ink;
  final Color fill;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      _NoteBadge(
        command: action.command,
        icon: action.icon,
        showNote: showNote,
        ink: ink,
        fill: fill,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppText(
              action.label,
              variant: AppTextVariant.titleMedium,
              weight: FontWeight.w700,
              color: ink,
              maxLines: 2,
            ),
            if (showNote)
              AppText(
                hint,
                variant: AppTextVariant.labelMedium,
                color: ink.withValues(alpha: 0.8),
                maxLines: 1,
              ),
          ],
        ),
      ),
    ],
  );
}

/// Interior compacto: la nota arriba y la etiqueta debajo.
class _CompactContent extends StatelessWidget {
  const _CompactContent({
    required this.action,
    required this.showNote,
    required this.ink,
    required this.fill,
  });

  final GuitarAction action;
  final bool showNote;
  final Color ink;
  final Color fill;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _NoteBadge(
        command: action.command,
        icon: action.icon,
        showNote: showNote,
        ink: ink,
        fill: fill,
      ),
      const SizedBox(height: 6),
      AppText(
        action.label,
        variant: AppTextVariant.labelLarge,
        weight: FontWeight.w700,
        color: ink,
        maxLines: 1,
        align: TextAlign.center,
      ),
    ],
  );
}

/// Círculo con el nombre de la nota (o el icono si no se usa la guitarra).
class _NoteBadge extends StatelessWidget {
  const _NoteBadge({
    required this.command,
    required this.icon,
    required this.showNote,
    required this.ink,
    required this.fill,
  });

  final GuitarCommand command;
  final IconData icon;
  final bool showNote;
  final Color ink;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return DecoratedBox(
      decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
      child: SizedBox(
        width: 46,
        height: 46,
        child: Center(
          child: showNote
              ? AppText(
                  openNoteName(t, command.string),
                  variant: AppTextVariant.titleLarge,
                  weight: FontWeight.w800,
                  color: ink,
                )
              : Icon(icon, color: ink),
        ),
      ),
    );
  }
}
