import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_key_card.dart';
import 'package:chords/presentation/features/guitar_control/guitar_listen_state.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_controller.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_menu.dart';
import 'package:chords/presentation/features/guitar_control/guitar_status_line.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Panel fijo del modo guitarra: sustituye a la barra de navegación.
///
/// Está en toda la app, también sobre las pantallas de juego y práctica. En
/// reposo dice qué cuerda hace qué en la pantalla actual y cómo abrir el menú
/// (una nota aguda o el botón); con el menú abierto muestra todos los
/// destinos. Respeta el borde inferior del sistema.
class GuitarDock extends StatelessWidget {
  /// Crea el panel.
  const GuitarDock({super.key});

  @override
  Widget build(BuildContext context) {
    final GuitarNavController nav = context.watch<GuitarNavController>();
    final GuitarCommandListener listener = context
        .watch<GuitarCommandListener>();
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: AnimatedSize(
                duration: kMotionMedium,
                curve: kStandardCurve,
                alignment: Alignment.bottomCenter,
                child: nav.menuOpen
                    ? GuitarNavMenu(nav: nav, listener: listener)
                    : _Rest(nav: nav, listener: listener),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Panel en reposo: estado, botón de menú y órdenes de la pantalla.
class _Rest extends StatelessWidget {
  const _Rest({required this.nav, required this.listener});

  final GuitarNavController nav;
  final GuitarCommandListener listener;

  @override
  Widget build(BuildContext context) {
    final GuitarListenState state = listener.state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GuitarStatusLine(
          listener: listener,
          headline: state.headline,
          // Sin órdenes en la pantalla, lo único que se puede tocar es el menú.
          readyText: state.actions.isEmpty ? context.t.guitar.navWake : null,
          trailing: _MenuButton(onTap: nav.openMenu),
        ),
        if (state.actions.isNotEmpty) ...<Widget>[
          const SizedBox(height: 10),
          GuitarKeys(actions: state.actions, listener: listener, compact: true),
        ],
      ],
    );
  }
}

/// Botón del menú con la nota aguda que también lo abre.
class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: '${t.guitar.navMenu}. ${t.guitar.navWake}',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.apps_rounded, color: scheme.onPrimaryContainer),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AppText(
                          t.guitar.navMenu,
                          variant: AppTextVariant.labelLarge,
                          weight: FontWeight.w700,
                          color: scheme.onPrimaryContainer,
                        ),
                        AppText(
                          t.guitar.navWakeShort,
                          variant: AppTextVariant.labelMedium,
                          color: scheme.onPrimaryContainer.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
