import 'package:chords/domain/chords/entities/chord_family.dart';
import 'package:meta/meta.dart';

/// Metadatos teóricos de una calidad de acorde.
///
/// Separados de la construcción (`ChordQuality.intervals`) para que el enum
/// siga siendo una lista corta y cada tabla de datos tenga su propio archivo.
@immutable
class ChordQualityInfo {
  /// Crea los metadatos.
  const ChordQualityInfo({
    required this.formula,
    required this.description,
    required this.genres,
    required this.family,
    required this.popularity,
    this.minDifficulty = 1,
    this.optional = const <int>[7],
    this.aliases = const <String>[],
  });

  /// Grados que construyen el acorde, como se escriben (`1`, `b3`, `#11`).
  final List<String> formula;

  /// Descripción musical breve en español.
  final String description;

  /// Géneros asociados.
  final List<String> genres;

  /// Familia para agrupar.
  final ChordFamily family;

  /// Cuánto se usa (1 raro, 5 imprescindible): ordena y puntúa.
  final int popularity;

  /// Dificultad mínima (1-5) de cualquier posición: lo que exige entender el
  /// acorde aunque la mano lo toque fácil.
  final int minDifficulty;

  /// Intervalos (en semitonos módulo 12) que se pueden omitir en una posición.
  ///
  /// Por defecto la quinta justa, que casi siempre se omite en la guitarra.
  final List<int> optional;

  /// Otros nombres con los que se busca la calidad (cifrados y palabras en
  /// español e inglés, sin tildes ni mayúsculas).
  final List<String> aliases;
}
