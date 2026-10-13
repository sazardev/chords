import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_listen_state.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Barra de acciones que se manejan con la guitarra.
///
/// Muestra una tarjeta por acción con la nota y la cuerda al aire que la
/// activa y lo que hace ("Continuar", "Reintentar"…). Mientras está en
/// pantalla registra sus acciones en el [GuitarCommandListener]; al
/// desaparecer las retira. Las tarjetas también se pueden pulsar.
///
/// Un encabezado dice en cada momento qué hacer: esperar a que se apague la
/// última nota, tocar una cuerda o revisar el micrófono.
///
/// Solo atiende la guitarra mientras es visible: una pantalla tapada por otra
/// o una pestaña oculta no reaccionan a las cuerdas.
class GuitarCommandBar extends StatefulWidget {
  /// Crea la barra con las [actions] de la pantalla.
  const GuitarCommandBar({required this.actions, super.key});

  /// Acciones disponibles ahora.
  final List<GuitarAction> actions;

  @override
  State<GuitarCommandBar> createState() => _GuitarCommandBarState();
}

class _GuitarCommandBarState extends State<GuitarCommandBar> {
  late final GuitarCommandListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = context.read<GuitarCommandListener>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _register();
  }

  @override
  void didUpdateWidget(GuitarCommandBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _register();
  }

  /// Registra las acciones si la barra se ve; si no, las retira.
  void _register() {
    if (TickerMode.valuesOf(context).enabled) {
      _listener.attach(this, widget.actions);
    } else {
      _listener.detach(this);
    }
  }

  @override
  void dispose() {
    _listener.detach(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GuitarCommandListener listener = context
        .watch<GuitarCommandListener>();
    final bool columnar = widget.actions.length == 1;
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (listener.enabled) ...<Widget>[
            _Header(listener: listener),
            const SizedBox(height: 10),
          ],
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints box) {
              const double gap = 8;
              final double width = columnar
                  ? box.maxWidth
                  : (box.maxWidth - gap) / 2;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: <Widget>[
                  for (final GuitarAction action in widget.actions)
                    SizedBox(
                      width: width,
                      child: _KeyCard(action: action, listener: listener),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Estado de la escucha: oye, espera el silencio o está lista.
class _Header extends StatelessWidget {
  const _Header({required this.listener});

  final GuitarCommandListener listener;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final GuitarListenState state = listener.state;
    final String text = !state.hearing
        ? t.guitar.noMic
        : (state.armed ? t.guitar.ready : t.guitar.waiting);
    final Color tint = state.ready ? scheme.primary : scheme.onSurfaceVariant;
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
          child: AppText(
            text,
            variant: AppTextVariant.labelLarge,
            color: tint,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

/// Tarjeta de una acción: la nota que la activa y qué hace.
class _KeyCard extends StatelessWidget {
  const _KeyCard({required this.action, required this.listener});

  final GuitarAction action;
  final GuitarCommandListener listener;

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
                child: _KeyContent(
                  action: action,
                  enabled: listener.enabled,
                  hint: hint,
                  ink: ink,
                  badgeFill: scheme.surface.withValues(alpha: 0.28),
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

/// Interior de una tarjeta: la nota, lo que hace y qué cuerda tocar.
class _KeyContent extends StatelessWidget {
  const _KeyContent({
    required this.action,
    required this.enabled,
    required this.hint,
    required this.ink,
    required this.badgeFill,
  });

  final GuitarAction action;
  final bool enabled;
  final String hint;
  final Color ink;
  final Color badgeFill;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      children: <Widget>[
        _NoteBadge(
          command: action.command,
          icon: action.icon,
          showNote: enabled,
          ink: ink,
          fill: badgeFill,
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
              if (enabled)
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
    ),
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
