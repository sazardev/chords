/// Rellenos de batería (último compás de cada frase) que comparten los
/// géneros. Cada uno es un compás completo de 16 pasos.
library;

import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/patterns/drum_pattern.dart';

/// Relleno de rock: caja en el dos y baja por los toms.
const DrumPattern kFillRock = DrumPattern(<DrumVoice, String>{
  DrumVoice.kick: 'X-------X-----X-',
  DrumVoice.snare: '----X-----x-----',
  DrumVoice.tomHigh: '--------X-x-----',
  DrumVoice.tomMid: '------------X-x-',
  DrumVoice.tomLow: '--------------xX',
  DrumVoice.hatClosed: 'x-x-x-x---------',
});

/// Relleno suave: caja en redoble creciente.
const DrumPattern kFillSoft = DrumPattern(<DrumVoice, String>{
  DrumVoice.kick: 'X---------------',
  DrumVoice.snare: '----o-----o.o.xx',
  DrumVoice.tomMid: '------------o-o-',
  DrumVoice.hatClosed: 'o---o---o-------',
});

/// Relleno de jazz: caja sincopada sobre el ride.
const DrumPattern kFillJazz = DrumPattern(<DrumVoice, String>{
  DrumVoice.ride: 'X---x-x-X-------',
  DrumVoice.hatPedal: '----x-------x---',
  DrumVoice.kick: 'o---o---o---o---',
  DrumVoice.snare: '----.-x-.-x-x-xX',
  DrumVoice.tomLow: '--------------x-',
});

/// Relleno de funk: semicorcheas de caja con fantasmas.
const DrumPattern kFillFunk = DrumPattern(<DrumVoice, String>{
  DrumVoice.kick: 'X-----x---x-----',
  DrumVoice.snare: '----X..x.x.xxXxX',
  DrumVoice.hatClosed: 'x.o.x.o.--------',
  DrumVoice.tomLow: '--------------x-',
});

/// Relleno latino: timbales y congas rápidos.
const DrumPattern kFillLatin = DrumPattern(<DrumVoice, String>{
  DrumVoice.kick: 'X-------X-------',
  DrumVoice.timbale: '--------x-x-xXxX',
  DrumVoice.snare: '----x-----------',
  DrumVoice.congaSlap: '------------x-x-',
  DrumVoice.claves: 'X--X--X---X-X---',
});

/// Relleno de metal: doble bombo con toms.
const DrumPattern kFillMetal = DrumPattern(<DrumVoice, String>{
  DrumVoice.kick: 'XxXxXxXxXxXxXxXx',
  DrumVoice.snare: '----X---x-x-----',
  DrumVoice.tomHigh: '--------X-X-----',
  DrumVoice.tomMid: '------------X-X-',
  DrumVoice.tomLow: '--------------XX',
});

/// Relleno de punk: caja a corcheas y toms rápidos.
const DrumPattern kFillPunk = DrumPattern(<DrumVoice, String>{
  DrumVoice.kick: 'X---X---X-X-X-X-',
  DrumVoice.snare: '----X-x-x-x-xXxX',
  DrumVoice.tomMid: '------------x-x-',
});

/// Relleno de shuffle: tresillos de caja y tom.
const DrumPattern kFillShuffle = DrumPattern(<DrumVoice, String>{
  DrumVoice.kick: 'X-------X-------',
  DrumVoice.snare: '----X-----x-x-xX',
  DrumVoice.tomMid: '--------x-x-----',
  DrumVoice.hatClosed: 'x-o-x-o---------',
});

/// Relleno de reggae: redoble de toms con el aro.
const DrumPattern kFillReggae = DrumPattern(<DrumVoice, String>{
  DrumVoice.kick: '--------X-------',
  DrumVoice.rimshot: '--------x-x-x-x-',
  DrumVoice.tomHigh: '------------x-x-',
  DrumVoice.tomLow: '--------------xX',
  DrumVoice.hatClosed: 'x-o-x-o---------',
});

/// Relleno electrónico: redoble de charles y palmada.
const DrumPattern kFillElectronic = DrumPattern(<DrumVoice, String>{
  DrumVoice.kick: 'X---X---X-------',
  DrumVoice.hatClosed: 'x-x-x-x-xxxxxxxx',
  DrumVoice.clap: '----X---X-x-xxxX',
});

/// Relleno flamenco: golpes de cajón y palmas a contratiempo.
const DrumPattern kFillFlamenco = DrumPattern(<DrumVoice, String>{
  DrumVoice.cajon: 'X-------X-------',
  DrumVoice.cajonSlap: '----x-x-----xxxX',
  DrumVoice.palma: '--x---x---x-x-x-',
  DrumVoice.palmaMuted: '-x-x-x-x--------',
});
