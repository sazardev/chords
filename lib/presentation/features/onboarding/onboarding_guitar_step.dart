import 'package:chords/domain/audio/entities/guitar_nav_slot.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_menu.dart';
import 'package:chords/presentation/features/onboarding/onboarding_steps.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Paso del onboarding que ofrece manejar toda la app con la guitarra.
///
/// Un interruptor enciende el modo (y pide el micrófono), dos pasos numerados
/// explican cómo abrir el menú y elegir, y la rejilla de opciones deja ver qué
/// nota elige cada una: al pulsar una dice su nota y su traste.
class GuitarModeStep extends StatefulWidget {
  /// Crea el paso.
  const GuitarModeStep({super.key});

  @override
  State<GuitarModeStep> createState() => _GuitarModeStepState();
}

class _GuitarModeStepState extends State<GuitarModeStep> {
  GuitarNavSlot _preview = GuitarNavSlot.home;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final SettingsController settings = context.watch<SettingsController>();
    return OnboardingStep(
      title: t.onboarding.guitarModeTitle,
      body: t.onboarding.guitarModeBody,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Entrance(
            index: 2,
            child: AppCard(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: SwitchListTile(
                value: settings.guitarBrowse,
                onChanged: (bool value) =>
                    settings.setGuitarBrowse(value: value),
                title: Text(t.onboarding.guitarModeSwitch),
                subtitle: Text(t.onboarding.guitarModeSwitchHint),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Entrance(
            index: 3,
            child: _HowTo(
              number: 1,
              icon: Icons.music_note_rounded,
              text: t.onboarding.guitarModeStep1,
            ),
          ),
          const SizedBox(height: 10),
          Entrance(
            index: 4,
            child: _HowTo(
              number: 2,
              icon: Icons.apps_rounded,
              text: t.onboarding.guitarModeStep2,
            ),
          ),
          const SizedBox(height: 16),
          Entrance(
            index: 5,
            child: GuitarSlotGrid(
              current: _preview,
              onSelect: (GuitarNavSlot slot) => setState(() => _preview = slot),
            ),
          ),
          const SizedBox(height: 12),
          Entrance(index: 6, child: _Preview(slot: _preview)),
        ],
      ),
    );
  }
}

/// Un paso numerado de la explicación.
class _HowTo extends StatelessWidget {
  const _HowTo({required this.number, required this.icon, required this.text});

  final int number;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, color: scheme.onPrimaryContainer),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: AppText(
              '$number. $text',
              variant: AppTextVariant.bodyLarge,
              maxLines: 4,
            ),
          ),
        ),
      ],
    );
  }
}

/// Frase con la nota, el traste y el destino de la opción mirada.
class _Preview extends StatelessWidget {
  const _Preview({required this.slot});

  final GuitarNavSlot slot;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String fret = slot.fretFromE == 0
        ? t.guitar.navFretOpen
        : t.guitar.navFret(n: slot.fretFromE);
    final String line = t.onboarding.guitarModePreview(
      note: noteLabel(t, slot.pitchClass),
      fret: fret,
      label: guitarSlotLabel(t, slot),
    );
    return AppText(
      '${t.onboarding.guitarModeTry}\n$line',
      variant: AppTextVariant.labelLarge,
      color: scheme.onSurfaceVariant,
      maxLines: 3,
    );
  }
}
