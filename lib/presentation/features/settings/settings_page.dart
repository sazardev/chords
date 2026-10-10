import 'dart:async' show unawaited;

import 'package:chords/config/app_config.dart';
import 'package:chords/config/route_paths.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/domain/l10n/entities/app_language.dart';
import 'package:chords/domain/preferences/entities/app_accent_color.dart';
import 'package:chords/domain/preferences/entities/app_font_scale.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/settings/appearance_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/locale_controller.dart';
import 'package:chords/presentation/l10n/preference_labels.dart';
import 'package:chords/presentation/theme/system_color_scope.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

part 'settings_appearance.dart';
part 'settings_content.dart';
part 'settings_support.dart';

/// Ajustes de la aplicación: idioma, tema, color, texto, diagramas y sonido.
///
/// Compone las secciones (apariencia, texto, idioma, guitarra, sonido y acerca
/// de), cada una en su propio archivo por responsabilidad.
class SettingsPage extends StatelessWidget {
  /// Crea la pantalla de ajustes.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final AppearanceController appearance = context
        .watch<AppearanceController>();
    final SettingsController settings = context.watch<SettingsController>();
    final LocaleController locale = context.watch<LocaleController>();
    final OnboardingController onboarding = context
        .watch<OnboardingController>();
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: <Widget>[
          _AppearanceSection(appearance: appearance),
          _TextSection(appearance: appearance),
          _LanguageSection(locale: locale),
          _GuitarSection(settings: settings),
          _SoundSection(settings: settings),
          _AboutSection(onboarding: onboarding),
        ],
      ),
    );
  }
}
