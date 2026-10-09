import 'dart:async' show unawaited;

import 'package:chords/config/app_config.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Ajustes de la aplicación: tema, diagramas, sonido y onboarding.
class SettingsPage extends StatelessWidget {
  /// Crea la pantalla de ajustes.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settings = context.watch<SettingsController>();
    final OnboardingController onboarding = context
        .watch<OnboardingController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: <Widget>[
          _sectionTitle(context, 'Apariencia'),
          RadioGroup<ThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                unawaited(settings.setThemeMode(value));
              }
            },
            child: const Column(
              children: <Widget>[
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  title: Text('Tema del sistema'),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  title: Text('Claro'),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  title: Text('Oscuro'),
                ),
              ],
            ),
          ),
          const Divider(),
          _sectionTitle(context, 'Guitarra'),
          SwitchListTile(
            value: settings.mirrorChords,
            onChanged: (bool value) => settings.setMirrorChords(value: value),
            title: const Text('Modo zurdo'),
            subtitle: const Text('Muestra los diagramas en espejo'),
          ),
          const Divider(),
          _sectionTitle(context, 'Sonido'),
          SwitchListTile(
            value: settings.soundEnabled,
            onChanged: (bool value) => settings.setSoundEnabled(value: value),
            title: const Text('Sonido de acordes'),
            subtitle: const Text('Sintetiza rasgueos y arpegios'),
          ),
          const Divider(),
          _sectionTitle(context, 'Aprendizaje'),
          ListTile(
            leading: const Icon(Icons.restart_alt_rounded),
            title: const Text('Reiniciar onboarding'),
            subtitle: const Text('Vuelve a ver la introducción'),
            onTap: () async {
              await onboarding.reset();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Onboarding reiniciado')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('Versión'),
            subtitle: Text('${const AppConfig.prod().appName} 1.1.0 (2)'),
          ),
          const ListTile(
            leading: Icon(Icons.code_rounded),
            title: Text('CLI de desarrollo'),
            subtitle: Text('dart run bin/chords_cli.dart db generate'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium
          ?.copyWith(color: Theme.of(context).colorScheme.primary),
    ),
  );
}
