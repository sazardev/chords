import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';

/// Caso de uso: obtener un acorde por su identificador.
class GetChordByIdUseCase {
  /// Crea el caso de uso con el repositorio indicado.
  const GetChordByIdUseCase(this._repository);

  final ChordRepository _repository;

  /// Devuelve el acorde o `null` si no existe.
  Chord? call(String id) => _repository.chordById(id);

  /// Versión asíncrona que garantiza que el banco esté cargado.
  Future<Chord?> load(String id) async {
    if (!_repository.isLoaded) {
      await _repository.load();
    }
    return _repository.chordById(id);
  }
}
