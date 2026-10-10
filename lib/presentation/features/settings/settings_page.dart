import 'dart:async' show unawaited;

import 'package:chords/config/app_config.dart';
import 'package:chords/config/route_paths.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/domain/l10n/entities/app_language.dart';
import 'package:chords/domain/preferences/entities/app_accent_color.dart';
import 'package:chords/domain/preferences/entities/app_font_scale.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/locale_controller.dart';
import 'package:chords/presentation/l10n/preference_labels.dart';
import 'package:chords/presentation/theme/system_color_scope.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Ajustes de la aplicación: idioma, tema, color, texto, diagramas y sonido.
class SettingsPage extends StatelessWidget {
  /// Crea la pantalla de ajustes.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final SettingsController settings = context.watch<SettingsController>();
    final LocaleController locale = context.watch<LocaleController>();
    final OnboardingController onboarding = context
        .watch<OnboardingController>();
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: <Widget>[
          _AppearanceSection(settings: settings),
          _TextSection(settings: settings),
          _LanguageSection(locale: locale),
          _GuitarSection(settings: settings),
          _SoundSection(settings: settings),
          _AboutSection(onboarding: onboarding),
        ],
      ),
    );
  }
}

/// Sección de apariencia: tema, color de acento y color del sistema.
class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection({required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return _Section(
      title: t.settings.appearance,
      children: <Widget>[
        _SettingTile(
          title: t.settings.theme.title,
          subtitle: themeModeSummary(t, settings.themeMode),
          child: _ThemeModeSelector(settings: settings),
        ),
        const _TileSeparator(),
        _SettingTile(
          title: t.settings.color.title,
          subtitle: settings.dynamicColor
              ? t.settings.color.dynamicActive
              : accentColorLabel(t, settings.accentColor),
          child: _AppearanceControls(
            settings: settings,
            dynamicSupported: SystemColorScope.systemColorsOf(context) != null,
          ),
        ),
      ],
    );
  }
}

/// Controles de color dinámico y acento.
class _AppearanceControls extends StatelessWidget {
  const _AppearanceControls({
    required this.settings,
    required this.dynamicSupported,
  });

  final SettingsController settings;

  /// Si la plataforma expone un color de sistema (Material You).
  final bool dynamicSupported;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ThemeData theme = Theme.of(context);
    final bool dynamicOn = settings.dynamicColor && dynamicSupported;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SwitchListTile(
          value: dynamicOn,
          onChanged: dynamicSupported
              ? (bool value) =>
                    unawaited(settings.setDynamicColor(value: value))
              : null,
          title: Text(t.settings.color.systemTitle),
          subtitle: Text(
            dynamicSupported
                ? t.settings.color.systemSubtitle
                : t.settings.color.systemUnavailable,
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: dynamicOn
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: AppText(
                    t.settings.color.accentDisabledNote,
                    variant: AppTextVariant.labelMedium,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : _AccentColorPicker(settings: settings),
        ),
      ],
    );
  }
}

/// Selector del modo de tema con botones segmentados.
class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.settings});

  final SettingsController settings;

  /// Opciones disponibles del selector de tema.
  List<_ThemeOption> _options(Translations t) => <_ThemeOption>[
    (
      mode: ThemeMode.system,
      icon: Icons.brightness_auto_rounded,
      label: t.settings.theme.system,
    ),
    (
      mode: ThemeMode.light,
      icon: Icons.light_mode_rounded,
      label: t.settings.theme.light,
    ),
    (
      mode: ThemeMode.dark,
      icon: Icons.dark_mode_rounded,
      label: t.settings.theme.dark,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final bool compact = MediaQuery.sizeOf(context).width < 380;
    final List<_ThemeOption> options = _options(t);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: <ButtonSegment<ThemeMode>>[
            for (final _ThemeOption option in options)
              ButtonSegment<ThemeMode>(
                value: option.mode,
                icon: Icon(option.icon),
                label: compact ? null : Text(option.label),
                tooltip: option.label,
              ),
          ],
          selected: <ThemeMode>{settings.themeMode},
          onSelectionChanged: (Set<ThemeMode> selection) =>
              unawaited(settings.setThemeMode(selection.first)),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: AppText(
            themeModeValue(t, settings.themeMode),
            variant: AppTextVariant.labelMedium,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Selector de color de acento.
class _AccentColorPicker extends StatelessWidget {
  const _AccentColorPicker({required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          for (final AppAccentColor accent in AppAccentColor.values)
            Semantics(
              label: accentColorLabel(t, accent),
              selected: accent == settings.accentColor,
              button: true,
              child: Tooltip(
                message: accentColorLabel(t, accent),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => unawaited(settings.setAccentColor(accent)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 48,
                    height: 48,
                    padding: accent == settings.accentColor
                        ? const EdgeInsets.all(3)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: accent == settings.accentColor
                          ? scheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: accent.seed,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: accent == settings.accentColor
                          ? Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: scheme.onPrimary,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Sección de tamaño de texto.
class _TextSection extends StatelessWidget {
  const _TextSection({required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return _Section(
      title: t.settings.text.title,
      children: <Widget>[
        _SettingTile(
          title: t.settings.text.fontSize,
          subtitle: fontScaleLabel(t, settings.fontScale),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final AppFontScale scale in AppFontScale.values)
                  ChoiceChip(
                    label: Text(fontScaleLabel(t, scale)),
                    selected: scale == settings.fontScale,
                    onSelected: (_) => unawaited(settings.setFontScale(scale)),
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
          subtitle: Text('${const AppConfig.prod().appName} 1.2.0 (3)'),
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

/// Bloque de ajustes con título y contenedor plano.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  /// Título visible del bloque.
  final String title;

  /// Contenido del bloque.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: AppText(
            title,
            variant: AppTextVariant.titleMedium,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        AppCard(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    ),
  );
}

/// Ajuste con título, descripción y control.
class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  /// Nombre del ajuste.
  final String title;

  /// Valor actual del ajuste.
  final String subtitle;

  /// Control interactivo del ajuste.
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppText(title, variant: AppTextVariant.titleMedium),
        AppText(
          subtitle,
          variant: AppTextVariant.labelMedium,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

/// Separador plano entre ajustes de un mismo bloque.
class _TileSeparator extends StatelessWidget {
  const _TileSeparator();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    ),
  );
}

/// Opción del selector de modo de tema.
typedef _ThemeOption = ({ThemeMode mode, IconData icon, String label});
