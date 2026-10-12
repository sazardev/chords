import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/settings_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/domain/l10n/entities/app_language.dart';
import 'package:chords/domain/l10n/repositories/locale_repository.dart';
import 'package:chords/presentation/l10n/language_applier.dart';
import 'package:chords/presentation/l10n/slang_language_applier.dart';
import 'package:flutter/material.dart';

/// Controlador del idioma de la interfaz.
///
/// Lee la preferencia persistida, la aplica al subsistema de traducciones y
/// notifica a la interfaz para que se reconstruya con el nuevo idioma.
class LocaleController extends ChangeNotifier {
  /// Crea el controlador con el repositorio y el aplicador de idioma.
  ///
  /// Sin [applier] explícito se usa el de slang.
  LocaleController(
    this._repository, [
    this._applier = const SlangLanguageApplier(),
  ]);

  final LocaleRepository _repository;
  final LanguageApplier _applier;

  AppLanguage _language = AppLanguage.system;

  /// Idioma activo.
  AppLanguage get language => _language;

  /// `Locale` de Flutter; `null` significa «seguir al sistema».
  Locale? get locale {
    final String? code = _language.languageCode;
    return code == null ? null : Locale(code);
  }

  /// Cambia el idioma de la interfaz y lo persiste.
  Future<void> select(AppLanguage language) async {
    if (language == _language) {
      return;
    }
    _language = language;
    await _repository.saveLanguage(language);
    _applier.apply(language);
    appLogger.debug('idioma: ${language.name}');
    analytics.settingChanged(setting: 'language', value: language.name);
    notifyListeners();
  }

  /// Carga el idioma guardado y lo aplica.
  Future<void> load() async {
    _language = _repository.selectedLanguage;
    _applier.apply(_language);
    notifyListeners();
  }
}
