import 'package:chords/domain/preferences/repositories/guitar_preferences.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda en `SharedPreferences` los ajustes del control con la guitarra.
///
/// Es un mixin para que [PreferencesService] siga siendo el único punto de
/// acceso a las preferencias sin crecer más de la cuenta.
mixin GuitarPreferencesStore implements GuitarPreferences {
  /// Clave del control de la app con la guitarra.
  static const String kGuitarControlKey = 'guitar_control_v1';

  /// Clave de recorrer el catálogo de juegos con la guitarra.
  static const String kGuitarBrowseKey = 'guitar_browse_v1';

  /// Almacén donde se guardan los valores.
  @protected
  SharedPreferences get store;

  @override
  bool get guitarControlEnabled => store.getBool(kGuitarControlKey) ?? true;

  @override
  Future<void> setGuitarControlEnabled({required bool value}) =>
      store.setBool(kGuitarControlKey, value);

  @override
  bool get guitarBrowseEnabled => store.getBool(kGuitarBrowseKey) ?? false;

  @override
  Future<void> setGuitarBrowseEnabled({required bool value}) =>
      store.setBool(kGuitarBrowseKey, value);
}
