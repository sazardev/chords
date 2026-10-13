import 'package:chords/domain/audio/entities/guitar_nav_slot.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_controller.dart';
import 'package:chords/presentation/features/guitar_control/guitar_status_line.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Nombre de la opción [slot] del menú en el idioma activo.
String guitarSlotLabel(Translations t, GuitarNavSlot slot) => switch (slot) {
  GuitarNavSlot.home => t.nav.home,
  GuitarNavSlot.learn => t.nav.learn,
  GuitarNavSlot.chords => t.nav.chords,
  GuitarNavSlot.game => t.nav.game,
  GuitarNavSlot.live => t.nav.live,
  GuitarNavSlot.settings => t.nav.settings,
  GuitarNavSlot.profile => t.guitar.navProfile,
  GuitarNavSlot.back => t.guitar.navBack,
  GuitarNavSlot.close => t.guitar.navClose,
  GuitarNavSlot.off => t.guitar.navOff,
};

/// Menú abierto: una ficha por destino con la nota que lo elige.
///
/// Las fichas siguen el orden de las notas (Mi al aire, un traste más para
/// cada una), la del lugar en el que se está aparece marcada y todas se pueden
/// pulsar. Cabecera con el estado del micrófono y botón de cierre.
class GuitarNavMenu extends StatelessWidget {
  /// Crea el menú sobre el estado de [nav] y [listener].
  const GuitarNavMenu({required this.nav, required this.listener, super.key});

  /// Controlador del menú.
  final GuitarNavController nav;

  /// Oyente que da el estado del micrófono.
  final GuitarCommandListener listener;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final GuitarNavSlot? current = _currentSlot(nav.navigation?.location ?? '');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    t.guitar.navTitle,
                    variant: AppTextVariant.titleMedium,
                    weight: FontWeight.w700,
                    maxLines: 1,
                  ),
                  AppText(
                    t.guitar.navHint,
                    variant: AppTextVariant.labelMedium,
                    color: scheme.onSurfaceVariant,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Semantics(
              button: true,
              label: guitarSlotLabel(t, GuitarNavSlot.close),
              child: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: nav.closeMenu,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GuitarSlotGrid(current: current, onSelect: nav.select),
        const SizedBox(height: 10),
        GuitarStatusLine(listener: listener),
      ],
    );
  }

  /// Destino en el que se está según la ruta, o `null` si ninguno.
  static GuitarNavSlot? _currentSlot(String location) {
    for (final MapEntry<GuitarNavSlot, String> entry
        in GuitarNavController.paths.entries) {
      final String path = entry.value;
      final bool inside = path == '/'
          ? location == '/'
          : location == path || location.startsWith('$path/');
      if (inside) {
        return entry.key;
      }
    }
    return null;
  }
}

/// Rejilla con una ficha por opción del menú, en el orden de las notas.
class GuitarSlotGrid extends StatelessWidget {
  /// Crea la rejilla; [current] marca una opción y [onSelect] recibe la
  /// pulsada.
  const GuitarSlotGrid({required this.onSelect, super.key, this.current});

  /// Opción marcada (el destino actual); `null` si ninguna.
  final GuitarNavSlot? current;

  /// Se llama con la opción pulsada.
  final ValueChanged<GuitarNavSlot> onSelect;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints box) {
      const double gap = 6;
      final double width = (box.maxWidth - gap * 4) / 5;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: <Widget>[
          for (final GuitarNavSlot slot in GuitarNavSlot.values)
            SizedBox(
              width: width,
              child: GuitarSlotChip(
                slot: slot,
                here: slot == current,
                onTap: () => onSelect(slot),
              ),
            ),
        ],
      );
    },
  );
}

/// Ficha de una opción: nota, nombre y traste.
class GuitarSlotChip extends StatelessWidget {
  /// Crea la ficha de [slot]; [here] la marca como elegida o actual.
  const GuitarSlotChip({
    required this.slot,
    required this.here,
    required this.onTap,
    super.key,
  });

  /// Opción que representa.
  final GuitarNavSlot slot;

  /// Si es el destino actual o el elegido.
  final bool here;

  /// Se llama al pulsarla.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool off = slot == GuitarNavSlot.off;
    final Color background = here
        ? scheme.primary
        : (off ? scheme.errorContainer : scheme.secondaryContainer);
    final Color ink = here
        ? scheme.onPrimary
        : (off ? scheme.onErrorContainer : scheme.onSecondaryContainer);
    final String label = guitarSlotLabel(t, slot);
    final String fret = slot.fretFromE == 0
        ? t.guitar.navFretOpen
        : t.guitar.navFret(n: slot.fretFromE);
    return Semantics(
      button: true,
      selected: here,
      label: '$label. ${noteLabel(t, slot.pitchClass)}, $fret',
      child: ExcludeSemantics(
        child: AnimatedContainer(
          duration: kMotionMedium,
          curve: kStandardCurve,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppText(
                      noteLabel(t, slot.pitchClass),
                      variant: AppTextVariant.titleMedium,
                      weight: FontWeight.w800,
                      color: ink,
                      maxLines: 1,
                    ),
                    _Fit(label, ink, bold: true),
                    _Fit(fret, ink.withValues(alpha: 0.75)),
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

/// Texto de una línea que se encoge en vez de cortarse.
class _Fit extends StatelessWidget {
  const _Fit(this.text, this.color, {this.bold = false});

  final String text;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    child: AppText(
      text,
      variant: AppTextVariant.labelMedium,
      weight: bold ? FontWeight.w700 : null,
      color: color,
      maxLines: 1,
      overflow: TextOverflow.visible,
    ),
  );
}
