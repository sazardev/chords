import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Organismo de navegación adaptable: barra inferior o riel lateral.
///
/// En anchos compactos usa `NavigationBar` (móvil/Android) y a partir de
/// ancho medio un `NavigationRail` (tablets/Linux/escritorio). Al cambiar de
/// pestaña detiene la escucha en vivo si quedaba activa.
class AdaptiveNavigationShell extends StatefulWidget {
  /// Crea el armazón de navegación.
  const AdaptiveNavigationShell({required this.shell, super.key});

  /// Shell de rutas con estado.
  final StatefulNavigationShell shell;

  @override
  State<AdaptiveNavigationShell> createState() =>
      _AdaptiveNavigationShellState();
}

class _AdaptiveNavigationShellState extends State<AdaptiveNavigationShell> {
  @override
  void didUpdateWidget(covariant AdaptiveNavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shell.currentIndex != widget.shell.currentIndex) {
      _stopLiveIfLeaving(widget.shell.currentIndex);
    }
  }

  void _stopLiveIfLeaving(int index) {
    if (kNavigationDestinations[index] == kLivePath) {
      return;
    }
    unawaited(context.read<LiveController>().stopIfListening());
  }

  void _onDestinationSelected(int index) {
    widget.shell.goBranch(
      index,
      initialLocation: index == widget.shell.currentIndex,
    );
    analytics.screen(kNavigationRouteNames[index]);
  }

  List<_Destination> _destinations(Translations t) => <_Destination>[
    _Destination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: t.nav.home,
    ),
    _Destination(
      icon: Icons.school_outlined,
      selectedIcon: Icons.school_rounded,
      label: t.nav.learn,
    ),
    _Destination(
      icon: Icons.library_music_outlined,
      selectedIcon: Icons.library_music_rounded,
      label: t.nav.chords,
    ),
    _Destination(
      icon: Icons.sports_esports_outlined,
      selectedIcon: Icons.sports_esports_rounded,
      label: t.nav.game,
    ),
    _Destination(
      icon: Icons.graphic_eq_outlined,
      selectedIcon: Icons.graphic_eq_rounded,
      label: t.nav.live,
    ),
    _Destination(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      label: t.nav.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<_Destination> destinations = _destinations(t);
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= 600) {
      return Scaffold(
        body: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: widget.shell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: width >= 840
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              extended: width >= 1100,
              destinations: <NavigationRailDestination>[
                for (final _Destination destination in destinations)
                  NavigationRailDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: Text(destination.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: widget.shell),
          ],
        ),
      );
    }
    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.shell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        animationDuration: kMotionMedium,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: <Widget>[
          for (final _Destination destination in destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}

/// Destino de navegación con sus iconos y etiqueta.
class _Destination {
  const _Destination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
