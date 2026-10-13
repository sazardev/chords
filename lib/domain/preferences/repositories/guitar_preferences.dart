/// Preferencias del control de la app con la guitarra.
abstract interface class GuitarPreferences {
  /// Si se puede manejar la app tocando cuerdas al aire con la guitarra.
  bool get guitarControlEnabled;

  /// Activa o desactiva el control con la guitarra.
  Future<void> setGuitarControlEnabled({required bool value});

  /// Si el catálogo de juegos se recorre tocando cuerdas al aire.
  bool get guitarBrowseEnabled;

  /// Activa o desactiva recorrer el catálogo de juegos con la guitarra.
  Future<void> setGuitarBrowseEnabled({required bool value});
}
