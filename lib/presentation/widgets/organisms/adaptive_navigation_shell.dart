import 'package:chords/presentation/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Organismo de navegación adaptable: barra inferior o riel lateral.
///
/// En anchos compactos usa `NavigationBar` (móvil/Android) y a partir de
/// ancho medio un `NavigationRail` (tablets/Linux/escritorio).
class AdaptiveNavigationShell extends StatelessWidget {
  /// Crea el armazón de navegación.
  const AdaptiveNavigationShell({required this.shell, super.key});

  /// Shell de rutas con estado.
  final StatefulNavigationShell shell;

  static const List<_Destination> _destinations = <_Destination>[
    _Destination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Inicio',
    ),
    _Destination(
      icon: Icons.school_outlined,
      selectedIcon: Icons.school_rounded,
      label: 'Aprender',
    ),
    _Destination(
      icon: Icons.library_music_outlined,
      selectedIcon: Icons.library_music_rounded,
      label: 'Acordes',
    ),
    _Destination(
      icon: Icons.sports_esports_outlined,
      selectedIcon: Icons.sports_esports_rounded,
      label: 'Jugar',
    ),
    _Destination(
      icon: Icons.graphic_eq_outlined,
      selectedIcon: Icons.graphic_eq_rounded,
      label: 'En vivo',
    ),
    _Destination(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      label: 'Ajustes',
    ),
  ];

  void _onDestinationSelected(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= 600) {
      return Scaffold(
        body: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: width >= 840
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              extended: width >= 1100,
              destinations: <NavigationRailDestination>[
                for (final _Destination destination in _destinations)
                  NavigationRailDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: Text(destination.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        animationDuration: kMotionMedium,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: <Widget>[
          for (final _Destination destination in _destinations)
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
