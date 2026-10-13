import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_key_card.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_controller.dart';
import 'package:chords/presentation/features/guitar_control/guitar_status_line.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
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
/// Con el modo guitarra global encendido el panel fijo de toda la app
/// (`GuitarDock`) dibuja estas mismas acciones, así que la barra solo las
/// registra y no ocupa sitio en la pantalla. [headline] es la línea de
/// contexto (p. ej. el juego elegido) que ese panel muestra.
///
/// Solo atiende la guitarra mientras es visible: una pantalla tapada por otra
/// o una pestaña oculta no reaccionan a las cuerdas.
class GuitarCommandBar extends StatefulWidget {
  /// Crea la barra con las [actions] de la pantalla.
  const GuitarCommandBar({required this.actions, super.key, this.headline});

  /// Acciones disponibles ahora.
  final List<GuitarAction> actions;

  /// Línea de contexto que muestra el panel global; `null` si no hay.
  final String? headline;

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
      _listener.attach(this, widget.actions, headline: widget.headline);
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
    if (context.watch<GuitarNavController?>()?.active ?? false) {
      return const SizedBox.shrink();
    }
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (listener.enabled) ...<Widget>[
            GuitarStatusLine(listener: listener),
            const SizedBox(height: 10),
          ],
          GuitarKeys(actions: widget.actions, listener: listener),
        ],
      ),
    );
  }
}
