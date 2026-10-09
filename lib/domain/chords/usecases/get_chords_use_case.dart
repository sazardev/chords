import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';

/// Caso de uso: cargar y entregar todos los acordes del banco.
class GetChordsUseCase {
  /// Crea el caso de uso con el repositorio indicado.
  const GetChordsUseCase(this._repository);

  final ChordRepository _repository;

  /// Carga (si es necesario) y devuelve todos los acordes.
  Future<List<Chord>> call() async {
    if (!_repository.isLoaded) {
      await _repository.load();
    }
    return _repository.chords;
  }
}
