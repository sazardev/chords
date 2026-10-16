import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/services/chord_template.dart';
import 'package:chords/domain/audio/services/chord_template_bank.dart';

/// Compara un cromagrama con todas las plantillas de acorde.
///
/// Cada nota se pasa a "presencia" (0-1): por debajo de [presenceLow] de la
/// nota más fuerte no suena y por encima de [presenceHigh] suena del todo.
/// La puntuación de una plantilla es la parte ponderada de sus notas que
/// suenan (la quinta pesa la mitad, porque es la que más se omite) menos
/// [extraPenalty] por cada nota que suena y no es del acorde. Mirar presencia
/// y no energía importa en guitarra: la tercera o la séptima suelen tocarse en
/// una sola cuerda y suenan mucho más bajo que una raíz doblada, pero siguen
/// siendo lo que define el acorde. Así una nota suelta no es un power chord y
/// un Do no es un Cmaj7.
///
/// El bajo desempata: si la nota más grave es la raíz suma, si es una nota
/// ajena al acorde resta y si es otra nota del acorde (inversión) no cambia
/// nada. Es lo que separa a Am7 de C6, que tienen las mismas notas.
///
/// Reutiliza sus arrays: [rank] solo asigna los candidatos que devuelve.
class ChordMatcher {
  /// Crea el comparador con las plantillas de [bank].
  ChordMatcher({
    ChordTemplateBank? bank,
    this.presenceLow = 0.15,
    this.presenceHigh = 0.4,
    this.extraPenalty = 0.5,
    this.complexityPenalty = 0.03,
    this.rootBassBonus = 0.08,
    this.foreignBassPenalty = 0.1,
    this.powerChordCap = 0.7,
    this.minScore = 0.7,
    this.scoreRange = 0.25,
  }) : _bank = bank ?? _shared,
       _scores = Float64List((bank ?? _shared).length);

  /// Plantillas compartidas: se calculan una sola vez para toda la app.
  static final ChordTemplateBank _shared = ChordTemplateBank();

  /// Energía relativa (0-1) por debajo de la cual una nota no suena.
  final double presenceLow;

  /// Energía relativa (0-1) a partir de la cual una nota suena del todo.
  final double presenceHigh;

  /// Resta por cada nota presente que no pertenece al acorde.
  final double extraPenalty;

  /// Resta por cada nota del acorde por encima de tres (prefiere lo simple).
  final double complexityPenalty;

  /// Suma cuando el bajo es la raíz del acorde.
  final double rootBassBonus;

  /// Resta cuando el bajo no pertenece al acorde.
  final double foreignBassPenalty;

  /// Tope de confianza de un acorde de dos notas: una sola nota grave suena
  /// con su quinta (tercer armónico), así que nunca es del todo seguro.
  final double powerChordCap;

  /// Puntuación por debajo de la cual la confianza es 0.
  final double minScore;

  /// Tramo de puntuación (sobre [minScore]) que lleva la confianza de 0 a 1.
  final double scoreRange;

  final ChordTemplateBank _bank;
  final Float64List _scores;
  final Float64List _presence = Float64List(12);

  /// Los [limit] mejores candidatos para [chroma] (12 valores >= 0).
  ///
  /// [bass] es la nota (0-11) del sonido más grave, o -1 si no se conoce.
  /// Devuelve una lista vacía si el cromagrama no tiene energía.
  List<ChordCandidate> rank(Float64List chroma, int bass, {int limit = 5}) {
    if (!_measurePresence(chroma)) {
      return const <ChordCandidate>[];
    }
    for (int i = 0; i < _scores.length; i++) {
      _scores[i] = _score(_bank.templates[i], bass);
    }
    return _topCandidates(limit);
  }

  /// Rellena `_presence` a partir de [chroma]; `false` si no hay energía.
  bool _measurePresence(Float64List chroma) {
    double top = 0;
    for (int i = 0; i < 12; i++) {
      top = math.max(top, chroma[i]);
    }
    if (top <= 0) {
      return false;
    }
    for (int i = 0; i < 12; i++) {
      final double relative = chroma[i] / top;
      _presence[i] = ((relative - presenceLow) / (presenceHigh - presenceLow))
          .clamp(0.0, 1.0);
    }
    return true;
  }

  double _score(ChordTemplate template, int bass) {
    double present = 0;
    double total = 0;
    double extra = 0;
    for (int note = 0; note < 12; note++) {
      final double weight = template.weights[note];
      if (weight > 0) {
        present += weight * _presence[note];
        total += weight;
      } else {
        extra += _presence[note];
      }
    }
    return present / total -
        extraPenalty * extra -
        complexityPenalty * math.max(0, template.notes.length - 3) +
        _bassTerm(template, bass);
  }

  double _bassTerm(ChordTemplate template, int bass) {
    if (bass < 0) {
      return 0;
    }
    if (bass == template.rootPitchClass) {
      return rootBassBonus;
    }
    return template.contains(bass) ? 0 : -foreignBassPenalty;
  }

  List<ChordCandidate> _topCandidates(int limit) {
    final List<int> picked = <int>[];
    for (int n = 0; n < limit && n < _scores.length; n++) {
      int best = -1;
      for (int i = 0; i < _scores.length; i++) {
        if (!picked.contains(i) && (best < 0 || _scores[i] > _scores[best])) {
          best = i;
        }
      }
      picked.add(best);
    }
    return <ChordCandidate>[
      for (int n = 0; n < picked.length; n++) _candidate(picked, n),
    ];
  }

  ChordCandidate _candidate(List<int> picked, int n) {
    final ChordTemplate template = _bank.templates[picked[n]];
    final double raw = _scores[picked[n]];
    final double rival = n == 0 && picked.length > 1
        ? _scores[picked[1]]
        : _scores[picked[0]];
    final double margin = n == 0 ? raw - rival : 0;
    final double absolute = ((raw - minScore) / scoreRange).clamp(0.0, 1.0);
    final double separation = (margin / 0.08).clamp(0.0, 1.0);
    final double confidence = absolute * (0.55 + 0.45 * separation);
    return ChordCandidate(
      root: template.root,
      quality: template.quality,
      score: raw.clamp(0.0, 1.0),
      confidence: template.notes.length <= 2
          ? math.min(confidence, powerChordCap)
          : confidence,
    );
  }
}
