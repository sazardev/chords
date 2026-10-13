import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Interruptor para recorrer el catálogo de juegos con la guitarra.
class HubGuitarSwitch extends StatelessWidget {
  /// Crea el interruptor sobre los [settings].
  const HubGuitarSwitch({required this.settings, super.key});

  /// Ajustes donde se guarda la preferencia.
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: <Widget>[
          Icon(Icons.graphic_eq_rounded, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(t.guitar.hubTitle, variant: AppTextVariant.titleMedium),
                AppText(
                  t.guitar.hubSubtitle,
                  variant: AppTextVariant.labelMedium,
                  color: scheme.onSurfaceVariant,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Switch(
            value: settings.guitarBrowse,
            onChanged: (bool value) => settings.setGuitarBrowse(value: value),
          ),
        ],
      ),
    );
  }
}

/// Marca el elemento del catálogo que la guitarra tiene seleccionado.
///
/// Es un halo de color detrás de la tarjeta y un pequeño aumento: el diseño
/// plano no admite bordes, y así se ve de lejos aunque el móvil esté en el
/// atril.
class HubFocus extends StatelessWidget {
  /// Envuelve [child]; [focused] enciende el halo.
  const HubFocus({required this.focused, required this.child, super.key});

  /// Si es el elemento seleccionado.
  final bool focused;

  /// Tarjeta del catálogo.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AnimatedScale(
      scale: focused ? 1.03 : 1,
      duration: kMotionMedium,
      curve: kSpringCurve,
      child: AnimatedContainer(
        duration: kMotionMedium,
        curve: kStandardCurve,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: focused
              ? scheme.primary.withValues(alpha: 0.4)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(34),
        ),
        child: child,
      ),
    );
  }
}
