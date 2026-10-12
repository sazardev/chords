/// Matemática de tono compartida por el afinador y el modo práctica.
library;

import 'dart:math' as math;

/// Distancia en cents desde [reference] hasta [frequency].
///
/// Positivo = [frequency] está por encima (más aguda) de [reference].
double centsBetween(double frequency, double reference) =>
    1200 * math.log(frequency / reference) / math.ln2;

/// Corrige el error de octava típico del detector: oír una octava de más.
///
/// Un error de octava conserva la desafinación, así que solo se pliega si
/// [cents] cae a menos de 120 cents de una octava exacta por encima del
/// objetivo. No se pliega hacia abajo ni notas intermedias: una cuerda muy
/// floja no se confunde con la octava de otra, ni una cuerda con otra.
double foldOctaveError(double cents) =>
    (cents - 1200).abs() <= 120 ? cents - 1200 : cents;

/// Frecuencia de la nota situada [semitones] por encima de [frequency].
double shiftBySemitones(double frequency, int semitones) =>
    frequency * math.pow(2, semitones / 12);
