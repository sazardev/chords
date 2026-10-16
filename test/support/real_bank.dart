import 'dart:io';

import 'package:chords/data/chords/models/chord_database_parser.dart';
import 'package:chords/domain/chords/entities/chord.dart';

List<Chord>? _cached;

/// El banco de acordes real (el asset generado), leído una sola vez.
List<Chord> realBank() => _cached ??= parseChordDatabaseText(
  File('assets/chords/chords_db.json').readAsStringSync(),
).chords;

/// Un acorde del banco real por su identificador (`C-maj7`).
Chord realChord(String id) =>
    realBank().firstWhere((Chord chord) => chord.id == id);
