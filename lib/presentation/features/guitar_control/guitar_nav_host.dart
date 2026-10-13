import 'package:chords/config/route_paths.dart';
import 'package:chords/presentation/features/guitar_control/guitar_dock.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_controller.dart';
import 'package:chords/presentation/features/guitar_control/guitar_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Pone el panel de la guitarra bajo toda la app mientras el modo esté activo.
///
/// Va por encima del navegador, de modo que se queda fijo al pasar de una
/// pantalla a otra, también sobre las que se abren encima (juegos, práctica).
/// Reparte el espacio: la app ocupa lo que queda sobre el panel y deja de ver
/// el borde inferior del sistema, que ya cubre el panel. Se oculta con el
/// teclado abierto.
class GuitarNavHost extends StatefulWidget {
  /// Envuelve [child] y conecta el menú con [router].
  const GuitarNavHost({required this.router, required this.child, super.key});

  /// Enrutador sobre el que navega el menú.
  final GoRouter router;

  /// La aplicación.
  final Widget child;

  @override
  State<GuitarNavHost> createState() => _GuitarNavHostState();
}

class _GuitarNavHostState extends State<GuitarNavHost> {
  /// Conserva el navegador al aparecer o desaparecer el panel.
  final GlobalKey _appKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<GuitarNavController?>()?.navigation = RouterGuitarNavigation(
      widget.router,
      home: kHomePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    final GuitarNavController? nav = context.watch<GuitarNavController?>();
    final Widget app = KeyedSubtree(key: _appKey, child: widget.child);
    if (nav == null || !nav.active) {
      return app;
    }
    final bool dock = MediaQuery.viewInsetsOf(context).bottom <= 0;
    return Column(
      children: <Widget>[
        Expanded(
          child: dock
              ? MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: app,
                )
              : app,
        ),
        if (dock) const GuitarDock(),
      ],
    );
  }
}
