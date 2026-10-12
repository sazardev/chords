part of 'settings_page.dart';

/// Sección de tamaño de texto.
class _TextSection extends StatelessWidget {
  const _TextSection({required this.appearance});

  final AppearanceController appearance;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return _Section(
      title: t.settings.text.title,
      children: <Widget>[
        _SettingTile(
          title: t.settings.text.fontSize,
          subtitle: fontScaleLabel(t, appearance.fontScale),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final AppFontScale scale in AppFontScale.values)
                  ChoiceChip(
                    label: Text(fontScaleLabel(t, scale)),
                    selected: scale == appearance.fontScale,
                    onSelected: (_) =>
                        unawaited(appearance.setFontScale(scale)),
                  ),
              ],
            ),
          ),
        ),
        const _TileSeparator(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppText(
                t.settings.text.preview,
                variant: AppTextVariant.titleMedium,
              ),
              const SizedBox(height: 2),
              AppText(
                t.settings.text.previewSample,
                variant: AppTextVariant.bodyLarge,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Sección de idioma de la interfaz.
class _LanguageSection extends StatelessWidget {
  const _LanguageSection({required this.locale});

  final LocaleController locale;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return _Section(
      title: t.settings.language.title,
      children: <Widget>[
        RadioGroup<AppLanguage>(
          groupValue: locale.language,
          onChanged: (AppLanguage? value) {
            if (value != null) {
              unawaited(locale.select(value));
            }
          },
          child: Column(
            children: <Widget>[
              for (final AppLanguage language in AppLanguage.values)
                RadioListTile<AppLanguage>(
                  value: language,
                  title: Text(languageLabel(t, language)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Sección de guitarra (diagramas para zurdos).
class _GuitarSection extends StatelessWidget {
  const _GuitarSection({required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return _Section(
      title: t.settings.guitar,
      children: <Widget>[
        SwitchListTile(
          value: settings.mirrorChords,
          onChanged: (bool value) => settings.setMirrorChords(value: value),
          title: Text(t.settings.leftHandMode),
          subtitle: Text(t.settings.leftHandModeSubtitle),
        ),
      ],
    );
  }
}

/// Sección de sonido.
class _SoundSection extends StatelessWidget {
  const _SoundSection({required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return _Section(
      title: t.settings.sound,
      children: <Widget>[
        SwitchListTile(
          value: settings.soundEnabled,
          onChanged: (bool value) => settings.setSoundEnabled(value: value),
          title: Text(t.settings.chordSound),
          subtitle: Text(t.settings.chordSoundSubtitle),
        ),
      ],
    );
  }
}

/// Sección de aprendizaje e información de la app.
class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.onboarding});

  final OnboardingController onboarding;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return _Section(
      title: t.settings.learning,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.restart_alt_rounded),
          title: Text(t.settings.resetOnboarding),
          subtitle: Text(t.settings.resetOnboardingSubtitle),
          onTap: () async {
            await onboarding.reset();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.settings.onboardingReset)),
              );
            }
          },
        ),
        const _TileSeparator(),
        ListTile(
          leading: const Icon(Icons.info_outline_rounded),
          title: Text(t.settings.version),
          subtitle: Text('${const AppConfig.prod().appName} 1.2.2 (5)'),
        ),
        const _TileSeparator(),
        ListTile(
          leading: const Icon(Icons.code_rounded),
          title: Text(t.settings.cli),
          subtitle: Text(t.settings.cliCommand),
        ),
        if (appLogDiagnosticsEnabled) ...<Widget>[
          const _TileSeparator(),
          ListTile(
            leading: const Icon(Icons.monitor_heart_outlined),
            title: const Text('Registro de diagnóstico'),
            subtitle: const Text('Eventos, errores y rendimiento'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.go(kLogsPath),
          ),
        ],
      ],
    );
  }
}
