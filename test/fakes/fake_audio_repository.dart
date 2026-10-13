import 'dart:async';

import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';

/// Repositorio de audio en memoria para pruebas.
class FakeAudioRepository implements AudioRepository {
  final StreamController<PitchReading> _readings =
      StreamController<PitchReading>.broadcast();
  final StreamController<MicStatus> _status =
      StreamController<MicStatus>.broadcast();

  final StreamController<double> _levels = StreamController<double>.broadcast();

  /// Frecuencias de referencia reproducidas.
  final List<double> tones = <double>[];

  /// Identificadores de acordes reproducidos.
  final List<String> played = <String>[];

  /// Identificadores de arpegios reproducidos.
  final List<String> arpeggios = <String>[];

  @override
  Stream<PitchReading> get readings => _readings.stream;

  @override
  Stream<MicStatus> get statusStream => _status.stream;

  @override
  Stream<double> get levels => _levels.stream;

  /// Veces que se pidió acceso al micrófono.
  int requests = 0;

  /// Veces que se detuvo la escucha.
  int stops = 0;

  /// Estado con el que responde [requestAccess].
  MicStatus accessResult = MicStatus.listening;

  /// Emite un nivel de entrada.
  void emitLevel(double level) => _levels.add(level);

  /// Emite una lectura a una frecuencia concreta (para el afinador).
  void emitFrequency(double frequency, {double clarity = 0.95}) {
    _readings.add(
      PitchReading(
        frequency: frequency,
        note: 'A4',
        cents: 0,
        clarity: clarity,
        level: 0.6,
      ),
    );
  }

  /// Emite una lectura de tono con nota y claridad.
  void emitReading(
    String note, {
    double clarity = 0.9,
    double cents = 0,
    double frequency = 440,
  }) {
    _readings.add(
      PitchReading(
        frequency: frequency,
        note: note,
        cents: cents,
        clarity: clarity,
      ),
    );
  }

  @override
  Future<MicStatus> requestAccess() async {
    requests++;
    _status.add(accessResult);
    return accessResult;
  }

  @override
  Future<void> playReferenceTone(double frequency) async {
    tones.add(frequency);
  }

  @override
  Future<void> startListening() async => _status.add(MicStatus.listening);

  @override
  Future<void> stopListening() async {
    stops++;
    _status.add(MicStatus.idle);
  }

  @override
  Future<void> playChord(Chord chord, ChordVariant variant) async {
    played.add(chord.id);
  }

  @override
  Future<void> playArpeggio(
    Chord chord,
    ChordVariant variant,
    ArpeggioPattern pattern,
  ) async {
    arpeggios.add('${chord.id}:${pattern.id}');
  }

  @override
  Future<void> dispose() async {
    await _readings.close();
    await _status.close();
    await _levels.close();
  }
}
