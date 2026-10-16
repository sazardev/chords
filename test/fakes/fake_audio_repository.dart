import 'dart:async';

import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
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

  final StreamController<ChordReading> _chordReadings =
      StreamController<ChordReading>.broadcast();

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

  @override
  Stream<ChordReading> get chordReadings => _chordReadings.stream;

  /// Veces que se pidió acceso al micrófono.
  int requests = 0;

  /// Veces que se detuvo la escucha.
  int stops = 0;

  /// Estado con el que responde [requestAccess].
  MicStatus accessResult = MicStatus.listening;

  /// Emite un nivel de entrada.
  void emitLevel(double level) => _levels.add(level);

  /// Emite una lectura polifónica ya construida.
  void emitChordReading(ChordReading reading) => _chordReadings.add(reading);

  /// Emite un acorde reconocido [chord] con su [confidence] y un cromagrama
  /// con las clases de [chord] encendidas.
  void emitChord(ChordCandidate chord, {double confidence = 0.9}) {
    final ChordCandidate shown = chord.withConfidence(confidence);
    _chordReadings.add(
      ChordReading(
        chroma: <double>[
          for (int i = 0; i < 12; i++)
            if (chord.pitchClasses.contains(i)) 1.0 else 0.05,
        ],
        candidates: <ChordCandidate>[shown],
        chord: shown,
        bass: chord.root.pitchClass,
        level: 0.6,
      ),
    );
  }

  /// Emite una lectura polifónica de silencio.
  void emitChordSilence() => _chordReadings.add(ChordReading.silence);

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
    await _chordReadings.close();
  }
}
