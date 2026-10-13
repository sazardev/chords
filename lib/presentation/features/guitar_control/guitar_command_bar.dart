import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_key_card.dart';
import 'package:chords/presentation/features/guitar_control/guitar_listen_state.dart';
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
/// Con [headline] añade una línea de contexto (p. ej. el juego elegido) y con
/// [onClose] un botón para salir del modo; [compact] reparte todas las
/// acciones en una sola fila de tarjetas apiladas, que ocupa mucho menos.
///
/// Solo atiende la guitarra mientras es visible: una pantalla tapada por otra
/// o una pestaña oculta no reaccionan a las cuerdas.
class GuitarCommandBar extends StatefulWidget {
  /// Crea la barra con las [actions] de la pantalla.
  const GuitarCommandBar({
    required this.actions,
    super.key,
    this.headline,
    this.onClose,
    this.compact = false,
  });

  /// Acciones disponibles ahora.
  final List<GuitarAction> actions;

  /// Línea de contexto sobre el estado de la escucha; `null` si no hay.
  final String? headline;

  /// Cierra el modo; `null` oculta el botón de cierre.
  final VoidCallback? onClose;

  /// Si las tarjetas se apilan en una sola fila.
  final bool compact;

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
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.headline != null || widget.onClose != null)
            _Title(headline: widget.headline, onClose: widget.onClose),
          if (listener.enabled) ...<Widget>[
            _Header(listener: listener),
            const SizedBox(height: 10),
          ],
          _Keys(
            actions: widget.actions,
            listener: listener,
            compact: widget.compact,
          ),
        ],
      ),
    );
  }
}

/// Línea de contexto con el botón de cierre del modo.
class _Title extends StatelessWidget {
  const _Title({required this.headline, required this.onClose});

  final String? headline;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Row(
      children: <Widget>[
        Expanded(
          child: AppText(
            headline ?? '',
            variant: AppTextVariant.titleMedium,
            weight: FontWeight.w700,
            maxLines: 1,
          ),
        ),
        if (onClose != null)
          IconButton(
            tooltip: t.guitar.exitMode,
            icon: const Icon(Icons.close_rounded),
            visualDensity: VisualDensity.compact,
            onPressed: onClose,
          ),
      ],
    );
  }
}

/// Las tarjetas de acción: en una fila, en dos columnas o a todo el ancho.
class _Keys extends StatelessWidget {
  const _Keys({
    required this.actions,
    required this.listener,
    required this.compact,
  });

  final List<GuitarAction> actions;
  final GuitarCommandListener listener;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    const double gap = 8;
    if (compact) {
      return Row(
        children: <Widget>[
          for (int i = 0; i < actions.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: gap),
            Expanded(
              child: GuitarKeyCard(
                action: actions[i],
                listener: listener,
                compact: true,
              ),
            ),
          ],
        ],
      );
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        final double width = actions.length == 1
            ? box.maxWidth
            : (box.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final GuitarAction action in actions)
              SizedBox(
                width: width,
                child: GuitarKeyCard(action: action, listener: listener),
              ),
          ],
        );
      },
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
