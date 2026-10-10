part of 'settings_page.dart';

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
