///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';

import 'translations.g.dart';

// Path: <root>
class TranslationsEn extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsEn({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(
         cardinalResolver: cardinalResolver,
         ordinalResolver: ordinalResolver,
       ) {
    _meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  /// Access flat map
  @override
  dynamic operator [](String key) => _meta.getTranslation(key) ?? super[key];

  late final TranslationsEn _root = this; // ignore: unused_field

  @override
  TranslationsEn $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => TranslationsEn(meta: meta ?? this.$meta);

  // Translations
  @override
  late final Translations$app$en app = Translations$app$en._(_root);
  @override
  late final Translations$nav$en nav = Translations$nav$en._(_root);
  @override
  late final Translations$home$en home = Translations$home$en._(_root);
  @override
  late final Translations$chords$en chords = Translations$chords$en._(_root);
  @override
  late final Translations$chordDetail$en chordDetail =
      Translations$chordDetail$en._(_root);
  @override
  late final Translations$game$en game = Translations$game$en._(_root);
  @override
  late final Translations$chordDiagram$en chordDiagram =
      Translations$chordDiagram$en._(_root);
  @override
  late final Translations$live$en live = Translations$live$en._(_root);
  @override
  late final Translations$learn$en learn = Translations$learn$en._(_root);
  @override
  late final Translations$settings$en settings = Translations$settings$en._(
    _root,
  );
  @override
  late final Translations$onboarding$en onboarding =
      Translations$onboarding$en._(_root);
  @override
  late final Translations$data$en data = Translations$data$en._(_root);
  @override
  late final Translations$logs$en logs = Translations$logs$en._(_root);
  @override
  late final Translations$router$en router = Translations$router$en._(_root);
  @override
  late final Translations$mic$en mic = Translations$mic$en._(_root);
  @override
  late final Translations$tuner$en tuner = Translations$tuner$en._(_root);
  @override
  late final Translations$practice$en practice = Translations$practice$en._(
    _root,
  );
  @override
  late final Translations$profile$en profile = Translations$profile$en._(_root);
  @override
  late final Translations$minigames$en minigames = Translations$minigames$en._(
    _root,
  );
  @override
  late final Translations$guitar$en guitar = Translations$guitar$en._(_root);
}

// Path: app
class Translations$app$en extends Translations$app$es {
  Translations$app$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Chords';
  @override
  String get chordFallback => 'Chord';
  @override
  String get skip => 'Skip';
  @override
  String get next => 'Next';
  @override
  String get start => 'Start';
}

// Path: nav
class Translations$nav$en extends Translations$nav$es {
  Translations$nav$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get home => 'Home';
  @override
  String get learn => 'Learn';
  @override
  String get chords => 'Chords';
  @override
  String get game => 'Play';
  @override
  String get live => 'Tune';
  @override
  String get settings => 'Settings';
}

// Path: home
class Translations$home$en extends Translations$home$es {
  Translations$home$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get greeting => 'Hello, guitarist';
  @override
  String get question => 'What are you playing today?';
  @override
  String get progressTitle => 'Itinerary progress';
  @override
  String masteredCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: '${n} chord mastered',
        other: '${n} chords mastered',
      );
  @override
  String get continueLearning => 'Keep learning';
  @override
  String get itineraryComplete => 'Itinerary complete!';
  @override
  String nextChord({required Object name}) => 'Next: ${name}';
  @override
  String get library => 'Chord library';
  @override
  String librarySubtitle({required Object count}) =>
      '${count} chords by genre and level';
  @override
  String get gameMode => 'Mini-games';
  @override
  String gameSubtitle({required Object count}) =>
      '${count} games for ear, fretboard and fingers';
  @override
  String get liveTitle => 'Tuner and listening';
  @override
  String get liveSubtitle => 'Tune string by string with your microphone';
  @override
  String get greetingMorning => 'Good morning';
  @override
  String get greetingAfternoon => 'Good afternoon';
  @override
  String get greetingEvening => 'Good evening';
  @override
  String get nextUp => 'Your next chord';
  @override
  String get practiceCta => 'Practice';
  @override
  String get statMastered => 'Mastered';
  @override
  String get statBest => 'Best score';
  @override
  String get statLevel => 'Level';
  @override
  String get recommendedTitle => 'For you';
  @override
  String get recommendedEmpty =>
      'Complete your profile to see recommendations.';
  @override
  String get toolsTitle => 'Tools';
  @override
  String get seeAll => 'See all';
  @override
  String get learnSubtitle => 'Your step-by-step path';
}

// Path: chords
class Translations$chords$en extends Translations$chords$es {
  Translations$chords$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Chords';
  @override
  String get clearFilters => 'Clear filters';
  @override
  String get searchHint => 'Search chords';
  @override
  String get filterAll => 'All';
  @override
  String get filterAllQualities => 'All';
  @override
  String positionCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: '${n} position',
        other: '${n} positions',
      );
  @override
  String levelShort({required Object level}) => 'Lv ${level}';
  @override
  String maxDifficulty({required Object level}) => 'Max difficulty: ${level}';
  @override
  String get loading => 'Loading chords…';
  @override
  String get loadErrorTitle => 'Could not load the chord bank';
  @override
  String get loadErrorMessage =>
      'Restart the app to try loading the bank again.';
  @override
  String get emptyTitle => 'No results';
  @override
  String get emptyMessage =>
      'Adjust the search or the filters to see more chords.';
  @override
  String get filters => 'Filters';
  @override
  String get filterLevel => 'Level';
  @override
  String get filterQuality => 'Chord type';
  @override
  String get filterDifficulty => 'Max difficulty';
  @override
  String get forMyLevel => 'For my level';
  @override
  String get apply => 'Show results';
  @override
  String get reset => 'Reset';
  @override
  String results({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: '${n} chord',
        other: '${n} chords',
      );
}

// Path: chordDetail
class Translations$chordDetail$en extends Translations$chordDetail$es {
  Translations$chordDetail$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get titleFallback => 'Chord';
  @override
  String get markMastered => 'Mark as mastered';
  @override
  String get unmarkMastered => 'Remove from mastered';
  @override
  String get leftHandMode => 'Left-handed mode';
  @override
  String get leftHandModeOff => 'Disable left-handed mode';
  @override
  String get loading => 'Loading chord…';
  @override
  String get errorTitle => 'Chord unavailable';
  @override
  String notFoundMessage({required Object chordId}) =>
      'Chord ${chordId} not found';
  @override
  String get loadFailed => 'The chord bank could not be read.';
  @override
  String get noChordTitle => 'No chord selected';
  @override
  String get noChordMessage => 'Go back to the list and pick a chord.';
  @override
  String get listen => 'Listen to chord';
  @override
  String listenPosition({required Object position}) => 'Listen to ${position}';
  @override
  String get arpeggios => 'Arpeggios';
  @override
  String get positions => 'Positions';
  @override
  String notes({required Object notes}) => 'Notes: ${notes}';
  @override
  String arpeggioChip({required Object label, required Object level}) =>
      '${label} · Lv ${level}';
  @override
  String get practice => 'Practice';
  @override
  String get guideTitle => 'How to place it';
  @override
  String get guideLegend => '1 index · 2 middle · 3 ring · 4 pinky';
  @override
  String guideFinger({required Object fret, required Object string}) =>
      'Fret ${fret} · string ${string}';
  @override
  String guideBarre({
    required Object fret,
    required Object from,
    required Object to,
  }) => 'Barre at fret ${fret} · string ${from} to ${to}';
  @override
  String guidePlay({required Object strings}) => 'Play: ${strings}';
  @override
  String guideOpen({required Object strings}) => 'Open: ${strings}';
  @override
  String guideMuted({required Object strings}) => 'Don\'t play: ${strings}';
  @override
  String get guideOpenPosition => 'Open position, next to the nut';
  @override
  String guideRange({required Object from, required Object to}) =>
      'Around frets ${from} to ${to}';
  @override
  String guideSingleFret({required Object fret}) => 'Around fret ${fret}';
  @override
  String get recommended => 'Start here';
  @override
  Map<String, String> get fingerNames => {
    'f1': 'Index',
    'f2': 'Middle',
    'f3': 'Ring',
    'f4': 'Pinky',
  };
}

// Path: game
class Translations$game$en extends Translations$game$es {
  Translations$game$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Play';
  @override
  String get start => 'Start streak';
  @override
  String get emptyTitle => 'Play the chord';
  @override
  String emptyMessage({required Object best}) =>
      'Chain a series of chords with the microphone. Best: ${best} points.';
  @override
  String round({required Object number}) => 'Round ${number}';
  @override
  String get playThisChord => 'Play this chord';
  @override
  String get loadingChord => 'Loading chord…';
  @override
  String get listening => 'Listening to your guitar…';
  @override
  String get correctNext => 'Correct! Next';
  @override
  String get retry => 'Try again';
  @override
  String get ready => 'I\'m ready';
  @override
  String get streak => 'Streak';
  @override
  String get score => 'Score';
  @override
  String feedbackProgress({required Object hit, required Object total}) =>
      'Going well! ${hit} of ${total} notes';
  @override
  String feedbackMissing({required Object notes}) => 'Missing: ${notes}';
  @override
  String feedbackExtra({required Object notes}) => 'Extra notes: ${notes}';
  @override
  String get feedbackComplete => 'Chord complete!';
  @override
  String get almostNext => 'Almost! Next';
  @override
  String get stringFirst => '1st';
  @override
  String get stringSecond => '2nd';
  @override
  String get stringThird => '3rd';
  @override
  String get stringFourth => '4th';
  @override
  String get stringFifth => '5th';
  @override
  String get stringSixth => '6th';
  @override
  String get practiceChord => 'Practice string by string';
  @override
  String get finishedTitle => 'Series complete!';
  @override
  String finishedMessage({
    required Object won,
    required Object total,
    required Object score,
  }) => '${won} of ${total} chords · ${score} points';
  @override
  String finishedBest({required Object best}) => 'Your best: ${best} points';
}

// Path: chordDiagram
class Translations$chordDiagram$en extends Translations$chordDiagram$es {
  Translations$chordDiagram$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String stringLabel({required Object number, required Object fret}) =>
      'string ${number}: ${fret}';
  @override
  String get muted => 'muted';
  @override
  String get open => 'open';
  @override
  String fret({required Object value}) => 'fret ${value}';
  @override
  String description({required Object position, required Object details}) =>
      'Diagram of ${position}, ${details}';
}

// Path: live
class Translations$live$en extends Translations$live$es {
  Translations$live$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tuner';
  @override
  String get emptyTitle => 'No suggestions yet';
  @override
  String get emptyMessage => 'Press listen and play a chord to see matches.';
  @override
  String get suggestions => 'Suggestions';
  @override
  String get idleTitle => 'Microphone idle';
  @override
  String get idleMessage => 'Play a note on the guitar';
  @override
  String get listening => 'Listening…';
  @override
  String get deniedTitle => 'Permission denied';
  @override
  String get errorTitle => 'Capture error';
}

// Path: learn
class Translations$learn$en extends Translations$learn$es {
  Translations$learn$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Learn';
  @override
  String get loading => 'Preparing levels…';
  @override
  String get errorTitle => 'Could not load the itinerary';
  @override
  String get errorMessage => 'Restart the app to try again.';
  @override
  String get yourProgress => 'Your progress';
  @override
  String masteredCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: '${n} chord mastered',
        other: '${n} chords mastered',
      );
  @override
  String get stepByStep => 'Step by step';
  @override
  String get stepFingers => 'Place your fingers one by one on the fretboard';
  @override
  String get stepStrum => 'Slow strum: listen to every string';
  @override
  String get stepChange => 'Move to the next chord without stopping the rhythm';
  @override
  String get guidedArpeggios => 'Guided arpeggios';
  @override
  String levelSection({
    required Object emoji,
    required Object level,
    required Object title,
  }) => '${emoji}  Level ${level}: ${title}';
  @override
  String arpeggioHint({required Object label}) =>
      'Open the chord and play its ${label} arpeggio';
}

// Path: settings
class Translations$settings$en extends Translations$settings$es {
  Translations$settings$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Settings';
  @override
  String get appearance => 'Appearance';
  @override
  late final Translations$settings$theme$en theme =
      Translations$settings$theme$en._(_root);
  @override
  late final Translations$settings$color$en color =
      Translations$settings$color$en._(_root);
  @override
  late final Translations$settings$text$en text =
      Translations$settings$text$en._(_root);
  @override
  late final Translations$settings$language$en language =
      Translations$settings$language$en._(_root);
  @override
  late final Translations$settings$accent$en accent =
      Translations$settings$accent$en._(_root);
  @override
  late final Translations$settings$fontScale$en fontScale =
      Translations$settings$fontScale$en._(_root);
  @override
  String get guitar => 'Guitar';
  @override
  String get leftHandMode => 'Left-handed mode';
  @override
  String get leftHandModeSubtitle => 'Mirrors the chord diagrams';
  @override
  String get sound => 'Sound';
  @override
  String get chordSound => 'Chord sound';
  @override
  String get chordSoundSubtitle => 'Synthesizes strums and arpeggios';
  @override
  String get learning => 'Learning';
  @override
  String get resetOnboarding => 'Reset onboarding';
  @override
  String get resetOnboardingSubtitle => 'Show the introduction again';
  @override
  String get onboardingReset => 'Onboarding reset';
  @override
  String get version => 'Version';
  @override
  String get cli => 'Development CLI';
  @override
  String get cliCommand => 'dart run bin/chords_cli.dart db generate';
}

// Path: onboarding
class Translations$onboarding$en extends Translations$onboarding$es {
  Translations$onboarding$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get slideOneTitle => 'Every chord, every position';
  @override
  String get slideOneBody =>
      '156 chords and 561 verified positions, from the essential open shapes to jazz voicings.';
  @override
  String get slideTwoTitle => 'Listen to every chord and its arpeggio';
  @override
  String get slideTwoBody =>
      'We synthesize each string so you can recognise the sound before playing.';
  @override
  String get slideThreeTitle => 'Learn by levels and practise';
  @override
  String get slideThreeBody =>
      'Step-by-step itinerary, genre filter and game mode to chain chord streaks.';
  @override
  String get welcomeTitle => 'Your guitar, made to measure';
  @override
  String get welcomeBody =>
      'Five quick questions and I will recommend the chords that suit you best.';
  @override
  String get welcomeCta => 'Get started';
  @override
  String stepOf({required Object current, required Object total}) =>
      'Step ${current} of ${total}';
  @override
  String get back => 'Back';
  @override
  String get proceed => 'Continue';
  @override
  String get finish => 'Start playing';
  @override
  String get guitarTitle => 'Which guitar do you play?';
  @override
  String get guitarBody => 'Each one calls for different chords.';
  @override
  String get guitarAcoustic => 'Acoustic';
  @override
  String get guitarAcousticHint => 'Steel strings and open chords';
  @override
  String get guitarElectric => 'Electric';
  @override
  String get guitarElectricHint => 'Power chords and riffs';
  @override
  String get guitarClassical => 'Classical';
  @override
  String get guitarClassicalHint => 'Nylon strings and fingers';
  @override
  String get playTitle => 'How do you play it?';
  @override
  String get playBody => 'I adapt the diagrams and arpeggios to your playing.';
  @override
  String get handLabel => 'Your hand';
  @override
  String get handRight => 'Right-handed';
  @override
  String get handRightHint => 'Regular diagrams';
  @override
  String get handLeft => 'Left-handed';
  @override
  String get handLeftHint => 'Mirrored diagrams';
  @override
  String get styleLabel => 'How you pluck the strings';
  @override
  String get stylePick => 'Pick';
  @override
  String get styleFingers => 'Fingers';
  @override
  String get styleBoth => 'Both';
  @override
  String get genresTitle => 'What music do you like?';
  @override
  String get genresBody =>
      'Pick as many as you like: I recommend chords from those styles.';
  @override
  String get levelTitle => 'How much experience do you have?';
  @override
  String get levelBody =>
      'I tune the difficulty so you progress without frustration.';
  @override
  String get levelBeginner => 'I\'m just starting';
  @override
  String get levelBeginnerHint => 'Open chords, no barre';
  @override
  String get levelIntermediate => 'I already play songs';
  @override
  String get levelIntermediateHint => 'Chord changes and basic barres';
  @override
  String get levelAdvanced => 'I play fluently';
  @override
  String get levelAdvancedHint => 'Barres, sevenths and voicings';
  @override
  String get planTitle => 'Your plan is ready';
  @override
  String get planBody => 'Start with these chords, picked for you.';
  @override
  String get planEmpty =>
      'Explore the library and start with the one you like most.';
}

// Path: data
class Translations$data$en extends Translations$data$es {
  Translations$data$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  late final Translations$data$language$en language =
      Translations$data$language$en._(_root);
  @override
  late final Translations$data$genre$en genre = Translations$data$genre$en._(
    _root,
  );
  @override
  late final Translations$data$quality$en quality =
      Translations$data$quality$en._(_root);
  @override
  late final Translations$data$qualityDescription$en qualityDescription =
      Translations$data$qualityDescription$en._(_root);
  @override
  late final Translations$data$difficulty$en difficulty =
      Translations$data$difficulty$en._(_root);
  @override
  late final Translations$data$difficultyHint$en difficultyHint =
      Translations$data$difficultyHint$en._(_root);
  @override
  late final Translations$data$level$en level = Translations$data$level$en._(
    _root,
  );
  @override
  late final Translations$data$levelGoal$en levelGoal =
      Translations$data$levelGoal$en._(_root);
  @override
  late final Translations$data$arpeggio$en arpeggio =
      Translations$data$arpeggio$en._(_root);
}

// Path: logs
class Translations$logs$en extends Translations$logs$es {
  Translations$logs$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Diagnostics';
  @override
  String get clear => 'Clear log';
  @override
  String get total => 'Total';
  @override
  String get errors => 'Errors';
  @override
  String get warnings => 'Warnings';
  @override
  String get allLevels => 'All';
  @override
  String get empty => 'No events recorded';
}

// Path: router
class Translations$router$en extends Translations$router$es {
  Translations$router$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get notFound => 'Route not found';
  @override
  String get goHome => 'Go to home';
}

// Path: mic
class Translations$mic$en extends Translations$mic$es {
  Translations$mic$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get deniedTitle => 'I need your microphone';
  @override
  String get deniedMessage =>
      'Allow microphone access in your phone settings and try again.';
  @override
  String get errorTitle => 'I couldn\'t listen';
  @override
  String get errorMessage =>
      'Something went wrong opening the microphone. Check that no other app is using it.';
  @override
  String get retry => 'Try again';
  @override
  String get levelLabel => 'Microphone level';
  @override
  String get levelWaiting => 'Waiting for sound…';
  @override
  String get levelQuiet =>
      'I can barely hear you: bring the guitar closer to the microphone';
  @override
  String get levelGood => 'I can hear you well';
  @override
  String get levelLoud => 'Too loud: move the guitar a little farther away';
}

// Path: tuner
class Translations$tuner$en extends Translations$tuner$es {
  Translations$tuner$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get pluckPrompt => 'Play an open string';
  @override
  String pluckString({required Object string}) => 'Play the ${string}';
  @override
  String stringTitle({required Object ordinal, required Object note}) =>
      '${ordinal} string · ${note}';
  @override
  String get noteE => 'E';
  @override
  String get noteA => 'A';
  @override
  String get noteD => 'D';
  @override
  String get noteG => 'G';
  @override
  String get noteB => 'B';
  @override
  String get tuned => 'In tune!';
  @override
  String get upLittle => 'Tune up a little';
  @override
  String get up => 'Tune up';
  @override
  String get upALot => 'Tune up a lot';
  @override
  String get downLittle => 'Tune down a little';
  @override
  String get down => 'Tune down';
  @override
  String get downALot => 'Tune down a lot';
  @override
  String get tightenPeg => 'Tighten the peg';
  @override
  String get loosenPeg => 'Loosen the peg';
  @override
  String get holdSteady => 'Let the note ring';
  @override
  String heardOther({required Object heard, required Object target}) =>
      'That sounds like the ${heard}. Play the ${target}.';
  @override
  String get flat => 'Flat';
  @override
  String get sharp => 'Sharp';
  @override
  String cents({required Object cents}) => '${cents} cents';
  @override
  String get allTunedTitle => 'Guitar in tune!';
  @override
  String get allTunedMessage => 'All six strings are in place. Time to play!';
  @override
  String peg({required Object string}) => 'Tuning peg of the ${string}';
  @override
  String meterLabel({required Object cents}) => 'Tuning: ${cents} cents';
  @override
  String get activate => 'Enable microphone';
  @override
  String get modeAuto => 'Automatic · tap a peg to lock a string';
  @override
  String modeManual({required Object string}) => 'Locked: ${string}';
  @override
  String get chordsTitle => 'Detect chords';
  @override
  String get switchToChords => 'Detect chords';
  @override
  String get switchToTuner => 'Back to tuner';
}

// Path: practice
class Translations$practice$en extends Translations$practice$es {
  Translations$practice$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Practice chord';
  @override
  String get intro =>
      'Play the strings one by one. I recognize them in any order.';
  @override
  String get start => 'Start practicing';
  @override
  String get stop => 'Stop';
  @override
  String get restart => 'Again';
  @override
  String get listenChord => 'Hear chord';
  @override
  String get listenString => 'Hear string';
  @override
  String progress({required Object count, required Object total}) =>
      '${count} of ${total} strings';
  @override
  String nextOpen({required Object string}) => 'Now play the ${string} open';
  @override
  String nextFretted({
    required Object string,
    required Object fret,
    required Object finger,
  }) => 'Now play the ${string}: fret ${fret} with ${finger}';
  @override
  String nextFrettedAny({required Object string, required Object fret}) =>
      'Now play the ${string}: fret ${fret}';
  @override
  String get muted => 'Muted';
  @override
  String get open => 'Open';
  @override
  String fret({required Object fret}) => 'Fret ${fret}';
  @override
  String get mutedHint => 'Don\'t play this string';
  @override
  String get matched => 'Good';
  @override
  String get doneTitle => 'Clean chord!';
  @override
  String get doneMessage =>
      'Every string sounds as it should. Repeat it slowly until it comes naturally.';
  @override
  String get retune => 'Retune string';
  @override
  String get tipsTitle => 'How to fix it';
  @override
  String fingerThe({required Object n}) => 'finger ${n}';
  @override
  String get fingerAny => 'your finger';
  @override
  String tipSoundsOpen({
    required Object string,
    required Object fret,
    required Object finger,
  }) => 'The ${string} rings open: press fret ${fret} with ${finger}.';
  @override
  String tipMoveUp({required num n, required Object finger}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: 'It sounds lower. Move ${finger} up one fret toward the body.',
        other: 'It sounds lower. Move ${finger} up ${n} frets toward the body.',
      );
  @override
  String tipMoveDown({
    required num n,
    required Object finger,
  }) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
    n,
    one: 'It sounds higher. Move ${finger} down one fret toward the headstock.',
    other:
        'It sounds higher. Move ${finger} down ${n} frets toward the headstock.',
  );
  @override
  String tipTooFlat({required Object finger}) =>
      'It sounds a bit flat. Bring ${finger} closer to the fret (without touching it) or retune the string.';
  @override
  String get tipTooSharp =>
      'It sounds a bit sharp. Press more lightly, without bending the string, or retune it.';
  @override
  String tipRetuneUp({required Object string}) =>
      'The open ${string} sounds flat: tighten the peg a little.';
  @override
  String tipRetuneDown({required Object string}) =>
      'The open ${string} sounds sharp: loosen the peg a little.';
  @override
  String tipUnknown({required Object string}) =>
      'I don\'t recognize that note. Play only the ${string}, calmly.';
}

// Path: profile
class Translations$profile$en extends Translations$profile$es {
  Translations$profile$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Your profile';
  @override
  String get edit => 'Edit profile';
  @override
  String summary({required Object guitar, required Object level}) =>
      '${guitar} · ${level}';
  @override
  String get guitar => 'Guitar';
  @override
  String get play => 'Playing style';
  @override
  String get genres => 'Genres';
  @override
  String get experience => 'Experience';
  @override
  String get personalizedHint => 'Recommendations based on your profile';
  @override
  String get setupHint =>
      'Tell me how you play and I will personalize everything';
}

// Path: minigames
class Translations$minigames$en extends Translations$minigames$es {
  Translations$minigames$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get hubTitle => 'Play';
  @override
  String get hubSubtitle => 'Train your ear, the fretboard and your fingers';
  @override
  String starsTotal({required Object earned, required Object total}) =>
      '${earned} of ${total} stars';
  @override
  String get chordGameTitle => 'Play the chord';
  @override
  String get chordGameSubtitle =>
      'Chain a series of chords using your microphone';
  @override
  String get earTitle => 'Ear training';
  @override
  String get earSubtitle => 'Just listen and recognise: no guitar needed';
  @override
  String get fretboardTitle => 'Fretboard and fingers';
  @override
  String get fretboardSubtitle => 'Learn where every note and finger goes';
  @override
  String get playTitle => 'Play your guitar';
  @override
  String get playSubtitle => 'The microphone checks what you play';
  @override
  String get needsMic => 'Microphone';
  @override
  String get unplayed => 'Not played';
  @override
  String get levelTitle => 'Difficulty';
  @override
  String get levelEasy => 'Easy';
  @override
  String get levelMedium => 'Medium';
  @override
  String get levelHard => 'Hard';
  @override
  String levelBest({required Object percent}) => 'Best: ${percent}%';
  @override
  String get howToPlay => 'How to play';
  @override
  String get earTip => 'Works best with headphones in a quiet place.';
  @override
  String get micTip => 'You need your guitar in tune and the microphone.';
  @override
  String get start => 'Start';
  @override
  String questionOf({required Object n, required Object total}) =>
      'Question ${n} of ${total}';
  @override
  String roundOf({required Object n, required Object total}) =>
      'Round ${n} of ${total}';
  @override
  String get listen => 'Listen';
  @override
  String get listenAgain => 'Listen again';
  @override
  String get listening => 'Listening…';
  @override
  String get streak => 'Streak';
  @override
  String get points => 'Points';
  @override
  String get correct => 'Correct!';
  @override
  String wrong({required Object answer}) => 'It was: ${answer}';
  @override
  String wrongSequence({required Object sequence}) =>
      'The sequence was: ${sequence}';
  @override
  String get next => 'Next';
  @override
  String get seeResult => 'See result';
  @override
  String yourTurn({required Object done, required Object total}) =>
      'Your turn: ${done} of ${total}';
  @override
  String get resultTitle0 => 'Keep practising';
  @override
  String get resultTitle1 => 'Good start';
  @override
  String get resultTitle2 => 'Well done!';
  @override
  String get resultTitle3 => 'Perfect!';
  @override
  String resultCorrect({required Object correct, required Object total}) =>
      '${correct} of ${total} correct';
  @override
  String resultStreak({required Object n}) => 'Best streak: ${n}';
  @override
  String resultPoints({required Object n}) => '${n} points';
  @override
  String get playAgain => 'Play again';
  @override
  String get moreGames => 'More games';
  @override
  String get newBest => 'New record!';
  @override
  String get buildHint => 'Show hint';
  @override
  String get buildCheck => 'Check';
  @override
  String get buildClear => 'Clear all';
  @override
  String get buildPlayIt => 'Now play it';
  @override
  String get buildTapHint =>
      'Tap a cell to place a finger. Tap the marks above to leave a string open or muted.';
  @override
  String get buildWrong => 'Check the strings marked in red.';
  @override
  String get buildCorrect => 'Nicely done!';
  @override
  String get buildCorrectBody =>
      'Now play it on your guitar and hear how it sounds.';
  @override
  String get buildHinted => 'With a hint it does not count as correct.';
  @override
  String get buildMuted => 'Muted';
  @override
  String get buildOpen => 'Open';
  @override
  String buildCell({required Object string, required Object fret}) =>
      'String ${string}, fret ${fret}';
  @override
  String buildMark({required Object string, required Object state}) =>
      'String ${string}: ${state}';
  @override
  String get micListening => 'Play now…';
  @override
  String micHeard({required Object note}) => 'I hear: ${note}';
  @override
  String micProgress({required Object done, required Object total}) =>
      '${done} of ${total} notes';
  @override
  String get micTimeUp => 'Time\'s up';
  @override
  String get micSuccess => 'Well played!';
  @override
  String get micHearIt => 'Hear the note';
  @override
  String get micHearMelody => 'Hear the melody';
  @override
  String get micSkip => 'Skip';
  @override
  String micHintFret({required Object string, required Object fret}) =>
      'Hint: string ${string}, fret ${fret}';
  @override
  String micHintOpen({required Object string}) => 'Hint: string ${string} open';
  @override
  String micSeconds({required Object n}) => '${n} s';
  @override
  late final Translations$minigames$prompt$en prompt =
      Translations$minigames$prompt$en._(_root);
  @override
  Map<String, String> get titles => {
    'guessNote': 'Guess the note',
    'whichString': 'Which string?',
    'whichFret': 'Which fret?',
    'interval': 'Intervals',
    'higherLower': 'Higher or lower',
    'chordQuality': 'Major or minor',
    'nameChord': 'Name the chord',
    'tuneEar': 'Tuner ear',
    'memory': 'String memory',
    'noteAtFret': 'Fretboard notes',
    'fretOfNote': 'Find the note',
    'fingerQuiz': 'Which finger?',
    'readDiagram': 'Read the diagram',
    'buildChord': 'Build the chord',
    'playNote': 'Play the note',
    'playStringFret': 'String and fret',
    'echo': 'Guitar echo',
  };
  @override
  Map<String, String> get descriptions => {
    'guessNote': 'A note plays: which one is it?',
    'whichString': 'Recognise the open string',
    'whichFret': 'Hear how many frets it rises',
    'interval': 'Distance between two notes',
    'higherLower': 'Compare two notes',
    'chordQuality': 'Tell major, minor and seventh apart',
    'nameChord': 'Listen and name the chord',
    'tuneEar': 'Flat, in tune or sharp?',
    'memory': 'Repeat the sequence you hear',
    'noteAtFret': 'Name the note on the fretboard',
    'fretOfNote': 'Find the fret of the note',
    'fingerQuiz': 'Which finger presses each string',
    'readDiagram': 'From the shape to the chord name',
    'buildChord': 'From the name to the position',
    'playNote': 'Play the note you are asked for',
    'playStringFret': 'Play an exact position',
    'echo': 'Listen and play the melody',
  };
  @override
  Map<String, String> get howTo => {
    'guessNote': 'You will hear a single guitar note. Pick its name. Easy has natural notes only; hard has all twelve.',
    'whichString': 'You will hear an open string. Say which one it is, from 6th (the lowest) to 1st (the highest). Easy has only three.',
    'whichFret': 'You will hear the open string and then the same string fretted. Each fret rises one semitone: count how many.',
    'interval': 'You will hear two notes in a row, low to high. Recognise the distance between them: third, fifth, octave…',
    'higherLower': 'You will hear two notes. Say whether the first or the second sounds higher. On hard they are almost the same.',
    'chordQuality': 'You will hear a chord. Tell whether it is major (bright), minor (sad), seventh and more as you level up.',
    'nameChord': 'You will hear a chord from the bank. Pick its name among several similar options.',
    'tuneEar': 'You will hear a reference note and another that may be flat, in tune or sharp. Train your tuner ear.',
    'memory': 'You will hear a sequence of open strings. Tap them in the same order. Each question adds more notes.',
    'noteAtFret': 'You get a string and a fret. Say which note it is. You will learn the fretboard without looking at the guitar.',
    'fretOfNote': 'You get a string and a note. Say which fret it is on (0 is the open string).',
    'fingerQuiz': 'You will see a chord with one string marked and no numbers. Say which finger presses it: 1 index, 2 middle, 3 ring, 4 pinky.',
    'readDiagram':
        'You will see the diagram of a position. Recognise which chord it is.',
    'buildChord': 'You get the name of a chord. Place your fingers on the fretboard and check. Then play it on your guitar.',
    'playNote': 'You are asked for a note. Play it on any string: the microphone recognises it. You can hear the note first.',
    'playStringFret': 'You are asked for an exact string and fret. Press and play: the microphone checks that the right note sounds.',
    'echo': 'You will hear a short melody. Play it on your guitar note by note, in the same order.',
  };
  @override
  Map<String, String> get noteNames => {
    'n0': 'C',
    'n1': 'C♯',
    'n2': 'D',
    'n3': 'D♯',
    'n4': 'E',
    'n5': 'F',
    'n6': 'F♯',
    'n7': 'G',
    'n8': 'G♯',
    'n9': 'A',
    'n10': 'A♯',
    'n11': 'B',
  };
  @override
  Map<String, String> get intervalNames => {
    'i1': 'Minor 2nd',
    'i2': 'Major 2nd',
    'i3': 'Minor 3rd',
    'i4': 'Major 3rd',
    'i5': 'Perfect 4th',
    'i6': 'Tritone',
    'i7': 'Perfect 5th',
    'i8': 'Minor 6th',
    'i9': 'Major 6th',
    'i10': 'Minor 7th',
    'i11': 'Major 7th',
    'i12': 'Octave',
  };
  @override
  late final Translations$minigames$choice$en choice =
      Translations$minigames$choice$en._(_root);
  @override
  String get buildMissed =>
      'That is how it is formed. Memorise it and keep going!';
  @override
  String get micPracticeNote => 'This one doesn\'t score';
  @override
  String get micPlayingMelody => 'Listen to the melody…';
}

// Path: guitar
class Translations$guitar$en extends Translations$guitar$es {
  Translations$guitar$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get ready => 'Play an open string';
  @override
  String get waiting => 'Let the last note fade…';
  @override
  String get noMic =>
      'I can\'t hear you: check the microphone or use the buttons';
  @override
  String openString({required Object string}) => '${string}, open';
  @override
  String get continueLabel => 'Continue';
  @override
  String get retry => 'Retry';
  @override
  String get leave => 'Leave';
  @override
  String get open => 'Open';
  @override
  String get previousGame => 'Previous';
  @override
  String get nextGame => 'Next';
  @override
  String get getReady => 'Get the chord ready';
  @override
  String startsIn({required Object n}) => 'Starting in ${n}';
  @override
  String get imReady => 'Go!';
  @override
  String get setting => 'Control with your guitar';
  @override
  String get settingSubtitle =>
      'Play an open string to continue, retry or leave without touching your phone';
  @override
  String get hubTitle => 'Browse with your guitar';
  @override
  String get hubSubtitle => 'D: next · A: previous · E: open';
}

// Path: settings.theme
class Translations$settings$theme$en extends Translations$settings$theme$es {
  Translations$settings$theme$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Theme';
  @override
  String get system => 'System';
  @override
  String get light => 'Light';
  @override
  String get dark => 'Dark';
  @override
  String get summarySystem => 'Follows the system theme';
  @override
  String get summaryLight => 'Always light';
  @override
  String get summaryDark => 'Always dark';
  @override
  String get valueSystem => 'System theme';
  @override
  String get valueLight => 'Light theme';
  @override
  String get valueDark => 'Dark theme';
}

// Path: settings.color
class Translations$settings$color$en extends Translations$settings$color$es {
  Translations$settings$color$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'App colour';
  @override
  String get dynamicActive => 'System dynamic colour active';
  @override
  String get systemTitle => 'System colour';
  @override
  String get systemSubtitle => 'Uses your device wallpaper';
  @override
  String get systemUnavailable => 'Not available on this platform';
  @override
  String get accentDisabledNote =>
      'The manual accent is disabled while the system colour is active.';
}

// Path: settings.text
class Translations$settings$text$en extends Translations$settings$text$es {
  Translations$settings$text$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Text';
  @override
  String get fontSize => 'Font size';
  @override
  String get preview => 'Preview';
  @override
  String get previewSample => 'C major · barre at fret 3';
}

// Path: settings.language
class Translations$settings$language$en
    extends Translations$settings$language$es {
  Translations$settings$language$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Language';
}

// Path: settings.accent
class Translations$settings$accent$en extends Translations$settings$accent$es {
  Translations$settings$accent$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get violeta => 'Violet';
  @override
  String get azul => 'Blue';
  @override
  String get anil => 'Indigo';
  @override
  String get cian => 'Cyan';
  @override
  String get verde => 'Green';
  @override
  String get lima => 'Lime';
  @override
  String get ambar => 'Amber';
  @override
  String get naranja => 'Orange';
  @override
  String get rojo => 'Red';
  @override
  String get rosa => 'Pink';
}

// Path: settings.fontScale
class Translations$settings$fontScale$en
    extends Translations$settings$fontScale$es {
  Translations$settings$fontScale$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get pequena => 'Small';
  @override
  String get normal => 'Normal';
  @override
  String get grande => 'Large';
  @override
  String get extraGrande => 'Extra large';
}

// Path: data.language
class Translations$data$language$en extends Translations$data$language$es {
  Translations$data$language$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'System language';
  @override
  String get es => 'Spanish';
  @override
  String get en => 'English';
}

// Path: data.genre
class Translations$data$genre$en extends Translations$data$genre$es {
  Translations$data$genre$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get pop => 'Pop';
  @override
  String get rock => 'Rock';
  @override
  String get blues => 'Blues';
  @override
  String get jazz => 'Jazz';
  @override
  String get funk => 'Funk';
  @override
  String get ballad => 'Ballad';
  @override
  String get latin => 'Latin';
  @override
  String get metal => 'Metal';
  @override
  String get rnb => 'R&B';
  @override
  String get soul => 'Soul';
  @override
  String get bossa => 'Bossa';
  @override
  String get country => 'Country';
  @override
  String get kids => 'Kids';
  @override
  String get ambient => 'Ambient';
  @override
  String get classical => 'Classical';
  @override
  String get gospel => 'Gospel';
  @override
  String get punk => 'Punk';
}

// Path: data.quality
class Translations$data$quality$en extends Translations$data$quality$es {
  Translations$data$quality$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get major => 'Major';
  @override
  String get minor => 'Minor';
  @override
  String get seven => 'Dominant seventh';
  @override
  String get minorSeven => 'Minor seventh';
  @override
  String get majorSeven => 'Major seventh';
  @override
  String get suspendedFourth => 'Suspended 4';
  @override
  String get suspendedSecond => 'Suspended 2';
  @override
  String get power => 'Fifth';
  @override
  String get sixth => 'Sixth';
  @override
  String get minorSixth => 'Minor sixth';
  @override
  String get diminished => 'Diminished';
  @override
  String get augmented => 'Augmented';
  @override
  String get ninth => 'Ninth';
}

// Path: data.qualityDescription
class Translations$data$qualityDescription$en
    extends Translations$data$qualityDescription$es {
  Translations$data$qualityDescription$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get major => 'Major triad; the foundation of almost everything.';
  @override
  String get minor => 'Minor triad; sad or intimate colour.';
  @override
  String get seven => 'Blues and funk; tension with a strong resolution.';
  @override
  String get minorSeven => 'Soft and versatile; the backbone of ii-V-I.';
  @override
  String get majorSeven => 'Dreamy pop and jazz colour.';
  @override
  String get suspendedFourth => 'Open suspension; usually resolves to major.';
  @override
  String get suspendedSecond => 'Open and ethereal; common in pop and rock.';
  @override
  String get power => 'Two notes; rock, metal and distortion.';
  @override
  String get sixth => 'Vintage feel; frequent in funk and folk.';
  @override
  String get minorSixth => 'Latin and jazz colour; very expressive.';
  @override
  String get diminished => 'Unstable tension; passing chord.';
  @override
  String get augmented => 'Symmetric and bright; chromatic links.';
  @override
  String get ninth => 'Rich and modern; funk and r&b.';
}

// Path: data.difficulty
class Translations$data$difficulty$en extends Translations$data$difficulty$es {
  Translations$data$difficulty$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get beginner => 'Beginner';
  @override
  String get easy => 'Easy';
  @override
  String get medium => 'Intermediate';
  @override
  String get hard => 'Hard';
  @override
  String get expert => 'Expert';
}

// Path: data.difficultyHint
class Translations$data$difficultyHint$en
    extends Translations$data$difficultyHint$es {
  Translations$data$difficultyHint$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get beginner => 'Open, no barre';
  @override
  String get easy => 'Triads or short shapes';
  @override
  String get medium => 'Full barre';
  @override
  String get hard => 'Big stretch or high barre';
  @override
  String get expert => 'Advanced or jazz voicing';
}

// Path: data.level
class Translations$data$level$en extends Translations$data$level$es {
  Translations$data$level$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get first => 'First chords';
  @override
  String get second => 'Easy sevenths';
  @override
  String get third => 'Barre chords';
  @override
  String get fourth => 'Colour and suspension';
  @override
  String get fifth => 'Jazz and voicings';
}

// Path: data.levelGoal
class Translations$data$levelGoal$en extends Translations$data$levelGoal$es {
  Translations$data$levelGoal$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get first => 'Open major and minor chords';
  @override
  String get second => 'Dominant seventh without barre';
  @override
  String get third => 'Full movable shapes';
  @override
  String get fourth => 'm7, maj7, sus2, sus4, 6';
  @override
  String get fifth => '9, dim, aug and advanced voicings';
}

// Path: data.arpeggio
class Translations$data$arpeggio$en extends Translations$data$arpeggio$es {
  Translations$data$arpeggio$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get ascending => 'Ascending';
  @override
  String get descending => 'Descending';
  @override
  String get alternating => 'Alternating';
  @override
  String get fingerstyle => 'Fingerstyle';
}

// Path: minigames.prompt
class Translations$minigames$prompt$en
    extends Translations$minigames$prompt$es {
  Translations$minigames$prompt$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get guessNote => 'Which note is playing?';
  @override
  String get whichString => 'Which string is playing?';
  @override
  String whichFret({required Object string}) =>
      'You hear ${string} open, then fretted. Which fret?';
  @override
  String get interval => 'Which interval is it?';
  @override
  String get higherLower => 'Which one sounds higher?';
  @override
  String get chordQuality => 'What kind of chord is it?';
  @override
  String get nameChord => 'Which chord is playing?';
  @override
  String get tuneEar => 'Listen to the reference. How is the second note?';
  @override
  String get memory => 'Listen and repeat the string sequence';
  @override
  String noteAtFret({required Object string, required Object fret}) =>
      'Which note is on ${string}, fret ${fret}?';
  @override
  String fretOfNote({required Object string, required Object note}) =>
      'Which fret of ${string} has ${note}?';
  @override
  String fingerQuiz({required Object string}) =>
      'Which finger presses ${string}?';
  @override
  String get readDiagram => 'Which chord is this?';
  @override
  String buildChord({required Object chord}) => 'Form the chord ${chord}';
  @override
  String playNote({required Object note}) => 'Play the note ${note}';
  @override
  String playStringFret({required Object string, required Object fret}) =>
      'Play ${string} at fret ${fret}';
  @override
  String get echo => 'Listen and play the melody';
  @override
  String noteAtOpen({required Object string}) =>
      'Which note is ${string} open?';
  @override
  String playStringOpen({required Object string}) => 'Play ${string} open';
}

// Path: minigames.choice
class Translations$minigames$choice$en
    extends Translations$minigames$choice$es {
  Translations$minigames$choice$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String fret({required Object n}) => 'Fret ${n}';
  @override
  String get fretOpen => 'Open';
  @override
  String get finger1 => '1 · Index';
  @override
  String get finger2 => '2 · Middle';
  @override
  String get finger3 => '3 · Ring';
  @override
  String get finger4 => '4 · Pinky';
  @override
  String get first => 'The first';
  @override
  String get second => 'The second';
  @override
  String get flat => 'Flat (lower)';
  @override
  String get inTune => 'In tune';
  @override
  String get sharp => 'Sharp (higher)';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
          'app.title' => 'Chords',
          'app.chordFallback' => 'Chord',
          'app.skip' => 'Skip',
          'app.next' => 'Next',
          'app.start' => 'Start',
          'nav.home' => 'Home',
          'nav.learn' => 'Learn',
          'nav.chords' => 'Chords',
          'nav.game' => 'Play',
          'nav.live' => 'Tune',
          'nav.settings' => 'Settings',
          'home.greeting' => 'Hello, guitarist',
          'home.question' => 'What are you playing today?',
          'home.progressTitle' => 'Itinerary progress',
          'home.masteredCount' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('en'))(
                  n,
                  one: '${n} chord mastered',
                  other: '${n} chords mastered',
                ),
          'home.continueLearning' => 'Keep learning',
          'home.itineraryComplete' => 'Itinerary complete!',
          'home.nextChord' => ({required Object name}) => 'Next: ${name}',
          'home.library' => 'Chord library',
          'home.librarySubtitle' => ({
            required Object count,
          }) => '${count} chords by genre and level',
          'home.gameMode' => 'Mini-games',
          'home.gameSubtitle' => ({
            required Object count,
          }) => '${count} games for ear, fretboard and fingers',
          'home.liveTitle' => 'Tuner and listening',
          'home.liveSubtitle' => 'Tune string by string with your microphone',
          'home.greetingMorning' => 'Good morning',
          'home.greetingAfternoon' => 'Good afternoon',
          'home.greetingEvening' => 'Good evening',
          'home.nextUp' => 'Your next chord',
          'home.practiceCta' => 'Practice',
          'home.statMastered' => 'Mastered',
          'home.statBest' => 'Best score',
          'home.statLevel' => 'Level',
          'home.recommendedTitle' => 'For you',
          'home.recommendedEmpty' =>
            'Complete your profile to see recommendations.',
          'home.toolsTitle' => 'Tools',
          'home.seeAll' => 'See all',
          'home.learnSubtitle' => 'Your step-by-step path',
          'chords.title' => 'Chords',
          'chords.clearFilters' => 'Clear filters',
          'chords.searchHint' => 'Search chords',
          'chords.filterAll' => 'All',
          'chords.filterAllQualities' => 'All',
          'chords.positionCount' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('en'))(
                  n,
                  one: '${n} position',
                  other: '${n} positions',
                ),
          'chords.levelShort' => ({required Object level}) => 'Lv ${level}',
          'chords.maxDifficulty' => ({
            required Object level,
          }) => 'Max difficulty: ${level}',
          'chords.loading' => 'Loading chords…',
          'chords.loadErrorTitle' => 'Could not load the chord bank',
          'chords.loadErrorMessage' =>
            'Restart the app to try loading the bank again.',
          'chords.emptyTitle' => 'No results',
          'chords.emptyMessage' =>
            'Adjust the search or the filters to see more chords.',
          'chords.filters' => 'Filters',
          'chords.filterLevel' => 'Level',
          'chords.filterQuality' => 'Chord type',
          'chords.filterDifficulty' => 'Max difficulty',
          'chords.forMyLevel' => 'For my level',
          'chords.apply' => 'Show results',
          'chords.reset' => 'Reset',
          'chords.results' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('en'))(
                  n,
                  one: '${n} chord',
                  other: '${n} chords',
                ),
          'chordDetail.titleFallback' => 'Chord',
          'chordDetail.markMastered' => 'Mark as mastered',
          'chordDetail.unmarkMastered' => 'Remove from mastered',
          'chordDetail.leftHandMode' => 'Left-handed mode',
          'chordDetail.leftHandModeOff' => 'Disable left-handed mode',
          'chordDetail.loading' => 'Loading chord…',
          'chordDetail.errorTitle' => 'Chord unavailable',
          'chordDetail.notFoundMessage' => ({
            required Object chordId,
          }) => 'Chord ${chordId} not found',
          'chordDetail.loadFailed' => 'The chord bank could not be read.',
          'chordDetail.noChordTitle' => 'No chord selected',
          'chordDetail.noChordMessage' =>
            'Go back to the list and pick a chord.',
          'chordDetail.listen' => 'Listen to chord',
          'chordDetail.listenPosition' => ({
            required Object position,
          }) => 'Listen to ${position}',
          'chordDetail.arpeggios' => 'Arpeggios',
          'chordDetail.positions' => 'Positions',
          'chordDetail.notes' => ({required Object notes}) => 'Notes: ${notes}',
          'chordDetail.arpeggioChip' => ({
            required Object label,
            required Object level,
          }) => '${label} · Lv ${level}',
          'chordDetail.practice' => 'Practice',
          'chordDetail.guideTitle' => 'How to place it',
          'chordDetail.guideLegend' => '1 index · 2 middle · 3 ring · 4 pinky',
          'chordDetail.guideFinger' => ({
            required Object fret,
            required Object string,
          }) => 'Fret ${fret} · string ${string}',
          'chordDetail.guideBarre' => ({
            required Object fret,
            required Object from,
            required Object to,
          }) => 'Barre at fret ${fret} · string ${from} to ${to}',
          'chordDetail.guidePlay' => ({
            required Object strings,
          }) => 'Play: ${strings}',
          'chordDetail.guideOpen' => ({
            required Object strings,
          }) => 'Open: ${strings}',
          'chordDetail.guideMuted' => ({
            required Object strings,
          }) => 'Don\'t play: ${strings}',
          'chordDetail.guideOpenPosition' => 'Open position, next to the nut',
          'chordDetail.guideRange' => ({
            required Object from,
            required Object to,
          }) => 'Around frets ${from} to ${to}',
          'chordDetail.guideSingleFret' => ({
            required Object fret,
          }) => 'Around fret ${fret}',
          'chordDetail.recommended' => 'Start here',
          'chordDetail.fingerNames.f1' => 'Index',
          'chordDetail.fingerNames.f2' => 'Middle',
          'chordDetail.fingerNames.f3' => 'Ring',
          'chordDetail.fingerNames.f4' => 'Pinky',
          'game.title' => 'Play',
          'game.start' => 'Start streak',
          'game.emptyTitle' => 'Play the chord',
          'game.emptyMessage' => ({
            required Object best,
          }) => 'Chain a series of chords with the microphone. Best: ${best} points.',
          'game.round' => ({required Object number}) => 'Round ${number}',
          'game.playThisChord' => 'Play this chord',
          'game.loadingChord' => 'Loading chord…',
          'game.listening' => 'Listening to your guitar…',
          'game.correctNext' => 'Correct! Next',
          'game.retry' => 'Try again',
          'game.ready' => 'I\'m ready',
          'game.streak' => 'Streak',
          'game.score' => 'Score',
          'game.feedbackProgress' => ({
            required Object hit,
            required Object total,
          }) => 'Going well! ${hit} of ${total} notes',
          'game.feedbackMissing' => ({
            required Object notes,
          }) => 'Missing: ${notes}',
          'game.feedbackExtra' => ({
            required Object notes,
          }) => 'Extra notes: ${notes}',
          'game.feedbackComplete' => 'Chord complete!',
          'game.almostNext' => 'Almost! Next',
          'game.stringFirst' => '1st',
          'game.stringSecond' => '2nd',
          'game.stringThird' => '3rd',
          'game.stringFourth' => '4th',
          'game.stringFifth' => '5th',
          'game.stringSixth' => '6th',
          'game.practiceChord' => 'Practice string by string',
          'game.finishedTitle' => 'Series complete!',
          'game.finishedMessage' => ({
            required Object won,
            required Object total,
            required Object score,
          }) => '${won} of ${total} chords · ${score} points',
          'game.finishedBest' => ({
            required Object best,
          }) => 'Your best: ${best} points',
          'chordDiagram.stringLabel' => ({
            required Object number,
            required Object fret,
          }) => 'string ${number}: ${fret}',
          'chordDiagram.muted' => 'muted',
          'chordDiagram.open' => 'open',
          'chordDiagram.fret' => ({required Object value}) => 'fret ${value}',
          'chordDiagram.description' => ({
            required Object position,
            required Object details,
          }) => 'Diagram of ${position}, ${details}',
          'live.title' => 'Tuner',
          'live.emptyTitle' => 'No suggestions yet',
          'live.emptyMessage' =>
            'Press listen and play a chord to see matches.',
          'live.suggestions' => 'Suggestions',
          'live.idleTitle' => 'Microphone idle',
          'live.idleMessage' => 'Play a note on the guitar',
          'live.listening' => 'Listening…',
          'live.deniedTitle' => 'Permission denied',
          'live.errorTitle' => 'Capture error',
          'learn.title' => 'Learn',
          'learn.loading' => 'Preparing levels…',
          'learn.errorTitle' => 'Could not load the itinerary',
          'learn.errorMessage' => 'Restart the app to try again.',
          'learn.yourProgress' => 'Your progress',
          'learn.masteredCount' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('en'))(
                  n,
                  one: '${n} chord mastered',
                  other: '${n} chords mastered',
                ),
          'learn.stepByStep' => 'Step by step',
          'learn.stepFingers' =>
            'Place your fingers one by one on the fretboard',
          'learn.stepStrum' => 'Slow strum: listen to every string',
          'learn.stepChange' =>
            'Move to the next chord without stopping the rhythm',
          'learn.guidedArpeggios' => 'Guided arpeggios',
          'learn.levelSection' => ({
            required Object emoji,
            required Object level,
            required Object title,
          }) => '${emoji}  Level ${level}: ${title}',
          'learn.arpeggioHint' => ({
            required Object label,
          }) => 'Open the chord and play its ${label} arpeggio',
          'settings.title' => 'Settings',
          'settings.appearance' => 'Appearance',
          'settings.theme.title' => 'Theme',
          'settings.theme.system' => 'System',
          'settings.theme.light' => 'Light',
          'settings.theme.dark' => 'Dark',
          'settings.theme.summarySystem' => 'Follows the system theme',
          'settings.theme.summaryLight' => 'Always light',
          'settings.theme.summaryDark' => 'Always dark',
          'settings.theme.valueSystem' => 'System theme',
          'settings.theme.valueLight' => 'Light theme',
          'settings.theme.valueDark' => 'Dark theme',
          'settings.color.title' => 'App colour',
          'settings.color.dynamicActive' => 'System dynamic colour active',
          'settings.color.systemTitle' => 'System colour',
          'settings.color.systemSubtitle' => 'Uses your device wallpaper',
          'settings.color.systemUnavailable' =>
            'Not available on this platform',
          'settings.color.accentDisabledNote' =>
            'The manual accent is disabled while the system colour is active.',
          'settings.text.title' => 'Text',
          'settings.text.fontSize' => 'Font size',
          'settings.text.preview' => 'Preview',
          'settings.text.previewSample' => 'C major · barre at fret 3',
          'settings.language.title' => 'Language',
          'settings.accent.violeta' => 'Violet',
          'settings.accent.azul' => 'Blue',
          'settings.accent.anil' => 'Indigo',
          'settings.accent.cian' => 'Cyan',
          'settings.accent.verde' => 'Green',
          'settings.accent.lima' => 'Lime',
          'settings.accent.ambar' => 'Amber',
          'settings.accent.naranja' => 'Orange',
          'settings.accent.rojo' => 'Red',
          'settings.accent.rosa' => 'Pink',
          'settings.fontScale.pequena' => 'Small',
          'settings.fontScale.normal' => 'Normal',
          'settings.fontScale.grande' => 'Large',
          'settings.fontScale.extraGrande' => 'Extra large',
          'settings.guitar' => 'Guitar',
          'settings.leftHandMode' => 'Left-handed mode',
          'settings.leftHandModeSubtitle' => 'Mirrors the chord diagrams',
          'settings.sound' => 'Sound',
          'settings.chordSound' => 'Chord sound',
          'settings.chordSoundSubtitle' => 'Synthesizes strums and arpeggios',
          'settings.learning' => 'Learning',
          'settings.resetOnboarding' => 'Reset onboarding',
          'settings.resetOnboardingSubtitle' => 'Show the introduction again',
          'settings.onboardingReset' => 'Onboarding reset',
          'settings.version' => 'Version',
          'settings.cli' => 'Development CLI',
          'settings.cliCommand' => 'dart run bin/chords_cli.dart db generate',
          'onboarding.slideOneTitle' => 'Every chord, every position',
          'onboarding.slideOneBody' => '156 chords and 561 verified positions, from the essential open shapes to jazz voicings.',
          'onboarding.slideTwoTitle' =>
            'Listen to every chord and its arpeggio',
          'onboarding.slideTwoBody' => 'We synthesize each string so you can recognise the sound before playing.',
          'onboarding.slideThreeTitle' => 'Learn by levels and practise',
          'onboarding.slideThreeBody' => 'Step-by-step itinerary, genre filter and game mode to chain chord streaks.',
          'onboarding.welcomeTitle' => 'Your guitar, made to measure',
          'onboarding.welcomeBody' => 'Five quick questions and I will recommend the chords that suit you best.',
          'onboarding.welcomeCta' => 'Get started',
          'onboarding.stepOf' => ({
            required Object current,
            required Object total,
          }) => 'Step ${current} of ${total}',
          'onboarding.back' => 'Back',
          'onboarding.proceed' => 'Continue',
          'onboarding.finish' => 'Start playing',
          'onboarding.guitarTitle' => 'Which guitar do you play?',
          'onboarding.guitarBody' => 'Each one calls for different chords.',
          'onboarding.guitarAcoustic' => 'Acoustic',
          'onboarding.guitarAcousticHint' => 'Steel strings and open chords',
          'onboarding.guitarElectric' => 'Electric',
          'onboarding.guitarElectricHint' => 'Power chords and riffs',
          'onboarding.guitarClassical' => 'Classical',
          'onboarding.guitarClassicalHint' => 'Nylon strings and fingers',
          'onboarding.playTitle' => 'How do you play it?',
          'onboarding.playBody' =>
            'I adapt the diagrams and arpeggios to your playing.',
          'onboarding.handLabel' => 'Your hand',
          'onboarding.handRight' => 'Right-handed',
          'onboarding.handRightHint' => 'Regular diagrams',
          'onboarding.handLeft' => 'Left-handed',
          'onboarding.handLeftHint' => 'Mirrored diagrams',
          'onboarding.styleLabel' => 'How you pluck the strings',
          'onboarding.stylePick' => 'Pick',
          'onboarding.styleFingers' => 'Fingers',
          'onboarding.styleBoth' => 'Both',
          'onboarding.genresTitle' => 'What music do you like?',
          'onboarding.genresBody' =>
            'Pick as many as you like: I recommend chords from those styles.',
          'onboarding.levelTitle' => 'How much experience do you have?',
          'onboarding.levelBody' =>
            'I tune the difficulty so you progress without frustration.',
          'onboarding.levelBeginner' => 'I\'m just starting',
          'onboarding.levelBeginnerHint' => 'Open chords, no barre',
          'onboarding.levelIntermediate' => 'I already play songs',
          'onboarding.levelIntermediateHint' =>
            'Chord changes and basic barres',
          'onboarding.levelAdvanced' => 'I play fluently',
          'onboarding.levelAdvancedHint' => 'Barres, sevenths and voicings',
          'onboarding.planTitle' => 'Your plan is ready',
          'onboarding.planBody' => 'Start with these chords, picked for you.',
          'onboarding.planEmpty' =>
            'Explore the library and start with the one you like most.',
          'data.language.system' => 'System language',
          'data.language.es' => 'Spanish',
          'data.language.en' => 'English',
          'data.genre.pop' => 'Pop',
          'data.genre.rock' => 'Rock',
          'data.genre.blues' => 'Blues',
          'data.genre.jazz' => 'Jazz',
          'data.genre.funk' => 'Funk',
          'data.genre.ballad' => 'Ballad',
          'data.genre.latin' => 'Latin',
          'data.genre.metal' => 'Metal',
          'data.genre.rnb' => 'R&B',
          'data.genre.soul' => 'Soul',
          'data.genre.bossa' => 'Bossa',
          'data.genre.country' => 'Country',
          'data.genre.kids' => 'Kids',
          'data.genre.ambient' => 'Ambient',
          'data.genre.classical' => 'Classical',
          'data.genre.gospel' => 'Gospel',
          'data.genre.punk' => 'Punk',
          'data.quality.major' => 'Major',
          'data.quality.minor' => 'Minor',
          'data.quality.seven' => 'Dominant seventh',
          'data.quality.minorSeven' => 'Minor seventh',
          'data.quality.majorSeven' => 'Major seventh',
          'data.quality.suspendedFourth' => 'Suspended 4',
          'data.quality.suspendedSecond' => 'Suspended 2',
          'data.quality.power' => 'Fifth',
          'data.quality.sixth' => 'Sixth',
          'data.quality.minorSixth' => 'Minor sixth',
          'data.quality.diminished' => 'Diminished',
          'data.quality.augmented' => 'Augmented',
          'data.quality.ninth' => 'Ninth',
          'data.qualityDescription.major' =>
            'Major triad; the foundation of almost everything.',
          'data.qualityDescription.minor' =>
            'Minor triad; sad or intimate colour.',
          'data.qualityDescription.seven' =>
            'Blues and funk; tension with a strong resolution.',
          'data.qualityDescription.minorSeven' =>
            'Soft and versatile; the backbone of ii-V-I.',
          'data.qualityDescription.majorSeven' => 'Dreamy pop and jazz colour.',
          'data.qualityDescription.suspendedFourth' =>
            'Open suspension; usually resolves to major.',
          'data.qualityDescription.suspendedSecond' =>
            'Open and ethereal; common in pop and rock.',
          'data.qualityDescription.power' =>
            'Two notes; rock, metal and distortion.',
          'data.qualityDescription.sixth' =>
            'Vintage feel; frequent in funk and folk.',
          'data.qualityDescription.minorSixth' =>
            'Latin and jazz colour; very expressive.',
          'data.qualityDescription.diminished' =>
            'Unstable tension; passing chord.',
          'data.qualityDescription.augmented' =>
            'Symmetric and bright; chromatic links.',
          'data.qualityDescription.ninth' => 'Rich and modern; funk and r&b.',
          'data.difficulty.beginner' => 'Beginner',
          'data.difficulty.easy' => 'Easy',
          'data.difficulty.medium' => 'Intermediate',
          'data.difficulty.hard' => 'Hard',
          'data.difficulty.expert' => 'Expert',
          'data.difficultyHint.beginner' => 'Open, no barre',
          'data.difficultyHint.easy' => 'Triads or short shapes',
          'data.difficultyHint.medium' => 'Full barre',
          'data.difficultyHint.hard' => 'Big stretch or high barre',
          'data.difficultyHint.expert' => 'Advanced or jazz voicing',
          'data.level.first' => 'First chords',
          'data.level.second' => 'Easy sevenths',
          'data.level.third' => 'Barre chords',
          'data.level.fourth' => 'Colour and suspension',
          'data.level.fifth' => 'Jazz and voicings',
          'data.levelGoal.first' => 'Open major and minor chords',
          'data.levelGoal.second' => 'Dominant seventh without barre',
          'data.levelGoal.third' => 'Full movable shapes',
          'data.levelGoal.fourth' => 'm7, maj7, sus2, sus4, 6',
          'data.levelGoal.fifth' => '9, dim, aug and advanced voicings',
          'data.arpeggio.ascending' => 'Ascending',
          'data.arpeggio.descending' => 'Descending',
          'data.arpeggio.alternating' => 'Alternating',
          'data.arpeggio.fingerstyle' => 'Fingerstyle',
          'logs.title' => 'Diagnostics',
          'logs.clear' => 'Clear log',
          'logs.total' => 'Total',
          'logs.errors' => 'Errors',
          'logs.warnings' => 'Warnings',
          'logs.allLevels' => 'All',
          'logs.empty' => 'No events recorded',
          'router.notFound' => 'Route not found',
          'router.goHome' => 'Go to home',
          'mic.deniedTitle' => 'I need your microphone',
          'mic.deniedMessage' =>
            'Allow microphone access in your phone settings and try again.',
          'mic.errorTitle' => 'I couldn\'t listen',
          'mic.errorMessage' => 'Something went wrong opening the microphone. Check that no other app is using it.',
          'mic.retry' => 'Try again',
          'mic.levelLabel' => 'Microphone level',
          'mic.levelWaiting' => 'Waiting for sound…',
          'mic.levelQuiet' =>
            'I can barely hear you: bring the guitar closer to the microphone',
          'mic.levelGood' => 'I can hear you well',
          'mic.levelLoud' => 'Too loud: move the guitar a little farther away',
          'tuner.pluckPrompt' => 'Play an open string',
          'tuner.pluckString' => ({
            required Object string,
          }) => 'Play the ${string}',
          'tuner.stringTitle' => ({
            required Object ordinal,
            required Object note,
          }) => '${ordinal} string · ${note}',
          'tuner.noteE' => 'E',
          'tuner.noteA' => 'A',
          'tuner.noteD' => 'D',
          'tuner.noteG' => 'G',
          'tuner.noteB' => 'B',
          'tuner.tuned' => 'In tune!',
          'tuner.upLittle' => 'Tune up a little',
          'tuner.up' => 'Tune up',
          'tuner.upALot' => 'Tune up a lot',
          'tuner.downLittle' => 'Tune down a little',
          'tuner.down' => 'Tune down',
          'tuner.downALot' => 'Tune down a lot',
          'tuner.tightenPeg' => 'Tighten the peg',
          'tuner.loosenPeg' => 'Loosen the peg',
          'tuner.holdSteady' => 'Let the note ring',
          'tuner.heardOther' => ({
            required Object heard,
            required Object target,
          }) => 'That sounds like the ${heard}. Play the ${target}.',
          'tuner.flat' => 'Flat',
          'tuner.sharp' => 'Sharp',
          'tuner.cents' => ({required Object cents}) => '${cents} cents',
          'tuner.allTunedTitle' => 'Guitar in tune!',
          'tuner.allTunedMessage' =>
            'All six strings are in place. Time to play!',
          'tuner.peg' => ({
            required Object string,
          }) => 'Tuning peg of the ${string}',
          'tuner.meterLabel' => ({
            required Object cents,
          }) => 'Tuning: ${cents} cents',
          'tuner.activate' => 'Enable microphone',
          'tuner.modeAuto' => 'Automatic · tap a peg to lock a string',
          'tuner.modeManual' => ({
            required Object string,
          }) => 'Locked: ${string}',
          'tuner.chordsTitle' => 'Detect chords',
          'tuner.switchToChords' => 'Detect chords',
          'tuner.switchToTuner' => 'Back to tuner',
          'practice.title' => 'Practice chord',
          'practice.intro' =>
            'Play the strings one by one. I recognize them in any order.',
          'practice.start' => 'Start practicing',
          'practice.stop' => 'Stop',
          'practice.restart' => 'Again',
          'practice.listenChord' => 'Hear chord',
          'practice.listenString' => 'Hear string',
          'practice.progress' => ({
            required Object count,
            required Object total,
          }) => '${count} of ${total} strings',
          'practice.nextOpen' => ({
            required Object string,
          }) => 'Now play the ${string} open',
          'practice.nextFretted' => ({
            required Object string,
            required Object fret,
            required Object finger,
          }) => 'Now play the ${string}: fret ${fret} with ${finger}',
          'practice.nextFrettedAny' => ({
            required Object string,
            required Object fret,
          }) => 'Now play the ${string}: fret ${fret}',
          'practice.muted' => 'Muted',
          'practice.open' => 'Open',
          'practice.fret' => ({required Object fret}) => 'Fret ${fret}',
          'practice.mutedHint' => 'Don\'t play this string',
          'practice.matched' => 'Good',
          'practice.doneTitle' => 'Clean chord!',
          'practice.doneMessage' => 'Every string sounds as it should. Repeat it slowly until it comes naturally.',
          'practice.retune' => 'Retune string',
          'practice.tipsTitle' => 'How to fix it',
          'practice.fingerThe' => ({required Object n}) => 'finger ${n}',
          'practice.fingerAny' => 'your finger',
          'practice.tipSoundsOpen' => ({
            required Object string,
            required Object fret,
            required Object finger,
          }) => 'The ${string} rings open: press fret ${fret} with ${finger}.',
          'practice.tipMoveUp' =>
            ({
              required num n,
              required Object finger,
            }) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
              n,
              one:
                  'It sounds lower. Move ${finger} up one fret toward the body.',
              other:
                  'It sounds lower. Move ${finger} up ${n} frets toward the body.',
            ),
          'practice.tipMoveDown' =>
            ({
              required num n,
              required Object finger,
            }) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
              n,
              one:
                  'It sounds higher. Move ${finger} down one fret toward the headstock.',
              other:
                  'It sounds higher. Move ${finger} down ${n} frets toward the headstock.',
            ),
          'practice.tipTooFlat' => ({
            required Object finger,
          }) => 'It sounds a bit flat. Bring ${finger} closer to the fret (without touching it) or retune the string.',
          'practice.tipTooSharp' => 'It sounds a bit sharp. Press more lightly, without bending the string, or retune it.',
          'practice.tipRetuneUp' => ({
            required Object string,
          }) => 'The open ${string} sounds flat: tighten the peg a little.',
          'practice.tipRetuneDown' => ({
            required Object string,
          }) => 'The open ${string} sounds sharp: loosen the peg a little.',
          'practice.tipUnknown' => ({
            required Object string,
          }) => 'I don\'t recognize that note. Play only the ${string}, calmly.',
          'profile.title' => 'Your profile',
          'profile.edit' => 'Edit profile',
          'profile.summary' => ({
            required Object guitar,
            required Object level,
          }) => '${guitar} · ${level}',
          'profile.guitar' => 'Guitar',
          'profile.play' => 'Playing style',
          'profile.genres' => 'Genres',
          'profile.experience' => 'Experience',
          'profile.personalizedHint' => 'Recommendations based on your profile',
          'profile.setupHint' =>
            'Tell me how you play and I will personalize everything',
          'minigames.hubTitle' => 'Play',
          'minigames.hubSubtitle' =>
            'Train your ear, the fretboard and your fingers',
          'minigames.starsTotal' => ({
            required Object earned,
            required Object total,
          }) => '${earned} of ${total} stars',
          'minigames.chordGameTitle' => 'Play the chord',
          'minigames.chordGameSubtitle' =>
            'Chain a series of chords using your microphone',
          'minigames.earTitle' => 'Ear training',
          'minigames.earSubtitle' =>
            'Just listen and recognise: no guitar needed',
          'minigames.fretboardTitle' => 'Fretboard and fingers',
          'minigames.fretboardSubtitle' =>
            'Learn where every note and finger goes',
          'minigames.playTitle' => 'Play your guitar',
          'minigames.playSubtitle' => 'The microphone checks what you play',
          'minigames.needsMic' => 'Microphone',
          'minigames.unplayed' => 'Not played',
          'minigames.levelTitle' => 'Difficulty',
          'minigames.levelEasy' => 'Easy',
          'minigames.levelMedium' => 'Medium',
          'minigames.levelHard' => 'Hard',
          'minigames.levelBest' => ({
            required Object percent,
          }) => 'Best: ${percent}%',
          'minigames.howToPlay' => 'How to play',
          'minigames.earTip' => 'Works best with headphones in a quiet place.',
          'minigames.micTip' =>
            'You need your guitar in tune and the microphone.',
          'minigames.start' => 'Start',
          'minigames.questionOf' => ({
            required Object n,
            required Object total,
          }) => 'Question ${n} of ${total}',
          'minigames.roundOf' => ({
            required Object n,
            required Object total,
          }) => 'Round ${n} of ${total}',
          'minigames.listen' => 'Listen',
          'minigames.listenAgain' => 'Listen again',
          'minigames.listening' => 'Listening…',
          'minigames.streak' => 'Streak',
          'minigames.points' => 'Points',
          'minigames.correct' => 'Correct!',
          'minigames.wrong' => ({
            required Object answer,
          }) => 'It was: ${answer}',
          'minigames.wrongSequence' => ({
            required Object sequence,
          }) => 'The sequence was: ${sequence}',
          'minigames.next' => 'Next',
          'minigames.seeResult' => 'See result',
          'minigames.yourTurn' => ({
            required Object done,
            required Object total,
          }) => 'Your turn: ${done} of ${total}',
          'minigames.resultTitle0' => 'Keep practising',
          'minigames.resultTitle1' => 'Good start',
          'minigames.resultTitle2' => 'Well done!',
          'minigames.resultTitle3' => 'Perfect!',
          'minigames.resultCorrect' => ({
            required Object correct,
            required Object total,
          }) => '${correct} of ${total} correct',
          'minigames.resultStreak' => ({
            required Object n,
          }) => 'Best streak: ${n}',
          'minigames.resultPoints' => ({required Object n}) => '${n} points',
          'minigames.playAgain' => 'Play again',
          'minigames.moreGames' => 'More games',
          'minigames.newBest' => 'New record!',
          'minigames.buildHint' => 'Show hint',
          'minigames.buildCheck' => 'Check',
          'minigames.buildClear' => 'Clear all',
          'minigames.buildPlayIt' => 'Now play it',
          'minigames.buildTapHint' => 'Tap a cell to place a finger. Tap the marks above to leave a string open or muted.',
          'minigames.buildWrong' => 'Check the strings marked in red.',
          'minigames.buildCorrect' => 'Nicely done!',
          'minigames.buildCorrectBody' =>
            'Now play it on your guitar and hear how it sounds.',
          'minigames.buildHinted' =>
            'With a hint it does not count as correct.',
          'minigames.buildMuted' => 'Muted',
          'minigames.buildOpen' => 'Open',
          'minigames.buildCell' => ({
            required Object string,
            required Object fret,
          }) => 'String ${string}, fret ${fret}',
          'minigames.buildMark' => ({
            required Object string,
            required Object state,
          }) => 'String ${string}: ${state}',
          'minigames.micListening' => 'Play now…',
          'minigames.micHeard' => ({required Object note}) => 'I hear: ${note}',
          'minigames.micProgress' => ({
            required Object done,
            required Object total,
          }) => '${done} of ${total} notes',
          'minigames.micTimeUp' => 'Time\'s up',
          'minigames.micSuccess' => 'Well played!',
          'minigames.micHearIt' => 'Hear the note',
          'minigames.micHearMelody' => 'Hear the melody',
          'minigames.micSkip' => 'Skip',
          'minigames.micHintFret' => ({
            required Object string,
            required Object fret,
          }) => 'Hint: string ${string}, fret ${fret}',
          'minigames.micHintOpen' => ({
            required Object string,
          }) => 'Hint: string ${string} open',
          'minigames.micSeconds' => ({required Object n}) => '${n} s',
          'minigames.prompt.guessNote' => 'Which note is playing?',
          'minigames.prompt.whichString' => 'Which string is playing?',
          'minigames.prompt.whichFret' => ({
            required Object string,
          }) => 'You hear ${string} open, then fretted. Which fret?',
          'minigames.prompt.interval' => 'Which interval is it?',
          'minigames.prompt.higherLower' => 'Which one sounds higher?',
          'minigames.prompt.chordQuality' => 'What kind of chord is it?',
          'minigames.prompt.nameChord' => 'Which chord is playing?',
          'minigames.prompt.tuneEar' =>
            'Listen to the reference. How is the second note?',
          'minigames.prompt.memory' => 'Listen and repeat the string sequence',
          'minigames.prompt.noteAtFret' => ({
            required Object string,
            required Object fret,
          }) => 'Which note is on ${string}, fret ${fret}?',
          'minigames.prompt.fretOfNote' => ({
            required Object string,
            required Object note,
          }) => 'Which fret of ${string} has ${note}?',
          'minigames.prompt.fingerQuiz' => ({
            required Object string,
          }) => 'Which finger presses ${string}?',
          'minigames.prompt.readDiagram' => 'Which chord is this?',
          'minigames.prompt.buildChord' => ({
            required Object chord,
          }) => 'Form the chord ${chord}',
          'minigames.prompt.playNote' => ({
            required Object note,
          }) => 'Play the note ${note}',
          'minigames.prompt.playStringFret' => ({
            required Object string,
            required Object fret,
          }) => 'Play ${string} at fret ${fret}',
          'minigames.prompt.echo' => 'Listen and play the melody',
          'minigames.prompt.noteAtOpen' => ({
            required Object string,
          }) => 'Which note is ${string} open?',
          'minigames.prompt.playStringOpen' => ({
            required Object string,
          }) => 'Play ${string} open',
          'minigames.titles.guessNote' => 'Guess the note',
          'minigames.titles.whichString' => 'Which string?',
          'minigames.titles.whichFret' => 'Which fret?',
          'minigames.titles.interval' => 'Intervals',
          'minigames.titles.higherLower' => 'Higher or lower',
          'minigames.titles.chordQuality' => 'Major or minor',
          'minigames.titles.nameChord' => 'Name the chord',
          'minigames.titles.tuneEar' => 'Tuner ear',
          'minigames.titles.memory' => 'String memory',
          'minigames.titles.noteAtFret' => 'Fretboard notes',
          'minigames.titles.fretOfNote' => 'Find the note',
          'minigames.titles.fingerQuiz' => 'Which finger?',
          'minigames.titles.readDiagram' => 'Read the diagram',
          'minigames.titles.buildChord' => 'Build the chord',
          'minigames.titles.playNote' => 'Play the note',
          'minigames.titles.playStringFret' => 'String and fret',
          'minigames.titles.echo' => 'Guitar echo',
          'minigames.descriptions.guessNote' =>
            'A note plays: which one is it?',
          'minigames.descriptions.whichString' => 'Recognise the open string',
          'minigames.descriptions.whichFret' => 'Hear how many frets it rises',
          'minigames.descriptions.interval' => 'Distance between two notes',
          'minigames.descriptions.higherLower' => 'Compare two notes',
          'minigames.descriptions.chordQuality' =>
            'Tell major, minor and seventh apart',
          _ => null,
        } ??
        switch (path) {
          'minigames.descriptions.nameChord' => 'Listen and name the chord',
          'minigames.descriptions.tuneEar' => 'Flat, in tune or sharp?',
          'minigames.descriptions.memory' => 'Repeat the sequence you hear',
          'minigames.descriptions.noteAtFret' =>
            'Name the note on the fretboard',
          'minigames.descriptions.fretOfNote' => 'Find the fret of the note',
          'minigames.descriptions.fingerQuiz' =>
            'Which finger presses each string',
          'minigames.descriptions.readDiagram' =>
            'From the shape to the chord name',
          'minigames.descriptions.buildChord' =>
            'From the name to the position',
          'minigames.descriptions.playNote' =>
            'Play the note you are asked for',
          'minigames.descriptions.playStringFret' => 'Play an exact position',
          'minigames.descriptions.echo' => 'Listen and play the melody',
          'minigames.howTo.guessNote' => 'You will hear a single guitar note. Pick its name. Easy has natural notes only; hard has all twelve.',
          'minigames.howTo.whichString' => 'You will hear an open string. Say which one it is, from 6th (the lowest) to 1st (the highest). Easy has only three.',
          'minigames.howTo.whichFret' => 'You will hear the open string and then the same string fretted. Each fret rises one semitone: count how many.',
          'minigames.howTo.interval' => 'You will hear two notes in a row, low to high. Recognise the distance between them: third, fifth, octave…',
          'minigames.howTo.higherLower' => 'You will hear two notes. Say whether the first or the second sounds higher. On hard they are almost the same.',
          'minigames.howTo.chordQuality' => 'You will hear a chord. Tell whether it is major (bright), minor (sad), seventh and more as you level up.',
          'minigames.howTo.nameChord' => 'You will hear a chord from the bank. Pick its name among several similar options.',
          'minigames.howTo.tuneEar' => 'You will hear a reference note and another that may be flat, in tune or sharp. Train your tuner ear.',
          'minigames.howTo.memory' => 'You will hear a sequence of open strings. Tap them in the same order. Each question adds more notes.',
          'minigames.howTo.noteAtFret' => 'You get a string and a fret. Say which note it is. You will learn the fretboard without looking at the guitar.',
          'minigames.howTo.fretOfNote' => 'You get a string and a note. Say which fret it is on (0 is the open string).',
          'minigames.howTo.fingerQuiz' => 'You will see a chord with one string marked and no numbers. Say which finger presses it: 1 index, 2 middle, 3 ring, 4 pinky.',
          'minigames.howTo.readDiagram' => 'You will see the diagram of a position. Recognise which chord it is.',
          'minigames.howTo.buildChord' => 'You get the name of a chord. Place your fingers on the fretboard and check. Then play it on your guitar.',
          'minigames.howTo.playNote' => 'You are asked for a note. Play it on any string: the microphone recognises it. You can hear the note first.',
          'minigames.howTo.playStringFret' => 'You are asked for an exact string and fret. Press and play: the microphone checks that the right note sounds.',
          'minigames.howTo.echo' => 'You will hear a short melody. Play it on your guitar note by note, in the same order.',
          'minigames.noteNames.n0' => 'C',
          'minigames.noteNames.n1' => 'C♯',
          'minigames.noteNames.n2' => 'D',
          'minigames.noteNames.n3' => 'D♯',
          'minigames.noteNames.n4' => 'E',
          'minigames.noteNames.n5' => 'F',
          'minigames.noteNames.n6' => 'F♯',
          'minigames.noteNames.n7' => 'G',
          'minigames.noteNames.n8' => 'G♯',
          'minigames.noteNames.n9' => 'A',
          'minigames.noteNames.n10' => 'A♯',
          'minigames.noteNames.n11' => 'B',
          'minigames.intervalNames.i1' => 'Minor 2nd',
          'minigames.intervalNames.i2' => 'Major 2nd',
          'minigames.intervalNames.i3' => 'Minor 3rd',
          'minigames.intervalNames.i4' => 'Major 3rd',
          'minigames.intervalNames.i5' => 'Perfect 4th',
          'minigames.intervalNames.i6' => 'Tritone',
          'minigames.intervalNames.i7' => 'Perfect 5th',
          'minigames.intervalNames.i8' => 'Minor 6th',
          'minigames.intervalNames.i9' => 'Major 6th',
          'minigames.intervalNames.i10' => 'Minor 7th',
          'minigames.intervalNames.i11' => 'Major 7th',
          'minigames.intervalNames.i12' => 'Octave',
          'minigames.choice.fret' => ({required Object n}) => 'Fret ${n}',
          'minigames.choice.fretOpen' => 'Open',
          'minigames.choice.finger1' => '1 · Index',
          'minigames.choice.finger2' => '2 · Middle',
          'minigames.choice.finger3' => '3 · Ring',
          'minigames.choice.finger4' => '4 · Pinky',
          'minigames.choice.first' => 'The first',
          'minigames.choice.second' => 'The second',
          'minigames.choice.flat' => 'Flat (lower)',
          'minigames.choice.inTune' => 'In tune',
          'minigames.choice.sharp' => 'Sharp (higher)',
          'minigames.buildMissed' =>
            'That is how it is formed. Memorise it and keep going!',
          'minigames.micPracticeNote' => 'This one doesn\'t score',
          'minigames.micPlayingMelody' => 'Listen to the melody…',
          'guitar.ready' => 'Play an open string',
          'guitar.waiting' => 'Let the last note fade…',
          'guitar.noMic' =>
            'I can\'t hear you: check the microphone or use the buttons',
          'guitar.openString' => ({
            required Object string,
          }) => '${string}, open',
          'guitar.continueLabel' => 'Continue',
          'guitar.retry' => 'Retry',
          'guitar.leave' => 'Leave',
          'guitar.open' => 'Open',
          'guitar.previousGame' => 'Previous',
          'guitar.nextGame' => 'Next',
          'guitar.getReady' => 'Get the chord ready',
          'guitar.startsIn' => ({required Object n}) => 'Starting in ${n}',
          'guitar.imReady' => 'Go!',
          'guitar.setting' => 'Control with your guitar',
          'guitar.settingSubtitle' => 'Play an open string to continue, retry or leave without touching your phone',
          'guitar.hubTitle' => 'Browse with your guitar',
          'guitar.hubSubtitle' => 'D: next · A: previous · E: open',
          _ => null,
        };
  }
}
