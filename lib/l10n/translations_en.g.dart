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
  late final Translations$chordGames$en chordGames =
      Translations$chordGames$en._(_root);
  @override
  late final Translations$guitar$en guitar = Translations$guitar$en._(_root);
  @override
  late final Translations$theory$en theory = Translations$theory$en._(_root);
  @override
  late final Translations$studio$en studio = Translations$studio$en._(_root);
  @override
  late final Translations$jam$en jam = Translations$jam$en._(_root);
  @override
  late final Translations$songs$en songs = Translations$songs$en._(_root);
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
      '${count} games for ear, fretboard, chords and harmony';
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
  @override
  String get guitarModeTitle => 'Your guitar is also the remote';
  @override
  String get guitarModeBody =>
      'Move around the whole app by playing notes, without putting the guitar down.';
  @override
  String get guitarModeSwitch => 'Turn on guitar mode';
  @override
  String get guitarModeSwitchHint =>
      'It will ask for microphone permission. You can change it in Settings.';
  @override
  String get guitarModeStep1 =>
      'Play a high note (fret 14 or more on the 1st string) and the menu opens.';
  @override
  String get guitarModeStep2 =>
      'With the menu open, play the note of the option: on one string, open E and one more fret per destination.';
  @override
  String get guitarModeTry => 'Tap an option to see which note picks it';
  @override
  String guitarModePreview({
    required Object note,
    required Object fret,
    required Object label,
  }) => '${note} · ${fret} → ${label}';
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
    'scaleNote': 'Scale notes',
    'keyChord': 'Chords in a key',
    'scaleDegree': 'Which degree?',
    'findTonic': 'Find the tonic',
    'progressionEar': 'Progression by ear',
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
    'scaleNote': 'Spot which note belongs to each scale',
    'keyChord': 'The IV of G, the V of A… instantly',
    'scaleDegree': 'Number every note in the key',
    'findTonic': 'Listen and find the \'home\' note',
    'progressionEar': 'Tell I-IV-V from I-V-vi-IV',
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
    'scaleNote': 'A scale and its tonic are shown. Pick the only option that belongs to that scale. Use the formula or picture the box on the neck.',
    'keyChord': 'A key and a degree in Roman numerals are shown. Pick the chord on that degree. Remember: in major, I IV V are major; ii iii vi are minor.',
    'scaleDegree': 'A key and a note are shown. Say which degree it is (I = tonic, IV = subdominant, V = dominant…).',
    'findTonic': 'A four-chord cadence plays and ends at home. Pick the note that sounds like rest: the tonic.',
    'progressionEar': 'Four chords play. Pick which progression it is, written in degrees. Notice whether it starts major or minor and how it gets back home.',
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
  @override
  String get theoryTitle => 'Music theory';
  @override
  String get theorySubtitle =>
      'Scales, keys, degrees and progressions: understand what you play.';
}

// Path: chordGames
class Translations$chordGames$en extends Translations$chordGames$es {
  Translations$chordGames$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get chordsTitle => 'Chords and variants';
  @override
  String get chordsSubtitle =>
      'Notes, formulas, diagrams, CAGED shapes and timed challenges';
  @override
  String get harmonyTitle => 'Progressions and harmony';
  @override
  String get harmonySubtitle => 'Degrees, transposing, relatives and styles';
  @override
  String get newBadge => 'New';
  @override
  String get searchHint => 'Search games';
  @override
  String get filterAll => 'All';
  @override
  String get filterNew => 'New';
  @override
  String get filterLabel => 'Filter by family';
  @override
  String get noResultsTitle => 'No game matches';
  @override
  String get noResultsBody => 'Try another word or remove the filter.';
  @override
  String get clearSearch => 'Clear the search';
  @override
  String gamesCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: '${n} game',
        other: '${n} games',
      );
  @override
  String get timeUp => 'Time is up!';
  @override
  String timeLeft({required Object n}) => '${n} s';
  @override
  String speedBonus({required Object n}) => 'Speed: +${n} points';
  @override
  String perQuestion({required Object n}) => 'Time per question: ${n} s';
  @override
  String changesGoal({required Object goal, required Object seconds}) =>
      'Goal: ${goal} clean changes in ${seconds} s';
  @override
  Map<String, String> get titles => {
    'spellChord': 'Spell the chord',
    'chordFormula': 'Chord formula',
    'chordVariantEar': 'Which variant is it?',
    'chordMemory': 'Chord memory',
    'rootAndBass': 'Root and bass',
    'inversion': 'Inversions',
    'wrongDiagram': 'Wrong diagram',
    'cagedShape': 'CAGED shapes',
    'rushOpen': 'Rush: open chords',
    'rushBarre': 'Rush: barre chords',
    'rushSeventh': 'Rush: seventh chords',
    'fillProgression': 'Complete the progression',
    'romanDegree': 'Roman numerals',
    'transposeChord': 'Transpose',
    'chordNeighbors': 'Relatives and fifths',
    'styleDuel': 'Style duel',
    'chordChanges': 'Chord changes',
  };
  @override
  Map<String, String> get descriptions => {
    'spellChord': 'Which notes make up each chord?',
    'chordFormula': 'From the chord to its 1-3-5… formula and back',
    'chordVariantEar': 'Hear maj7, 7, 6, sus… and tell the variant',
    'chordMemory': 'Repeat the chords you hear in order',
    'rootAndBass': 'Where the root is and which note is in the bass',
    'inversion': 'Root position, 1st or 2nd inversion',
    'wrongDiagram': 'Find the diagram with a mistake',
    'cagedShape': 'Tell C, A, G, E, D and where the barre goes',
    'rushOpen': 'Name open chords against the clock',
    'rushBarre': 'Name barre chords against the clock',
    'rushSeventh': 'Sevenths and extended chords against the clock',
    'fillProgression': 'Find the missing chord',
    'romanDegree': 'From the IV to the chord and back',
    'transposeChord': 'Move up in semitones and play with a capo',
    'chordNeighbors': 'Relative, dominant, subdominant and fifths',
    'styleDuel': 'Which genre is it? Progression and strumming',
    'chordChanges': 'Clean changes in 60 seconds',
  };
  @override
  Map<String, String> get howTo => {
    'spellChord': 'You will see a chord name. On easy and medium pick the group of notes that makes it up: C6 and A minor 7 share notes, so watch the root. On hard, play the notes of the chord from the root up.',
    'chordFormula': 'Every chord is built with intervals from its root: 1-3-5 is major, 1-♭3-5 minor, 1-3-5-♭7 dominant seventh… Go from the chord to its formula or from the formula to the chord name.',
    'chordVariantEar': 'You will hear a chord and be told its root. Tell which variant it is: major, minor, 7, maj7, 6, sus… The higher the level, the more look-alike variants there are.',
    'chordMemory': 'You will hear a series of chords. Tap the chords in the same order they played. Each level adds more chords and more options.',
    'rootAndBass': 'You will see the diagram of a position. Sometimes you must say which string holds the lowest root and other times which note is in the bass, the lowest string that sounds.',
    'inversion': 'A chord is in root position when the root is in the bass; with the third in the bass it is the 1st inversion and with the fifth, the 2nd. On hard you only hear it: listen to the bass.',
    'wrongDiagram': 'You will see several diagrams of the same chord and one has a mistake: a note that is not in the chord, a string that should be muted or an essential note that is missing. Find it.',
    'cagedShape': 'Barre chords move along the neck with five shapes: C, A, G, E and D. Recognise the shape of a diagram or say which fret the barre goes on to play a chord with a given shape.',
    'rushOpen': 'A race against the clock: the diagram of an open chord appears and you have a few seconds to name it. The faster you answer, the more points.',
    'rushBarre': 'A race against the clock: the diagram of a barre chord appears and you have a few seconds to name it. The faster you answer, the more points.',
    'rushSeventh': 'A race against the clock: the diagram of a seventh or extended chord appears and you have a few seconds to say which one it is. The faster you answer, the more points.',
    'fillProgression': 'You will see a famous progression with one hidden chord (?). Pick the missing one; on hard, pick its Roman numeral. On easy and medium you can hear the rest of the progression.',
    'romanDegree': 'Roman numerals name the chords of a key: in G major the IV is C and the V7 is D7. Go from the numeral to the chord and back; on hard there are sevenths and borrowed chords such as the ♭VII.',
    'transposeChord': 'Transposing means moving a chord up or down. With a capo on fret N, the shape you play sounds N semitones higher. Solve moves up, down and capo questions.',
    'chordNeighbors': 'Every chord has neighbours: its relative (shares the scale notes), its dominant (V), its subdominant (IV) and the ones next to it on the circle of fifths. Find the one you are asked for.',
    'styleDuel': 'You will hear the first bars of a progression with its strumming. From the chords and the rhythm, say the genre: pop, rock, blues, reggae…',
    'chordChanges': 'We ask for chords one after another: play it and change as soon as you can. Every clean change counts; you have 60 seconds and the goal number of changes gives three stars.',
  };
  @override
  late final Translations$chordGames$prompt$en prompt =
      Translations$chordGames$prompt$en._(_root);
  @override
  late final Translations$chordGames$choice$en choice =
      Translations$chordGames$choice$en._(_root);
  @override
  late final Translations$chordGames$explain$en explain =
      Translations$chordGames$explain$en._(_root);
  @override
  late final Translations$chordGames$changes$en changes =
      Translations$chordGames$changes$en._(_root);
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
  String get hubSubtitle =>
      'The whole app with your guitar: a high note opens the menu';
  @override
  String hubSelected({
    required Object name,
    required Object n,
    required Object total,
  }) => '${name} · ${n} of ${total}';
  @override
  String get navMenu => 'Menu';
  @override
  String get navTitle => 'Guitar menu';
  @override
  String get navWake => 'High note (fret 14 or more on the 1st string): menu';
  @override
  String get navHint =>
      'On any string: open E, then one fret more per destination';
  @override
  String get navBack => 'Back';
  @override
  String get navClose => 'Close';
  @override
  String get navOff => 'Turn off';
  @override
  String get navProfile => 'Profile';
  @override
  String get navWakeShort => 'High note';
  @override
  String get navFretOpen => 'open';
  @override
  String navFret({required Object n}) => 'fret ${n}';
  @override
  String get navSetting => 'Guitar mode across the app';
  @override
  String get navSettingSubtitle =>
      'A fixed panel replaces the navigation bar: a high note opens the menu and each note takes you to a screen';
}

// Path: theory
class Translations$theory$en extends Translations$theory$es {
  Translations$theory$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Guitar school';
  @override
  String get subtitle =>
      'Understand what you play: tonic, scales, positions and harmony.';
  @override
  String get unitBasics => 'Fundamentals';
  @override
  String get unitScales => 'Scales and positions';
  @override
  String get unitHarmony => 'Harmony and progressions';
  @override
  String get keyPoints => 'Key ideas';
  @override
  String get tryIt => 'Try it on the fretboard';
  @override
  String get openExplorer => 'Open in the explorer';
  @override
  String practiceGame({required Object game}) => 'Practice: ${game}';
  @override
  String practiceJam({required Object name}) => 'Jam it: ${name}';
  @override
  String get markLearned => 'Mark as learned';
  @override
  String get learned => 'Learned';
  @override
  String lessonsDone({required Object done, required Object total}) =>
      '${done} of ${total} lessons learned';
  @override
  String harmonyTitle({required Object key}) => 'Chords of ${key}';
  @override
  String scaleIn({required Object note, required Object scale}) =>
      '${note} ${scale}';
  @override
  String keyName({required Object note, required Object mode}) =>
      '${note} ${mode}';
  @override
  String get majorMode => 'major';
  @override
  String get minorMode => 'minor';
  @override
  String get explorerTitle => 'Scale explorer';
  @override
  String get explorerTonic => 'Tonic';
  @override
  String get explorerScale => 'Scale';
  @override
  String get explorerPosition => 'Position';
  @override
  String get allPositions => 'Whole neck';
  @override
  String positionN({required Object n}) => 'Position ${n}';
  @override
  String get showDegrees => 'Degrees';
  @override
  String get showNotes => 'Notes';
  @override
  String get playScale => 'Listen';
  @override
  String get stopScale => 'Stop';
  @override
  String get explorerHint =>
      'Tap a note on the fretboard to hear it. Tonics use the main color and the signature note is highlighted.';
  @override
  String formula({required Object formula}) => 'Formula: ${formula}';
  @override
  String notesOf({required Object notes}) => 'Notes: ${notes}';
  @override
  String fretboardLabel({required Object scale}) =>
      'Fretboard showing ${scale}';
  @override
  String get genresTitle => 'Genres';
  @override
  String get genresSubtitle =>
      'How each style sounds: tempo, strumming, scales, chords and progressions.';
  @override
  String tempoRange({required Object min, required Object max}) =>
      '${min}–${max} BPM';
  @override
  String get genreRhythmTitle => 'Rhythm';
  @override
  String get genreTipTitle => 'Tip';
  @override
  String get genreScales => 'Scales for soloing';
  @override
  String get genreChords => 'Typical chords';
  @override
  String get genreProgressions => 'Progressions to jam';
  @override
  String get genreSongs => 'Songs';
  @override
  String genreLibrary({required Object genre}) =>
      'See ${genre} chords in the library';
  @override
  String strumLabel({required Object name}) => 'Strumming: ${name}';
  @override
  Map<String, String> get scaleNames => {
    'major': 'major',
    'minor': 'natural minor',
    'harmonicMinor': 'harmonic minor',
    'minorPentatonic': 'minor pentatonic',
    'majorPentatonic': 'major pentatonic',
    'blues': 'blues scale',
    'dorian': 'dorian',
    'phrygian': 'phrygian',
    'lydian': 'lydian',
    'mixolydian': 'mixolydian',
  };
  @override
  Map<String, String> get scaleAbout => {
    'major': 'The foundation of harmony: happy and stable. Pop, folk and children\'s songs.',
    'minor':
        'The major\'s relative: melancholic and epic. Ballads, rock and metal.',
    'harmonicMinor': 'Minor with a raised seventh: classical, flamenco and neoclassical flavor.',
    'minorPentatonic':
        'Five notes that never fail: the heart of rock and blues.',
    'majorPentatonic': 'Sweet and open: country, pop, soul and melodic solos.',
    'blues': 'Minor pentatonic plus the blue note (b5): pure attitude.',
    'dorian': 'Minor with a major sixth: funk, jazz, Santana and Pink Floyd.',
    'phrygian': 'Minor with a minor second: flamenco and dark metal.',
    'lydian': 'Major with a raised fourth: dreamy, soundtrack-like.',
    'mixolydian':
        'Major with a minor seventh: classic rock, blues and country.',
  };
  @override
  Map<String, String> get degreeNames => {
    'd1': 'tonic',
    'd2': 'supertonic',
    'd3': 'mediant',
    'd4': 'subdominant',
    'd5': 'dominant',
    'd6': 'submediant',
    'd7': 'leading tone',
  };
  @override
  Map<String, String> get strumNames => {
    'whole': 'One strum per bar',
    'quarters': 'Quarter notes',
    'pop': 'Pop',
    'eighths': 'Eighth notes',
    'boomChick': 'Boom-chick',
    'skank': 'Offbeat (reggae)',
    'bossa': 'Bossa nova',
    'shuffle': 'Shuffle',
    'waltz': 'Waltz 3/4',
  };
  @override
  Map<String, String> get genreNames => {
    'pop': 'Pop',
    'rock': 'Rock',
    'blues': 'Blues',
    'country': 'Country',
    'jazz': 'Jazz',
    'funk': 'Funk',
    'ballad': 'Ballad',
    'latin': 'Latin',
    'reggae': 'Reggae',
    'bossa': 'Bossa nova',
    'metal': 'Metal',
    'punk': 'Punk',
    'soul': 'Soul and R&B',
    'gospel': 'Gospel',
    'folk': 'Folk and traditional',
  };
  @override
  Map<String, String> get genreAbout => {
    'pop': 'Catchy songs over a few progressions (I-V-vi-IV). The guitar backs them with open chords and a steady strum.',
    'rock': 'Power chords, driving eighth notes and minor pentatonic riffs. I-IV-V and the bVII rule.',
    'blues': 'Twelve bars, seventh chords and the blues scale. Feel matters more than speed.',
    'country': 'Open chords, alternating bass and major pentatonic melodies. Simple stories and lots of swing in the picking hand.',
    'jazz': 'Seventh chords (maj7, m7, 7), the ii-V-I and constant key changes. Played light and swinging.',
    'funk': 'Ninth and m7 chords played short and percussive. The guitar is part of the drum kit.',
    'ballad':
        'Slow tempos and chords left ringing. Arpeggios or one strum per beat.',
    'latin': 'From the ranchera in 3/4 to the Andalusian cadence and bolero. Lots of harmonic minor.',
    'reggae': 'The chord only sounds on the offbeats, short and dry. Bass and drums carry the beat.',
    'bossa': 'Soft seventh chords, thumb bass and syncopated chords with the fingers.',
    'metal': 'Palm-muted power chords, fast tempos and minor, phrygian and harmonic scales.',
    'punk': 'Three or four power chords, downstroked eighths and lots of speed. Attitude first.',
    'soul': 'Color chords (maj7, m7, 9), a relaxed groove and major pentatonic fills.',
    'gospel': 'Church harmony: I-IV-V with sevenths, the minor iv and plagal (\'amen\') cadences.',
    'folk': 'Timeless songs with three or four open chords. Perfect for singing along.',
  };
  @override
  Map<String, String> get genreRhythm => {
    'pop': '↓ ↓↑ ↑↓↑ in 4/4. Accent beats 2 and 4.',
    'rock': 'Down or down-up eighths, palm-muted in the verses.',
    'blues': 'Shuffle: each beat long-short (da-ga da-ga).',
    'country': 'Boom-chick: bass on 1 and 3, strum on 2 and 4, alternating the bass string.',
    'jazz': 'Four short strums per bar (Freddie Green style), swinging.',
    'funk': 'Sixteenths with the hand always moving; mostly muted with a few open hits.',
    'ballad':
        'One strum per bar or a slow arpeggio from the 6th to the 1st string.',
    'latin':
        'Ranchera: bass-chord-chord (3/4). Rumba: strum accenting the offbeat.',
    'reggae': 'Silence on 1, a dry hit on 2 and 4 (skank).',
    'bossa': 'Thumb on the bass every beat and a syncopated chord in between.',
    'metal': 'Eighths or gallop (an eighth and two sixteenths), palm-muted.',
    'punk': 'All-downstroke eighths, fast and steady.',
    'soul': 'Soft hits on 2 and 4 with fills between chords.',
    'gospel': 'Firm quarter notes accenting 2 and 4; call and response.',
    'folk': 'Quarters or the pop pattern; in 3/4, bass plus two strums.',
  };
  @override
  Map<String, String> get genreTip => {
    'pop': 'Learn I-V-vi-IV in G, C and D: you\'ll play hundreds of songs.',
    'rock': 'Palm-mute the verses and let the chorus ring open.',
    'blues':
        'Bend the 4th up to the 5th of the scale and end phrases on the tonic.',
    'country': 'Alternate the bass between the root and the fifth for the classic boom-chick.',
    'jazz': 'Learn m7, 7 and maj7 shapes rooted on the 6th and 5th strings: they cover 90%.',
    'funk': 'Strum close to the bridge and relax the fretting hand to mute between hits.',
    'ballad': 'Let chords ring and change right before beat 1, not late.',
    'latin': 'In the Andalusian cadence use harmonic minor over the V chord (E major in A minor).',
    'reggae': 'Play the skank on the top three strings and mute it right away.',
    'bossa': 'Practice the thumb bass alone before adding the chords.',
    'metal':
        'Dial in the palm mute: hand on the bridge, not too far on or off.',
    'punk': 'Keep the wrist loose: speed comes from relaxation.',
    'soul': 'Play chords on the top three or four strings for a clean sound.',
    'gospel': 'Try IV → iv → I: the major-to-minor change is pure emotion.',
    'folk': 'Sing while you play: the strumming hand should run on autopilot.',
  };
  @override
  Map<String, String> get progressionNames => {
    'popAxis': 'The pop axis',
    'dooWop': '50s doo-wop',
    'rockClassic': 'Classic rock I-IV-V',
    'rockMixo': 'Rock with bVII',
    'blues12': '12-bar blues',
    'bluesMinor': 'Minor blues',
    'countryRoad': 'Country road',
    'countryTwoStep': 'Two-step',
    'jazz251': 'Jazz ii-V-I',
    'jazzTurnaround': 'Turnaround',
    'funkDorian': 'Dorian vamp',
    'balladSad': 'Heartfelt ballad',
    'canon': 'Pachelbel\'s canon',
    'andalusian': 'Andalusian cadence',
    'ranchera': 'Ranchera tonic-dominant',
    'reggaeSkank': 'Reggae skank',
    'bossaCycle': 'Bossa cycle',
    'metalMinor': 'Minor metal',
    'metalPhrygian': 'Phrygian metal',
    'punkPower': 'Full-speed punk',
    'soulGroove': 'Soul groove',
    'gospelPlagal': 'Gospel with minor iv',
    'folkThree': 'Three-chord folk',
  };
  @override
  Map<String, String> get lessonTitles => {
    'notes': 'Notes and the fretboard',
    'intervals': 'Intervals: the distance between notes',
    'tonic': 'The tonic and the key',
    'rhythm': 'Rhythm, meter and strumming',
    'majorScale': 'The major scale',
    'minorScales': 'Minor scales',
    'pentatonic': 'Pentatonics: the soloist\'s scale',
    'positions': 'Scale positions (boxes)',
    'blues': 'The blues and the blue note',
    'modes': 'The Greek modes',
    'harmony': 'Harmony: the chords of a key',
    'degrees': 'Degrees and functions',
    'progressions': 'Famous progressions',
    'caged': 'The CAGED system',
  };
  @override
  Map<String, String> get lessonSummaries => {
    'notes':
        'The 12 notes, sharps and flats, and how to find them on the guitar.',
    'intervals':
        'Half steps, thirds, fifths and octaves: the DNA of scales and chords.',
    'tonic': 'A song\'s \'home\' note and how to tell what key it\'s in.',
    'rhythm': 'The beat, 4/4 and 3/4, eighth notes and each genre\'s patterns.',
    'majorScale': 'The W-W-H-W-W-W-H formula, the mother of harmony.',
    'minorScales': 'Natural minor, harmonic minor and the relative minor.',
    'pentatonic':
        'Five notes that never sound wrong: the shortcut to improvising.',
    'positions':
        'Position theory: splitting the neck into boxes that fit together.',
    'blues': 'The blues scale, the shuffle and the 12-bar form.',
    'modes':
        'Seven colors of the same scale: dorian, phrygian, lydian, mixolydian…',
    'harmony': 'Every scale note builds a chord: the diatonic chords.',
    'degrees': 'Tonic, subdominant and dominant: rest, motion and tension.',
    'progressions': 'The chord combinations behind thousands of songs.',
    'caged': 'Five open chord shapes that cover the whole neck.',
  };
  @override
  Map<String, String> get lessonBodies => {
    'notes': 'Western music uses only 12 notes that repeat in octaves: C, C♯, D, D♯, E, F, F♯, G, G♯, A, A♯ and B.\n\nBetween two neighboring notes there is a half step, and on the guitar a half step is exactly one fret; two frets make a whole step. There is no sharp between E and F or between B and C: they are a half step apart.\n\nA sharp (♯) raises a note a half step and a flat (♭) lowers it, so C♯ and D♭ are the same note with two names. At the 12th fret every string repeats its open note an octave higher: that\'s where the neck starts over.',
    'intervals': 'An interval is the distance between two notes, measured in half steps (frets). Each distance has its own color: the major third (4 half steps) sounds happy, the minor third (3) sad and the perfect fifth (7) solid and open.\n\nChords are built by stacking intervals on a root: a major chord is root + major third + fifth; a minor chord only changes the third. That\'s why moving a single note one fret turns C into C minor.\n\nOn the guitar every interval has a shape: the fifth is on the next (higher) string, two frets up, and the octave two strings over and two frets up. When crossing the 2nd (B) string the shape shifts one fret.',
    'tonic': 'The tonic is the note a song revolves around: the home everything wants to return to. When the melody or chord lands on the tonic we feel rest; moving away creates tension.\n\nThe key is the tonic plus its scale. \'G major\' means G is home and the notes come from the G major scale. Almost every song ends, and many start, on the tonic chord.\n\nTo find a song\'s key, look for the chord that sounds like an ending, check that the other chords belong to that key and sing the note that \'closes\' the melody. With practice you\'ll hear it instantly: play \'Find the tonic\'.',
    'rhythm': 'The beat is music\'s steady pulse. Meter groups beats: 4/4 (four per bar) is the meter of pop, rock and almost everything; 3/4 belongs to the waltz, the ranchera and many folk songs.\n\nEach beat splits into two eighth notes: down on the beat (\'1\') and up on the offbeat (\'and\'). The strumming hand always moves down-up like a pendulum, even when it doesn\'t hit the strings: that way the rhythm never breaks.\n\nEach genre has its pattern: pop (↓ ↓↑ ↑↓↑), rock (eighths), country (boom-chick), reggae (offbeats only) or blues (shuffle). Jam mode shows the pattern stroke by stroke while you play.',
    'majorScale': 'The major scale has seven notes and always follows the same formula of whole (W) and half (H) steps: W W H W W W H. From C you get C D E F G A B, all natural notes.\n\nWith the formula you can build it from any note. From G: G A B C D E F♯; the F♯ appears to keep the last whole step before the final half step.\n\nOn a single string you play the major scale by counting frets: 2, 2, 1, 2, 2, 2, 1. Try it on the 5th string from the 3rd fret (C) and hear the famous do-re-mi. The explorer shows its seven three-notes-per-string positions.',
    'minorScales': 'The natural minor scale changes the formula: W H W W H W W. A minor uses the same notes as C major (A B C D E F G), but starting on A makes everything darker: it is C\'s relative minor.\n\nEvery major key has a relative minor three half steps below (G major ↔ E minor). They share notes and chords; only home changes.\n\nThe harmonic minor raises the seventh note a half step (G♯ in A minor). That note makes the fifth-degree chord major (E major in A minor), which pulls hard toward the tonic: the sound of flamenco, classical music and many boleros.',
    'pentatonic': 'The pentatonic is a five-note scale: it drops the two most tense notes of the major or minor scale. That\'s why almost any note you play over the song\'s chords will sound good.\n\nThe minor pentatonic (1 b3 4 5 b7) is the backbone of rock and blues: A C D E G in A minor. The major pentatonic (1 2 3 5 6) sounds sweet and open, typical of country and pop: C D E G A in C.\n\nKey trick: A minor pentatonic and C major pentatonic share the same notes. The same shape with a different tonic gives you both sounds. Lean on the major tonic to sound major, on the minor one to sound bluesy.',
    'positions': 'A position or box is the group of scale notes you can reach without moving your hand: four or five frets, one finger per fret. The pentatonic has five boxes and seven-note scales have seven three-notes-per-string positions.\n\nBoxes fit together like puzzle pieces: the right edge of one is the left edge of the next, and after the last one the first returns twelve frets higher. Knowing them all lets you play the scale across the whole neck.\n\nPosition 1 of the minor pentatonic starts with the tonic on the 6th string under the index finger. Learn it first, then 2, and connect them by sliding a finger. Changing key needs nothing new: move the whole box to the new tonic.',
    'blues': 'The blues scale is the minor pentatonic plus one note: the flat fifth (b5), the famous blue note. In A: A C D D♯ E G. Use it in passing on the way to the fifth; don\'t sit on it.\n\nThe classic blues lasts 12 bars with three seventh chords: four bars of I7, two of IV7, two of I7, then V7, IV7, I7 and V7 to start over (the \'turnaround\').\n\nThe rhythm is the shuffle: each beat splits into a long and a short hit (da-ga, da-ga). Try the \'12-bar blues\' jam and play the blues scale over it.',
    'modes': 'If you play the notes of C major starting on another note you get a mode: from D dorian, from E phrygian, from F lydian, from G mixolydian, from A aeolian (natural minor) and from B locrian.\n\nEach mode has a signature note. Dorian is minor with a major sixth (funk, Santana). Phrygian, minor with a minor second (flamenco, metal). Lydian, major with a raised fourth (dreamy, soundtracks). Mixolydian, major with a minor seventh (rock, blues, country).\n\nTo hear them, play the mode over a static chord on its tonic: the signature note stands out. The explorer marks it in another color.',
    'harmony': 'If you build a chord on each note of the major scale using only scale notes you get seven chords: I major, ii minor, iii minor, IV major, V major, vi minor and vii diminished. In C: C Dm Em F G Am B°.\n\nThat list is the diatonic harmony and explains why certain chords sound good together: they belong to the same key. Roman numerals let you write progressions independent of key: \'I-V-vi-IV\' is the same in C (C G Am F) as in G (G D Em C).\n\nWith four notes the jazz chords appear: Imaj7, ii7, iii7, IVmaj7, V7, vi7 and viiø. V7 is the only dominant: the one that asks to return to the tonic.',
    'degrees': 'Each scale degree has a function. The tonic (I) is rest. The subdominant (IV) gently moves away. The dominant (V) builds tension and wants to resolve to the tonic.\n\nThe other degrees stand in for these three: vi and iii share notes with I (tonic function) and ii resembles IV (subdominant). That\'s why \'I-vi-IV-V\' and \'I-IV-V\' tell the same story: home, journey, tension and return.\n\nOnce you understand functions you can guess a song\'s next chord, figure out songs by ear and write your own progressions.',
    'progressions': 'A progression is a repeating sequence of chords. A handful hold up much of popular music: I-V-vi-IV (pop), I-IV-V (rock, country, folk, ranchera), ii-V-I (jazz), vi-IV-I-V (ballads) and the Andalusian cadence i-bVII-bVI-V (flamenco and Latin rock).\n\nBecause they\'re written in degrees you can play them in any key: pick one that\'s comfortable to sing. Learn each progression in two or three keys and you\'ll start recognizing them everywhere.\n\nThe guided jam has all these progressions with backing, metronome, the strumming pattern and the recommended scale to improvise.',
    'caged': 'The five open major chord shapes —C, A, G, E and D (C-A-G-E-D)— can move up the neck with a barre. Chained in that order they cover all twelve frets with the same chord.\n\nFor example, C major can be played as a C shape (open), an A shape (barre at fret 3), a G shape (fret 5), an E shape (fret 8) and a D shape (fret 10). Each shape shares notes with the next.\n\nEach CAGED shape matches a major pentatonic box. That\'s how chords and scales connect: you always know which solo notes surround the chord you\'re playing.',
  };
  @override
  Map<String, String> get lessonPoints => {
    'notes': '12 notes: 7 natural and 5 sharps/flats\n1 fret = 1 half step; 2 frets = 1 whole step\nE–F and B–C are a half step apart\nFret 12 = the same note an octave up\nLearn the notes on the 6th and 5th strings first: they are your barre-chord roots',
    'intervals': 'Minor third = 3 half steps (sad)\nMajor third = 4 half steps (happy)\nPerfect fifth = 7 half steps (power chord)\nOctave = 12 half steps: the same note higher\nThe B string shifts shapes by one fret',
    'tonic': 'Tonic = rest; moving away = tension\nKey = tonic + scale\nThe last chord is usually the tonic\nEvery major key has a relative minor with the same notes\nTransposing = moving everything by the same number of frets',
    'rhythm': '4/4: count 1 and 2 and 3 and 4 and\n3/4: count 1 and 2 and 3 and\nThe hand never stops: down on the beat, up on the \'and\'\nStart slow with a metronome and raise the tempo gradually\nChange chords on the last stroke of the bar',
    'majorScale': 'Formula: W W H W W W H (2-2-1-2-2-2-1 frets)\nSeven notes, one of each letter\nIts degrees are numbered 1 to 7\nThe key\'s chords come from it\nIt has 7 three-notes-per-string positions',
    'minorScales': 'Natural minor: W H W W H W W\nRelative minor = 3 half steps below the major\nSame notes, different tonic\nHarmonic minor: raised seventh\nA major V in minor gives the flamenco cadence',
    'pentatonic': 'Minor: 1 b3 4 5 b7\nMajor: 1 2 3 5 6\nTwo notes per string in each box\nA minor pentatonic = C major pentatonic (same notes)\nEnd your phrases on the tonic to sound resolved',
    'positions': 'One box = 4-5 frets, one finger per fret\nPentatonic: 5 boxes; seven-note scales: 7 positions\nBoxes overlap and repeat every 12 frets\nAlways locate the tonics inside the box\nMoving the whole box = changing key',
    'blues': 'Blues = minor pentatonic + b5\n12 bars: I7 – IV7 – I7 – V7 – IV7 – I7\nEvery chord is a seventh chord\nShuffle: long-short on each beat\nBends and vibrato give it character',
    'modes': 'Ionian = major · Aeolian = natural minor\nDorian: minor with a major 6th\nPhrygian: minor with b2\nLydian: major with #4\nMixolydian: major with b7',
    'harmony': 'Uppercase = major · lowercase = minor\nIn major: I ii iii IV V vi vii°\nIn minor: i ii° III iv v VI VII\nRoman numerals = progressions in any key\nV7 pulls toward I',
    'degrees': 'I tonic: rest\nIV subdominant: motion\nV dominant: tension that returns to I\nvi and iii act as tonic; ii as subdominant\nV → I is the strongest cadence',
    'progressions': 'Pop: I – V – vi – IV\nRock and country: I – IV – V\nJazz: ii – V – I\nBallad: vi – IV – I – V\nAndalusian: i – bVII – bVI – V',
    'caged': 'Order: C → A → G → E → D → C…\nEach shape is a movable open chord\nTogether they cover the whole neck\nEach shape sits on a pentatonic box\nThe root is always inside the shape',
  };
}

// Path: studio
class Translations$studio$en extends Translations$studio$es {
  Translations$studio$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get sectionTitle => 'Explore the guitar';
  @override
  String get theoryCard => 'Theory';
  @override
  String get theoryCardBody => 'Tonic, scales, pentatonics and harmony';
  @override
  String get scalesCard => 'Scales';
  @override
  String get scalesCardBody => 'Interactive fretboard with positions';
  @override
  String get genresCard => 'Genres';
  @override
  String get genresCardBody => 'Rhythms and chords of each style';
  @override
  String get jamCard => 'Guided jam';
  @override
  String get jamCardBody => 'Play along with backing and scoring';
  @override
  String get songsCard => 'Songs';
  @override
  String get songsCardBody => 'Chords and lyrics to play';
  @override
  String get historyCard => 'History';
  @override
  String get historyCardBody => 'Your recent chords';
  @override
  String streakDays({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: '${n} day in a row',
        other: '${n} days in a row',
      );
  @override
  String get streakZero => 'Play today to start your streak';
  @override
  String get streakToday => 'You already practiced today!';
  @override
  String get recentTitle => 'Recent chords';
  @override
  String get seeAll => 'See all';
  @override
  String get clearHistory => 'Clear history';
  @override
  String get historyTitle => 'Chord history';
  @override
  String get historyEmptyTitle => 'No history yet';
  @override
  String get historyEmptyBody =>
      'Chords you open will show up here for quick review.';
  @override
  String get historyHint => 'Most recent first';
}

// Path: jam
class Translations$jam$en extends Translations$jam$es {
  Translations$jam$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Guided jam';
  @override
  String get subtitle =>
      'Pick what to play, set the key and tempo, and play along with the app.';
  @override
  String get progressionsTab => 'Progressions';
  @override
  String get songsTab => 'Songs';
  @override
  String get customTab => 'Yours';
  @override
  String get key => 'Key';
  @override
  String get tempo => 'Tempo';
  @override
  String bpm({required Object n}) => '${n} BPM';
  @override
  String loops({required Object n}) => 'Loops: ${n}';
  @override
  String get modeBacking => 'Backing';
  @override
  String get modeBackingBody =>
      'The app plays the chords with the style\'s strumming.';
  @override
  String get modeScore => 'Score';
  @override
  String get modeScoreBody =>
      'You play and the microphone scores every bar (the app stays silent).';
  @override
  String get metronome => 'Metronome';
  @override
  String get start => 'Let\'s play!';
  @override
  String get countIn => 'Get ready…';
  @override
  String get now => 'Now';
  @override
  String get next => 'Next';
  @override
  String get end => 'End';
  @override
  String barOf({required Object n, required Object total}) =>
      'Bar ${n} of ${total}';
  @override
  String get pause => 'Pause';
  @override
  String get resume => 'Resume';
  @override
  String get stop => 'Finish';
  @override
  String points({required Object n}) => '${n} pts';
  @override
  String streak({required Object n}) => 'Streak ${n}';
  @override
  String get gradePerfect => 'Perfect!';
  @override
  String get gradeGood => 'Good!';
  @override
  String get gradeMiss => 'Miss';
  @override
  String get gradeSilent => 'Can\'t hear you';
  @override
  String get resultTitle => 'Session complete';
  @override
  String accuracy({required Object n}) => 'Accuracy: ${n}%';
  @override
  String bestStreak({required Object n}) => 'Best streak: ${n}';
  @override
  String perfectBars({required Object n}) => 'Perfect bars: ${n}';
  @override
  String get playAgain => 'Again';
  @override
  String get slower => 'Slower';
  @override
  String get faster => 'Faster';
  @override
  String get back => 'Pick another';
  @override
  String get newBest => 'New record!';
  @override
  String best({required Object n}) => 'Record: ${n}';
  @override
  String scaleHint({required Object scale}) => 'Improvise with: ${scale}';
  @override
  String get customHint =>
      'Tap chords to add them to your progression (up to 8).';
  @override
  String get customEmpty => 'Add at least one chord';
  @override
  String get customTitle => 'My progression';
  @override
  String get clear => 'Clear';
  @override
  String get removeLast => 'Remove last';
  @override
  String get micProblem =>
      'No microphone access: this session won\'t be scored.';
  @override
  String get headphonesTip =>
      'Tip: in \'Score\' the app stays quiet to hear you; follow the visual metronome.';
  @override
  String get chooseTrack => 'Pick what to play';
  @override
  String get strum => 'Strumming';
  @override
  String get pickTrack => 'Tap to choose';
}

// Path: songs
class Translations$songs$en extends Translations$songs$es {
  Translations$songs$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Songbook';
  @override
  String get subtitle =>
      'Traditional and public-domain songs with chords and lyrics.';
  @override
  String get searchHint => 'Search for a song';
  @override
  String get all => 'All';
  @override
  String get traditional => 'Traditional';
  @override
  String get exercise => 'Chords exercise';
  @override
  String get transpose => 'Key';
  @override
  String get transposeReset => 'Original key';
  @override
  String level({required Object n}) => 'Level ${n}';
  @override
  String get chordsUsed => 'Chords in this song';
  @override
  String get playJam => 'Play in the jam';
  @override
  String get empty => 'No songs match';
  @override
  String get emptyBody => 'Try another name or clear the genre filter.';
  @override
  String get notFound => 'We couldn\'t find that song';
  @override
  Map<String, String> get exercises => {
    'bluesInA': 'Blues in A · 12 bars',
    'rockInE': 'Power chords in E',
    'popFourChords': 'The four pop chords',
    'metalGallop': 'Metal gallop in E minor',
    'funkVamp': 'Funky vamp in E',
  };
  @override
  Map<String, String> get parts => {
    'intro': 'Intro',
    'verse': 'Verse',
    'chorus': 'Chorus',
    'bridge': 'Bridge',
    'outro': 'Outro',
  };
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
  @override
  String scaleNote({required Object scale}) => 'Which note is in ${scale}?';
  @override
  String keyChord({required Object key, required Object degree}) =>
      'In ${key}, which chord is the ${degree}?';
  @override
  String scaleDegree({required Object key, required Object note}) =>
      'In ${key}, which degree is ${note}?';
  @override
  String get findTonic => 'Listen to the cadence. Which note is the tonic?';
  @override
  String get progressionEar => 'Which progression is playing?';
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

// Path: chordGames.prompt
class Translations$chordGames$prompt$en
    extends Translations$chordGames$prompt$es {
  Translations$chordGames$prompt$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String spellSet({required Object chord}) => 'Which notes make up ${chord}?';
  @override
  String spellOrder({required Object chord}) =>
      'Play the notes of ${chord}, from the root up';
  @override
  String formulaTo({required Object chord}) =>
      'What is the formula of ${chord}?';
  @override
  String formulaName({required Object note, required Object formula}) =>
      'Which chord on root ${note} has the formula ${formula}?';
  @override
  String variantEar({required Object note}) =>
      'A chord on root ${note} is playing. Which variant is it?';
  @override
  String get chordMemory => 'Listen and repeat the chords in the same order';
  @override
  String rootString({required Object chord}) =>
      'Which string holds the lowest root of this ${chord}?';
  @override
  String bassNote({required Object chord}) =>
      'Which note is in the bass (the lowest sounding string) of this ${chord}?';
  @override
  String inversionDiagram({required Object chord}) =>
      'Which inversion is this ${chord} in?';
  @override
  String inversionEar({required Object chord}) =>
      'Listen to this ${chord}. Which inversion is playing?';
  @override
  String wrongDiagram({required Object chord}) =>
      'One of these ${chord} diagrams has a mistake. Which one?';
  @override
  String cagedShape({required Object chord}) =>
      'Which CAGED shape is this ${chord}?';
  @override
  String cagedBarre({required Object chord, required Object shape}) =>
      'To play ${chord} with the ${shape} shape, which fret does the barre go on?';
  @override
  String get rush => 'Which chord is this?';
  @override
  String fillChord({required Object genre, required Object key}) =>
      'Complete the ${genre} progression in ${key}: which chord is missing?';
  @override
  String fillRoman({required Object genre, required Object key}) =>
      'Complete the ${genre} progression in ${key}: which degree is missing?';
  @override
  String romanToChord({required Object key, required Object roman}) =>
      'In ${key}, which chord is the ${roman}?';
  @override
  String romanToRoman({required Object key, required Object chord}) =>
      'In ${key}, which degree is ${chord}?';
  @override
  String transposeUp({required num n, required Object chord}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: 'Move ${chord} up one semitone. Which chord do you get?',
        other: 'Move ${chord} up ${n} semitones. Which chord do you get?',
      );
  @override
  String transposeDown({required num n, required Object chord}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: 'Move ${chord} down one semitone. Which chord do you get?',
        other: 'Move ${chord} down ${n} semitones. Which chord do you get?',
      );
  @override
  String capoSounds({required Object n, required Object chord}) =>
      'With a capo on fret ${n} you play the ${chord} shape. Which chord sounds?';
  @override
  String capoShape({required Object n, required Object chord}) =>
      'With a capo on fret ${n} you want ${chord} to sound. Which shape do you play?';
  @override
  String relativeMinor({required Object chord}) =>
      'What is the relative minor of ${chord}?';
  @override
  String relativeMajor({required Object chord}) =>
      'What is the relative major of ${chord}?';
  @override
  String dominant({required Object chord}) =>
      'What is the dominant (V) of ${chord}?';
  @override
  String subdominant({required Object chord}) =>
      'What is the subdominant (IV) of ${chord}?';
  @override
  String fifthUp({required Object chord}) =>
      'On the circle of fifths, which chord is a fifth above ${chord}?';
  @override
  String fifthDown({required Object chord}) =>
      'On the circle of fifths, which chord is a fifth below ${chord}?';
  @override
  String parallel({required Object chord}) =>
      'What is the parallel chord of ${chord} (same note, other mode)?';
  @override
  String tritone({required Object chord}) =>
      'What is the tritone substitution of ${chord}?';
  @override
  String get styleDuel =>
      'Listen to the progression and the strumming. Which genre is it?';
}

// Path: chordGames.choice
class Translations$chordGames$choice$en
    extends Translations$chordGames$choice$es {
  Translations$chordGames$choice$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get inversionRoot => 'Root position';
  @override
  String get inversionFirst => '1st inversion';
  @override
  String get inversionSecond => '2nd inversion';
  @override
  String get inversionThird => '3rd inversion';
  @override
  String diagram({required Object n}) => 'Diagram ${n}';
}

// Path: chordGames.explain
class Translations$chordGames$explain$en
    extends Translations$chordGames$explain$es {
  Translations$chordGames$explain$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String alienNote({
    required Object string,
    required Object note,
    required Object chord,
  }) => 'On the ${string} you hear ${note}, which is not a note of ${chord}.';
  @override
  String unmutedString({
    required Object string,
    required Object note,
    required Object chord,
  }) =>
      'The ${string} should be muted: open it sounds ${note}, which is not in ${chord}.';
  @override
  String missingNote({required Object note, required Object chord}) =>
      '${note} is missing, one of the notes that define ${chord}.';
  @override
  String styleDuel({required Object genre}) => 'It was ${genre}.';
  @override
  String shape({required Object shape}) => 'It is the ${shape} shape.';
}

// Path: chordGames.changes
class Translations$chordGames$changes$en
    extends Translations$chordGames$changes$es {
  Translations$chordGames$changes$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get getReady => 'Get ready…';
  @override
  String startsIn({required Object n}) => 'Starting in ${n}';
  @override
  String get playThis => 'Play this chord';
  @override
  String get clean => 'Clean changes';
  @override
  String goal({required Object n}) => 'Goal: ${n}';
  @override
  String heard({required Object count, required Object total}) =>
      'Notes heard: ${count} of ${total}';
  @override
  String get hear => 'Hear the chord';
  @override
  String get skip => 'Skip chord';
  @override
  String get listening => 'Listening…';
  @override
  String get cleanChange => 'Clean change!';
  @override
  String get missed => 'Time ran out on this chord';
  @override
  String timeLeft({required Object n}) => '${n} s left';
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
          }) => '${count} games for ear, fretboard, chords and harmony',
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
          'onboarding.guitarModeTitle' => 'Your guitar is also the remote',
          'onboarding.guitarModeBody' => 'Move around the whole app by playing notes, without putting the guitar down.',
          'onboarding.guitarModeSwitch' => 'Turn on guitar mode',
          'onboarding.guitarModeSwitchHint' => 'It will ask for microphone permission. You can change it in Settings.',
          'onboarding.guitarModeStep1' => 'Play a high note (fret 14 or more on the 1st string) and the menu opens.',
          'onboarding.guitarModeStep2' => 'With the menu open, play the note of the option: on one string, open E and one more fret per destination.',
          'onboarding.guitarModeTry' =>
            'Tap an option to see which note picks it',
          'onboarding.guitarModePreview' => ({
            required Object note,
            required Object fret,
            required Object label,
          }) => '${note} · ${fret} → ${label}',
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
          'minigames.prompt.scaleNote' => ({
            required Object scale,
          }) => 'Which note is in ${scale}?',
          'minigames.prompt.keyChord' => ({
            required Object key,
            required Object degree,
          }) => 'In ${key}, which chord is the ${degree}?',
          'minigames.prompt.scaleDegree' => ({
            required Object key,
            required Object note,
          }) => 'In ${key}, which degree is ${note}?',
          'minigames.prompt.findTonic' =>
            'Listen to the cadence. Which note is the tonic?',
          'minigames.prompt.progressionEar' => 'Which progression is playing?',
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
          _ => null,
        } ??
        switch (path) {
          'minigames.titles.fretOfNote' => 'Find the note',
          'minigames.titles.fingerQuiz' => 'Which finger?',
          'minigames.titles.readDiagram' => 'Read the diagram',
          'minigames.titles.buildChord' => 'Build the chord',
          'minigames.titles.playNote' => 'Play the note',
          'minigames.titles.playStringFret' => 'String and fret',
          'minigames.titles.echo' => 'Guitar echo',
          'minigames.titles.scaleNote' => 'Scale notes',
          'minigames.titles.keyChord' => 'Chords in a key',
          'minigames.titles.scaleDegree' => 'Which degree?',
          'minigames.titles.findTonic' => 'Find the tonic',
          'minigames.titles.progressionEar' => 'Progression by ear',
          'minigames.descriptions.guessNote' =>
            'A note plays: which one is it?',
          'minigames.descriptions.whichString' => 'Recognise the open string',
          'minigames.descriptions.whichFret' => 'Hear how many frets it rises',
          'minigames.descriptions.interval' => 'Distance between two notes',
          'minigames.descriptions.higherLower' => 'Compare two notes',
          'minigames.descriptions.chordQuality' =>
            'Tell major, minor and seventh apart',
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
          'minigames.descriptions.scaleNote' =>
            'Spot which note belongs to each scale',
          'minigames.descriptions.keyChord' =>
            'The IV of G, the V of A… instantly',
          'minigames.descriptions.scaleDegree' =>
            'Number every note in the key',
          'minigames.descriptions.findTonic' =>
            'Listen and find the \'home\' note',
          'minigames.descriptions.progressionEar' =>
            'Tell I-IV-V from I-V-vi-IV',
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
          'minigames.howTo.scaleNote' => 'A scale and its tonic are shown. Pick the only option that belongs to that scale. Use the formula or picture the box on the neck.',
          'minigames.howTo.keyChord' => 'A key and a degree in Roman numerals are shown. Pick the chord on that degree. Remember: in major, I IV V are major; ii iii vi are minor.',
          'minigames.howTo.scaleDegree' => 'A key and a note are shown. Say which degree it is (I = tonic, IV = subdominant, V = dominant…).',
          'minigames.howTo.findTonic' => 'A four-chord cadence plays and ends at home. Pick the note that sounds like rest: the tonic.',
          'minigames.howTo.progressionEar' => 'Four chords play. Pick which progression it is, written in degrees. Notice whether it starts major or minor and how it gets back home.',
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
          'minigames.theoryTitle' => 'Music theory',
          'minigames.theorySubtitle' =>
            'Scales, keys, degrees and progressions: understand what you play.',
          'chordGames.chordsTitle' => 'Chords and variants',
          'chordGames.chordsSubtitle' =>
            'Notes, formulas, diagrams, CAGED shapes and timed challenges',
          'chordGames.harmonyTitle' => 'Progressions and harmony',
          'chordGames.harmonySubtitle' =>
            'Degrees, transposing, relatives and styles',
          'chordGames.newBadge' => 'New',
          'chordGames.searchHint' => 'Search games',
          'chordGames.filterAll' => 'All',
          'chordGames.filterNew' => 'New',
          'chordGames.filterLabel' => 'Filter by family',
          'chordGames.noResultsTitle' => 'No game matches',
          'chordGames.noResultsBody' =>
            'Try another word or remove the filter.',
          'chordGames.clearSearch' => 'Clear the search',
          'chordGames.gamesCount' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('en'))(
                  n,
                  one: '${n} game',
                  other: '${n} games',
                ),
          'chordGames.timeUp' => 'Time is up!',
          'chordGames.timeLeft' => ({required Object n}) => '${n} s',
          'chordGames.speedBonus' => ({
            required Object n,
          }) => 'Speed: +${n} points',
          'chordGames.perQuestion' => ({
            required Object n,
          }) => 'Time per question: ${n} s',
          'chordGames.changesGoal' => ({
            required Object goal,
            required Object seconds,
          }) => 'Goal: ${goal} clean changes in ${seconds} s',
          'chordGames.titles.spellChord' => 'Spell the chord',
          'chordGames.titles.chordFormula' => 'Chord formula',
          'chordGames.titles.chordVariantEar' => 'Which variant is it?',
          'chordGames.titles.chordMemory' => 'Chord memory',
          'chordGames.titles.rootAndBass' => 'Root and bass',
          'chordGames.titles.inversion' => 'Inversions',
          'chordGames.titles.wrongDiagram' => 'Wrong diagram',
          'chordGames.titles.cagedShape' => 'CAGED shapes',
          'chordGames.titles.rushOpen' => 'Rush: open chords',
          'chordGames.titles.rushBarre' => 'Rush: barre chords',
          'chordGames.titles.rushSeventh' => 'Rush: seventh chords',
          'chordGames.titles.fillProgression' => 'Complete the progression',
          'chordGames.titles.romanDegree' => 'Roman numerals',
          'chordGames.titles.transposeChord' => 'Transpose',
          'chordGames.titles.chordNeighbors' => 'Relatives and fifths',
          'chordGames.titles.styleDuel' => 'Style duel',
          'chordGames.titles.chordChanges' => 'Chord changes',
          'chordGames.descriptions.spellChord' =>
            'Which notes make up each chord?',
          'chordGames.descriptions.chordFormula' =>
            'From the chord to its 1-3-5… formula and back',
          'chordGames.descriptions.chordVariantEar' =>
            'Hear maj7, 7, 6, sus… and tell the variant',
          'chordGames.descriptions.chordMemory' =>
            'Repeat the chords you hear in order',
          'chordGames.descriptions.rootAndBass' =>
            'Where the root is and which note is in the bass',
          'chordGames.descriptions.inversion' =>
            'Root position, 1st or 2nd inversion',
          'chordGames.descriptions.wrongDiagram' =>
            'Find the diagram with a mistake',
          'chordGames.descriptions.cagedShape' =>
            'Tell C, A, G, E, D and where the barre goes',
          'chordGames.descriptions.rushOpen' =>
            'Name open chords against the clock',
          'chordGames.descriptions.rushBarre' =>
            'Name barre chords against the clock',
          'chordGames.descriptions.rushSeventh' =>
            'Sevenths and extended chords against the clock',
          'chordGames.descriptions.fillProgression' => 'Find the missing chord',
          'chordGames.descriptions.romanDegree' =>
            'From the IV to the chord and back',
          'chordGames.descriptions.transposeChord' =>
            'Move up in semitones and play with a capo',
          'chordGames.descriptions.chordNeighbors' =>
            'Relative, dominant, subdominant and fifths',
          'chordGames.descriptions.styleDuel' =>
            'Which genre is it? Progression and strumming',
          'chordGames.descriptions.chordChanges' =>
            'Clean changes in 60 seconds',
          'chordGames.howTo.spellChord' => 'You will see a chord name. On easy and medium pick the group of notes that makes it up: C6 and A minor 7 share notes, so watch the root. On hard, play the notes of the chord from the root up.',
          'chordGames.howTo.chordFormula' => 'Every chord is built with intervals from its root: 1-3-5 is major, 1-♭3-5 minor, 1-3-5-♭7 dominant seventh… Go from the chord to its formula or from the formula to the chord name.',
          'chordGames.howTo.chordVariantEar' => 'You will hear a chord and be told its root. Tell which variant it is: major, minor, 7, maj7, 6, sus… The higher the level, the more look-alike variants there are.',
          'chordGames.howTo.chordMemory' => 'You will hear a series of chords. Tap the chords in the same order they played. Each level adds more chords and more options.',
          'chordGames.howTo.rootAndBass' => 'You will see the diagram of a position. Sometimes you must say which string holds the lowest root and other times which note is in the bass, the lowest string that sounds.',
          'chordGames.howTo.inversion' => 'A chord is in root position when the root is in the bass; with the third in the bass it is the 1st inversion and with the fifth, the 2nd. On hard you only hear it: listen to the bass.',
          'chordGames.howTo.wrongDiagram' => 'You will see several diagrams of the same chord and one has a mistake: a note that is not in the chord, a string that should be muted or an essential note that is missing. Find it.',
          'chordGames.howTo.cagedShape' => 'Barre chords move along the neck with five shapes: C, A, G, E and D. Recognise the shape of a diagram or say which fret the barre goes on to play a chord with a given shape.',
          'chordGames.howTo.rushOpen' => 'A race against the clock: the diagram of an open chord appears and you have a few seconds to name it. The faster you answer, the more points.',
          'chordGames.howTo.rushBarre' => 'A race against the clock: the diagram of a barre chord appears and you have a few seconds to name it. The faster you answer, the more points.',
          'chordGames.howTo.rushSeventh' => 'A race against the clock: the diagram of a seventh or extended chord appears and you have a few seconds to say which one it is. The faster you answer, the more points.',
          'chordGames.howTo.fillProgression' => 'You will see a famous progression with one hidden chord (?). Pick the missing one; on hard, pick its Roman numeral. On easy and medium you can hear the rest of the progression.',
          'chordGames.howTo.romanDegree' => 'Roman numerals name the chords of a key: in G major the IV is C and the V7 is D7. Go from the numeral to the chord and back; on hard there are sevenths and borrowed chords such as the ♭VII.',
          'chordGames.howTo.transposeChord' => 'Transposing means moving a chord up or down. With a capo on fret N, the shape you play sounds N semitones higher. Solve moves up, down and capo questions.',
          'chordGames.howTo.chordNeighbors' => 'Every chord has neighbours: its relative (shares the scale notes), its dominant (V), its subdominant (IV) and the ones next to it on the circle of fifths. Find the one you are asked for.',
          'chordGames.howTo.styleDuel' => 'You will hear the first bars of a progression with its strumming. From the chords and the rhythm, say the genre: pop, rock, blues, reggae…',
          'chordGames.howTo.chordChanges' => 'We ask for chords one after another: play it and change as soon as you can. Every clean change counts; you have 60 seconds and the goal number of changes gives three stars.',
          'chordGames.prompt.spellSet' => ({
            required Object chord,
          }) => 'Which notes make up ${chord}?',
          'chordGames.prompt.spellOrder' => ({
            required Object chord,
          }) => 'Play the notes of ${chord}, from the root up',
          'chordGames.prompt.formulaTo' => ({
            required Object chord,
          }) => 'What is the formula of ${chord}?',
          'chordGames.prompt.formulaName' => ({
            required Object note,
            required Object formula,
          }) => 'Which chord on root ${note} has the formula ${formula}?',
          'chordGames.prompt.variantEar' => ({
            required Object note,
          }) => 'A chord on root ${note} is playing. Which variant is it?',
          'chordGames.prompt.chordMemory' =>
            'Listen and repeat the chords in the same order',
          'chordGames.prompt.rootString' => ({
            required Object chord,
          }) => 'Which string holds the lowest root of this ${chord}?',
          'chordGames.prompt.bassNote' => ({
            required Object chord,
          }) => 'Which note is in the bass (the lowest sounding string) of this ${chord}?',
          'chordGames.prompt.inversionDiagram' => ({
            required Object chord,
          }) => 'Which inversion is this ${chord} in?',
          'chordGames.prompt.inversionEar' => ({
            required Object chord,
          }) => 'Listen to this ${chord}. Which inversion is playing?',
          'chordGames.prompt.wrongDiagram' => ({
            required Object chord,
          }) => 'One of these ${chord} diagrams has a mistake. Which one?',
          'chordGames.prompt.cagedShape' => ({
            required Object chord,
          }) => 'Which CAGED shape is this ${chord}?',
          'chordGames.prompt.cagedBarre' => ({
            required Object chord,
            required Object shape,
          }) => 'To play ${chord} with the ${shape} shape, which fret does the barre go on?',
          'chordGames.prompt.rush' => 'Which chord is this?',
          'chordGames.prompt.fillChord' => ({
            required Object genre,
            required Object key,
          }) => 'Complete the ${genre} progression in ${key}: which chord is missing?',
          'chordGames.prompt.fillRoman' => ({
            required Object genre,
            required Object key,
          }) => 'Complete the ${genre} progression in ${key}: which degree is missing?',
          'chordGames.prompt.romanToChord' => ({
            required Object key,
            required Object roman,
          }) => 'In ${key}, which chord is the ${roman}?',
          'chordGames.prompt.romanToRoman' => ({
            required Object key,
            required Object chord,
          }) => 'In ${key}, which degree is ${chord}?',
          'chordGames.prompt.transposeUp' =>
            ({required num n, required Object chord}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('en'))(
                  n,
                  one: 'Move ${chord} up one semitone. Which chord do you get?',
                  other:
                      'Move ${chord} up ${n} semitones. Which chord do you get?',
                ),
          'chordGames.prompt.transposeDown' =>
            ({
              required num n,
              required Object chord,
            }) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
              n,
              one: 'Move ${chord} down one semitone. Which chord do you get?',
              other:
                  'Move ${chord} down ${n} semitones. Which chord do you get?',
            ),
          'chordGames.prompt.capoSounds' => ({
            required Object n,
            required Object chord,
          }) => 'With a capo on fret ${n} you play the ${chord} shape. Which chord sounds?',
          'chordGames.prompt.capoShape' => ({
            required Object n,
            required Object chord,
          }) => 'With a capo on fret ${n} you want ${chord} to sound. Which shape do you play?',
          'chordGames.prompt.relativeMinor' => ({
            required Object chord,
          }) => 'What is the relative minor of ${chord}?',
          'chordGames.prompt.relativeMajor' => ({
            required Object chord,
          }) => 'What is the relative major of ${chord}?',
          'chordGames.prompt.dominant' => ({
            required Object chord,
          }) => 'What is the dominant (V) of ${chord}?',
          'chordGames.prompt.subdominant' => ({
            required Object chord,
          }) => 'What is the subdominant (IV) of ${chord}?',
          'chordGames.prompt.fifthUp' => ({
            required Object chord,
          }) => 'On the circle of fifths, which chord is a fifth above ${chord}?',
          'chordGames.prompt.fifthDown' => ({
            required Object chord,
          }) => 'On the circle of fifths, which chord is a fifth below ${chord}?',
          'chordGames.prompt.parallel' => ({
            required Object chord,
          }) => 'What is the parallel chord of ${chord} (same note, other mode)?',
          'chordGames.prompt.tritone' => ({
            required Object chord,
          }) => 'What is the tritone substitution of ${chord}?',
          'chordGames.prompt.styleDuel' =>
            'Listen to the progression and the strumming. Which genre is it?',
          'chordGames.choice.inversionRoot' => 'Root position',
          'chordGames.choice.inversionFirst' => '1st inversion',
          'chordGames.choice.inversionSecond' => '2nd inversion',
          'chordGames.choice.inversionThird' => '3rd inversion',
          'chordGames.choice.diagram' => ({
            required Object n,
          }) => 'Diagram ${n}',
          'chordGames.explain.alienNote' => ({
            required Object string,
            required Object note,
            required Object chord,
          }) => 'On the ${string} you hear ${note}, which is not a note of ${chord}.',
          'chordGames.explain.unmutedString' => ({
            required Object string,
            required Object note,
            required Object chord,
          }) => 'The ${string} should be muted: open it sounds ${note}, which is not in ${chord}.',
          'chordGames.explain.missingNote' => ({
            required Object note,
            required Object chord,
          }) => '${note} is missing, one of the notes that define ${chord}.',
          'chordGames.explain.styleDuel' => ({
            required Object genre,
          }) => 'It was ${genre}.',
          'chordGames.explain.shape' => ({
            required Object shape,
          }) => 'It is the ${shape} shape.',
          'chordGames.changes.getReady' => 'Get ready…',
          'chordGames.changes.startsIn' => ({
            required Object n,
          }) => 'Starting in ${n}',
          'chordGames.changes.playThis' => 'Play this chord',
          'chordGames.changes.clean' => 'Clean changes',
          'chordGames.changes.goal' => ({required Object n}) => 'Goal: ${n}',
          'chordGames.changes.heard' => ({
            required Object count,
            required Object total,
          }) => 'Notes heard: ${count} of ${total}',
          'chordGames.changes.hear' => 'Hear the chord',
          'chordGames.changes.skip' => 'Skip chord',
          'chordGames.changes.listening' => 'Listening…',
          'chordGames.changes.cleanChange' => 'Clean change!',
          'chordGames.changes.missed' => 'Time ran out on this chord',
          'chordGames.changes.timeLeft' => ({
            required Object n,
          }) => '${n} s left',
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
          'guitar.hubSubtitle' =>
            'The whole app with your guitar: a high note opens the menu',
          'guitar.hubSelected' => ({
            required Object name,
            required Object n,
            required Object total,
          }) => '${name} · ${n} of ${total}',
          'guitar.navMenu' => 'Menu',
          'guitar.navTitle' => 'Guitar menu',
          'guitar.navWake' =>
            'High note (fret 14 or more on the 1st string): menu',
          'guitar.navHint' =>
            'On any string: open E, then one fret more per destination',
          'guitar.navBack' => 'Back',
          'guitar.navClose' => 'Close',
          'guitar.navOff' => 'Turn off',
          'guitar.navProfile' => 'Profile',
          'guitar.navWakeShort' => 'High note',
          'guitar.navFretOpen' => 'open',
          'guitar.navFret' => ({required Object n}) => 'fret ${n}',
          'guitar.navSetting' => 'Guitar mode across the app',
          'guitar.navSettingSubtitle' => 'A fixed panel replaces the navigation bar: a high note opens the menu and each note takes you to a screen',
          'theory.title' => 'Guitar school',
          'theory.subtitle' =>
            'Understand what you play: tonic, scales, positions and harmony.',
          'theory.unitBasics' => 'Fundamentals',
          'theory.unitScales' => 'Scales and positions',
          'theory.unitHarmony' => 'Harmony and progressions',
          'theory.keyPoints' => 'Key ideas',
          'theory.tryIt' => 'Try it on the fretboard',
          'theory.openExplorer' => 'Open in the explorer',
          'theory.practiceGame' => ({
            required Object game,
          }) => 'Practice: ${game}',
          'theory.practiceJam' => ({required Object name}) => 'Jam it: ${name}',
          'theory.markLearned' => 'Mark as learned',
          'theory.learned' => 'Learned',
          'theory.lessonsDone' => ({
            required Object done,
            required Object total,
          }) => '${done} of ${total} lessons learned',
          'theory.harmonyTitle' => ({
            required Object key,
          }) => 'Chords of ${key}',
          'theory.scaleIn' => ({
            required Object note,
            required Object scale,
          }) => '${note} ${scale}',
          'theory.keyName' => ({
            required Object note,
            required Object mode,
          }) => '${note} ${mode}',
          'theory.majorMode' => 'major',
          'theory.minorMode' => 'minor',
          'theory.explorerTitle' => 'Scale explorer',
          'theory.explorerTonic' => 'Tonic',
          'theory.explorerScale' => 'Scale',
          'theory.explorerPosition' => 'Position',
          'theory.allPositions' => 'Whole neck',
          'theory.positionN' => ({required Object n}) => 'Position ${n}',
          'theory.showDegrees' => 'Degrees',
          'theory.showNotes' => 'Notes',
          'theory.playScale' => 'Listen',
          'theory.stopScale' => 'Stop',
          'theory.explorerHint' => 'Tap a note on the fretboard to hear it. Tonics use the main color and the signature note is highlighted.',
          'theory.formula' => ({
            required Object formula,
          }) => 'Formula: ${formula}',
          'theory.notesOf' => ({required Object notes}) => 'Notes: ${notes}',
          'theory.fretboardLabel' => ({
            required Object scale,
          }) => 'Fretboard showing ${scale}',
          'theory.genresTitle' => 'Genres',
          'theory.genresSubtitle' => 'How each style sounds: tempo, strumming, scales, chords and progressions.',
          'theory.tempoRange' => ({
            required Object min,
            required Object max,
          }) => '${min}–${max} BPM',
          'theory.genreRhythmTitle' => 'Rhythm',
          'theory.genreTipTitle' => 'Tip',
          'theory.genreScales' => 'Scales for soloing',
          'theory.genreChords' => 'Typical chords',
          'theory.genreProgressions' => 'Progressions to jam',
          'theory.genreSongs' => 'Songs',
          'theory.genreLibrary' => ({
            required Object genre,
          }) => 'See ${genre} chords in the library',
          'theory.strumLabel' => ({
            required Object name,
          }) => 'Strumming: ${name}',
          'theory.scaleNames.major' => 'major',
          'theory.scaleNames.minor' => 'natural minor',
          'theory.scaleNames.harmonicMinor' => 'harmonic minor',
          'theory.scaleNames.minorPentatonic' => 'minor pentatonic',
          'theory.scaleNames.majorPentatonic' => 'major pentatonic',
          'theory.scaleNames.blues' => 'blues scale',
          'theory.scaleNames.dorian' => 'dorian',
          'theory.scaleNames.phrygian' => 'phrygian',
          'theory.scaleNames.lydian' => 'lydian',
          'theory.scaleNames.mixolydian' => 'mixolydian',
          'theory.scaleAbout.major' => 'The foundation of harmony: happy and stable. Pop, folk and children\'s songs.',
          'theory.scaleAbout.minor' => 'The major\'s relative: melancholic and epic. Ballads, rock and metal.',
          'theory.scaleAbout.harmonicMinor' => 'Minor with a raised seventh: classical, flamenco and neoclassical flavor.',
          'theory.scaleAbout.minorPentatonic' =>
            'Five notes that never fail: the heart of rock and blues.',
          'theory.scaleAbout.majorPentatonic' =>
            'Sweet and open: country, pop, soul and melodic solos.',
          'theory.scaleAbout.blues' =>
            'Minor pentatonic plus the blue note (b5): pure attitude.',
          'theory.scaleAbout.dorian' =>
            'Minor with a major sixth: funk, jazz, Santana and Pink Floyd.',
          'theory.scaleAbout.phrygian' =>
            'Minor with a minor second: flamenco and dark metal.',
          'theory.scaleAbout.lydian' =>
            'Major with a raised fourth: dreamy, soundtrack-like.',
          'theory.scaleAbout.mixolydian' =>
            'Major with a minor seventh: classic rock, blues and country.',
          'theory.degreeNames.d1' => 'tonic',
          'theory.degreeNames.d2' => 'supertonic',
          'theory.degreeNames.d3' => 'mediant',
          'theory.degreeNames.d4' => 'subdominant',
          'theory.degreeNames.d5' => 'dominant',
          'theory.degreeNames.d6' => 'submediant',
          'theory.degreeNames.d7' => 'leading tone',
          'theory.strumNames.whole' => 'One strum per bar',
          'theory.strumNames.quarters' => 'Quarter notes',
          'theory.strumNames.pop' => 'Pop',
          'theory.strumNames.eighths' => 'Eighth notes',
          'theory.strumNames.boomChick' => 'Boom-chick',
          'theory.strumNames.skank' => 'Offbeat (reggae)',
          'theory.strumNames.bossa' => 'Bossa nova',
          'theory.strumNames.shuffle' => 'Shuffle',
          'theory.strumNames.waltz' => 'Waltz 3/4',
          'theory.genreNames.pop' => 'Pop',
          'theory.genreNames.rock' => 'Rock',
          'theory.genreNames.blues' => 'Blues',
          'theory.genreNames.country' => 'Country',
          'theory.genreNames.jazz' => 'Jazz',
          'theory.genreNames.funk' => 'Funk',
          'theory.genreNames.ballad' => 'Ballad',
          'theory.genreNames.latin' => 'Latin',
          'theory.genreNames.reggae' => 'Reggae',
          'theory.genreNames.bossa' => 'Bossa nova',
          'theory.genreNames.metal' => 'Metal',
          'theory.genreNames.punk' => 'Punk',
          'theory.genreNames.soul' => 'Soul and R&B',
          'theory.genreNames.gospel' => 'Gospel',
          'theory.genreNames.folk' => 'Folk and traditional',
          'theory.genreAbout.pop' => 'Catchy songs over a few progressions (I-V-vi-IV). The guitar backs them with open chords and a steady strum.',
          'theory.genreAbout.rock' => 'Power chords, driving eighth notes and minor pentatonic riffs. I-IV-V and the bVII rule.',
          'theory.genreAbout.blues' => 'Twelve bars, seventh chords and the blues scale. Feel matters more than speed.',
          'theory.genreAbout.country' => 'Open chords, alternating bass and major pentatonic melodies. Simple stories and lots of swing in the picking hand.',
          'theory.genreAbout.jazz' => 'Seventh chords (maj7, m7, 7), the ii-V-I and constant key changes. Played light and swinging.',
          'theory.genreAbout.funk' => 'Ninth and m7 chords played short and percussive. The guitar is part of the drum kit.',
          'theory.genreAbout.ballad' => 'Slow tempos and chords left ringing. Arpeggios or one strum per beat.',
          'theory.genreAbout.latin' => 'From the ranchera in 3/4 to the Andalusian cadence and bolero. Lots of harmonic minor.',
          'theory.genreAbout.reggae' => 'The chord only sounds on the offbeats, short and dry. Bass and drums carry the beat.',
          'theory.genreAbout.bossa' => 'Soft seventh chords, thumb bass and syncopated chords with the fingers.',
          'theory.genreAbout.metal' => 'Palm-muted power chords, fast tempos and minor, phrygian and harmonic scales.',
          'theory.genreAbout.punk' => 'Three or four power chords, downstroked eighths and lots of speed. Attitude first.',
          'theory.genreAbout.soul' => 'Color chords (maj7, m7, 9), a relaxed groove and major pentatonic fills.',
          'theory.genreAbout.gospel' => 'Church harmony: I-IV-V with sevenths, the minor iv and plagal (\'amen\') cadences.',
          'theory.genreAbout.folk' => 'Timeless songs with three or four open chords. Perfect for singing along.',
          'theory.genreRhythm.pop' => '↓ ↓↑ ↑↓↑ in 4/4. Accent beats 2 and 4.',
          'theory.genreRhythm.rock' =>
            'Down or down-up eighths, palm-muted in the verses.',
          'theory.genreRhythm.blues' =>
            'Shuffle: each beat long-short (da-ga da-ga).',
          'theory.genreRhythm.country' => 'Boom-chick: bass on 1 and 3, strum on 2 and 4, alternating the bass string.',
          'theory.genreRhythm.jazz' =>
            'Four short strums per bar (Freddie Green style), swinging.',
          'theory.genreRhythm.funk' => 'Sixteenths with the hand always moving; mostly muted with a few open hits.',
          'theory.genreRhythm.ballad' => 'One strum per bar or a slow arpeggio from the 6th to the 1st string.',
          'theory.genreRhythm.latin' => 'Ranchera: bass-chord-chord (3/4). Rumba: strum accenting the offbeat.',
          'theory.genreRhythm.reggae' =>
            'Silence on 1, a dry hit on 2 and 4 (skank).',
          'theory.genreRhythm.bossa' =>
            'Thumb on the bass every beat and a syncopated chord in between.',
          'theory.genreRhythm.metal' =>
            'Eighths or gallop (an eighth and two sixteenths), palm-muted.',
          'theory.genreRhythm.punk' =>
            'All-downstroke eighths, fast and steady.',
          'theory.genreRhythm.soul' =>
            'Soft hits on 2 and 4 with fills between chords.',
          'theory.genreRhythm.gospel' =>
            'Firm quarter notes accenting 2 and 4; call and response.',
          'theory.genreRhythm.folk' =>
            'Quarters or the pop pattern; in 3/4, bass plus two strums.',
          'theory.genreTip.pop' =>
            'Learn I-V-vi-IV in G, C and D: you\'ll play hundreds of songs.',
          'theory.genreTip.rock' =>
            'Palm-mute the verses and let the chorus ring open.',
          'theory.genreTip.blues' => 'Bend the 4th up to the 5th of the scale and end phrases on the tonic.',
          'theory.genreTip.country' => 'Alternate the bass between the root and the fifth for the classic boom-chick.',
          'theory.genreTip.jazz' => 'Learn m7, 7 and maj7 shapes rooted on the 6th and 5th strings: they cover 90%.',
          'theory.genreTip.funk' => 'Strum close to the bridge and relax the fretting hand to mute between hits.',
          'theory.genreTip.ballad' =>
            'Let chords ring and change right before beat 1, not late.',
          'theory.genreTip.latin' => 'In the Andalusian cadence use harmonic minor over the V chord (E major in A minor).',
          'theory.genreTip.reggae' =>
            'Play the skank on the top three strings and mute it right away.',
          'theory.genreTip.bossa' =>
            'Practice the thumb bass alone before adding the chords.',
          'theory.genreTip.metal' =>
            'Dial in the palm mute: hand on the bridge, not too far on or off.',
          'theory.genreTip.punk' =>
            'Keep the wrist loose: speed comes from relaxation.',
          'theory.genreTip.soul' =>
            'Play chords on the top three or four strings for a clean sound.',
          'theory.genreTip.gospel' =>
            'Try IV → iv → I: the major-to-minor change is pure emotion.',
          'theory.genreTip.folk' =>
            'Sing while you play: the strumming hand should run on autopilot.',
          'theory.progressionNames.popAxis' => 'The pop axis',
          'theory.progressionNames.dooWop' => '50s doo-wop',
          'theory.progressionNames.rockClassic' => 'Classic rock I-IV-V',
          'theory.progressionNames.rockMixo' => 'Rock with bVII',
          'theory.progressionNames.blues12' => '12-bar blues',
          'theory.progressionNames.bluesMinor' => 'Minor blues',
          'theory.progressionNames.countryRoad' => 'Country road',
          'theory.progressionNames.countryTwoStep' => 'Two-step',
          'theory.progressionNames.jazz251' => 'Jazz ii-V-I',
          'theory.progressionNames.jazzTurnaround' => 'Turnaround',
          'theory.progressionNames.funkDorian' => 'Dorian vamp',
          'theory.progressionNames.balladSad' => 'Heartfelt ballad',
          'theory.progressionNames.canon' => 'Pachelbel\'s canon',
          'theory.progressionNames.andalusian' => 'Andalusian cadence',
          'theory.progressionNames.ranchera' => 'Ranchera tonic-dominant',
          'theory.progressionNames.reggaeSkank' => 'Reggae skank',
          'theory.progressionNames.bossaCycle' => 'Bossa cycle',
          'theory.progressionNames.metalMinor' => 'Minor metal',
          'theory.progressionNames.metalPhrygian' => 'Phrygian metal',
          'theory.progressionNames.punkPower' => 'Full-speed punk',
          'theory.progressionNames.soulGroove' => 'Soul groove',
          'theory.progressionNames.gospelPlagal' => 'Gospel with minor iv',
          'theory.progressionNames.folkThree' => 'Three-chord folk',
          'theory.lessonTitles.notes' => 'Notes and the fretboard',
          'theory.lessonTitles.intervals' =>
            'Intervals: the distance between notes',
          'theory.lessonTitles.tonic' => 'The tonic and the key',
          'theory.lessonTitles.rhythm' => 'Rhythm, meter and strumming',
          'theory.lessonTitles.majorScale' => 'The major scale',
          'theory.lessonTitles.minorScales' => 'Minor scales',
          'theory.lessonTitles.pentatonic' =>
            'Pentatonics: the soloist\'s scale',
          'theory.lessonTitles.positions' => 'Scale positions (boxes)',
          'theory.lessonTitles.blues' => 'The blues and the blue note',
          'theory.lessonTitles.modes' => 'The Greek modes',
          'theory.lessonTitles.harmony' => 'Harmony: the chords of a key',
          'theory.lessonTitles.degrees' => 'Degrees and functions',
          'theory.lessonTitles.progressions' => 'Famous progressions',
          'theory.lessonTitles.caged' => 'The CAGED system',
          'theory.lessonSummaries.notes' => 'The 12 notes, sharps and flats, and how to find them on the guitar.',
          'theory.lessonSummaries.intervals' => 'Half steps, thirds, fifths and octaves: the DNA of scales and chords.',
          'theory.lessonSummaries.tonic' =>
            'A song\'s \'home\' note and how to tell what key it\'s in.',
          'theory.lessonSummaries.rhythm' =>
            'The beat, 4/4 and 3/4, eighth notes and each genre\'s patterns.',
          'theory.lessonSummaries.majorScale' =>
            'The W-W-H-W-W-W-H formula, the mother of harmony.',
          'theory.lessonSummaries.minorScales' =>
            'Natural minor, harmonic minor and the relative minor.',
          'theory.lessonSummaries.pentatonic' =>
            'Five notes that never sound wrong: the shortcut to improvising.',
          'theory.lessonSummaries.positions' =>
            'Position theory: splitting the neck into boxes that fit together.',
          'theory.lessonSummaries.blues' =>
            'The blues scale, the shuffle and the 12-bar form.',
          'theory.lessonSummaries.modes' => 'Seven colors of the same scale: dorian, phrygian, lydian, mixolydian…',
          'theory.lessonSummaries.harmony' =>
            'Every scale note builds a chord: the diatonic chords.',
          'theory.lessonSummaries.degrees' =>
            'Tonic, subdominant and dominant: rest, motion and tension.',
          'theory.lessonSummaries.progressions' =>
            'The chord combinations behind thousands of songs.',
          'theory.lessonSummaries.caged' =>
            'Five open chord shapes that cover the whole neck.',
          'theory.lessonBodies.notes' => 'Western music uses only 12 notes that repeat in octaves: C, C♯, D, D♯, E, F, F♯, G, G♯, A, A♯ and B.\n\nBetween two neighboring notes there is a half step, and on the guitar a half step is exactly one fret; two frets make a whole step. There is no sharp between E and F or between B and C: they are a half step apart.\n\nA sharp (♯) raises a note a half step and a flat (♭) lowers it, so C♯ and D♭ are the same note with two names. At the 12th fret every string repeats its open note an octave higher: that\'s where the neck starts over.',
          'theory.lessonBodies.intervals' => 'An interval is the distance between two notes, measured in half steps (frets). Each distance has its own color: the major third (4 half steps) sounds happy, the minor third (3) sad and the perfect fifth (7) solid and open.\n\nChords are built by stacking intervals on a root: a major chord is root + major third + fifth; a minor chord only changes the third. That\'s why moving a single note one fret turns C into C minor.\n\nOn the guitar every interval has a shape: the fifth is on the next (higher) string, two frets up, and the octave two strings over and two frets up. When crossing the 2nd (B) string the shape shifts one fret.',
          'theory.lessonBodies.tonic' => 'The tonic is the note a song revolves around: the home everything wants to return to. When the melody or chord lands on the tonic we feel rest; moving away creates tension.\n\nThe key is the tonic plus its scale. \'G major\' means G is home and the notes come from the G major scale. Almost every song ends, and many start, on the tonic chord.\n\nTo find a song\'s key, look for the chord that sounds like an ending, check that the other chords belong to that key and sing the note that \'closes\' the melody. With practice you\'ll hear it instantly: play \'Find the tonic\'.',
          'theory.lessonBodies.rhythm' => 'The beat is music\'s steady pulse. Meter groups beats: 4/4 (four per bar) is the meter of pop, rock and almost everything; 3/4 belongs to the waltz, the ranchera and many folk songs.\n\nEach beat splits into two eighth notes: down on the beat (\'1\') and up on the offbeat (\'and\'). The strumming hand always moves down-up like a pendulum, even when it doesn\'t hit the strings: that way the rhythm never breaks.\n\nEach genre has its pattern: pop (↓ ↓↑ ↑↓↑), rock (eighths), country (boom-chick), reggae (offbeats only) or blues (shuffle). Jam mode shows the pattern stroke by stroke while you play.',
          'theory.lessonBodies.majorScale' => 'The major scale has seven notes and always follows the same formula of whole (W) and half (H) steps: W W H W W W H. From C you get C D E F G A B, all natural notes.\n\nWith the formula you can build it from any note. From G: G A B C D E F♯; the F♯ appears to keep the last whole step before the final half step.\n\nOn a single string you play the major scale by counting frets: 2, 2, 1, 2, 2, 2, 1. Try it on the 5th string from the 3rd fret (C) and hear the famous do-re-mi. The explorer shows its seven three-notes-per-string positions.',
          'theory.lessonBodies.minorScales' => 'The natural minor scale changes the formula: W H W W H W W. A minor uses the same notes as C major (A B C D E F G), but starting on A makes everything darker: it is C\'s relative minor.\n\nEvery major key has a relative minor three half steps below (G major ↔ E minor). They share notes and chords; only home changes.\n\nThe harmonic minor raises the seventh note a half step (G♯ in A minor). That note makes the fifth-degree chord major (E major in A minor), which pulls hard toward the tonic: the sound of flamenco, classical music and many boleros.',
          'theory.lessonBodies.pentatonic' => 'The pentatonic is a five-note scale: it drops the two most tense notes of the major or minor scale. That\'s why almost any note you play over the song\'s chords will sound good.\n\nThe minor pentatonic (1 b3 4 5 b7) is the backbone of rock and blues: A C D E G in A minor. The major pentatonic (1 2 3 5 6) sounds sweet and open, typical of country and pop: C D E G A in C.\n\nKey trick: A minor pentatonic and C major pentatonic share the same notes. The same shape with a different tonic gives you both sounds. Lean on the major tonic to sound major, on the minor one to sound bluesy.',
          'theory.lessonBodies.positions' => 'A position or box is the group of scale notes you can reach without moving your hand: four or five frets, one finger per fret. The pentatonic has five boxes and seven-note scales have seven three-notes-per-string positions.\n\nBoxes fit together like puzzle pieces: the right edge of one is the left edge of the next, and after the last one the first returns twelve frets higher. Knowing them all lets you play the scale across the whole neck.\n\nPosition 1 of the minor pentatonic starts with the tonic on the 6th string under the index finger. Learn it first, then 2, and connect them by sliding a finger. Changing key needs nothing new: move the whole box to the new tonic.',
          'theory.lessonBodies.blues' => 'The blues scale is the minor pentatonic plus one note: the flat fifth (b5), the famous blue note. In A: A C D D♯ E G. Use it in passing on the way to the fifth; don\'t sit on it.\n\nThe classic blues lasts 12 bars with three seventh chords: four bars of I7, two of IV7, two of I7, then V7, IV7, I7 and V7 to start over (the \'turnaround\').\n\nThe rhythm is the shuffle: each beat splits into a long and a short hit (da-ga, da-ga). Try the \'12-bar blues\' jam and play the blues scale over it.',
          'theory.lessonBodies.modes' => 'If you play the notes of C major starting on another note you get a mode: from D dorian, from E phrygian, from F lydian, from G mixolydian, from A aeolian (natural minor) and from B locrian.\n\nEach mode has a signature note. Dorian is minor with a major sixth (funk, Santana). Phrygian, minor with a minor second (flamenco, metal). Lydian, major with a raised fourth (dreamy, soundtracks). Mixolydian, major with a minor seventh (rock, blues, country).\n\nTo hear them, play the mode over a static chord on its tonic: the signature note stands out. The explorer marks it in another color.',
          'theory.lessonBodies.harmony' => 'If you build a chord on each note of the major scale using only scale notes you get seven chords: I major, ii minor, iii minor, IV major, V major, vi minor and vii diminished. In C: C Dm Em F G Am B°.\n\nThat list is the diatonic harmony and explains why certain chords sound good together: they belong to the same key. Roman numerals let you write progressions independent of key: \'I-V-vi-IV\' is the same in C (C G Am F) as in G (G D Em C).\n\nWith four notes the jazz chords appear: Imaj7, ii7, iii7, IVmaj7, V7, vi7 and viiø. V7 is the only dominant: the one that asks to return to the tonic.',
          'theory.lessonBodies.degrees' => 'Each scale degree has a function. The tonic (I) is rest. The subdominant (IV) gently moves away. The dominant (V) builds tension and wants to resolve to the tonic.\n\nThe other degrees stand in for these three: vi and iii share notes with I (tonic function) and ii resembles IV (subdominant). That\'s why \'I-vi-IV-V\' and \'I-IV-V\' tell the same story: home, journey, tension and return.\n\nOnce you understand functions you can guess a song\'s next chord, figure out songs by ear and write your own progressions.',
          'theory.lessonBodies.progressions' => 'A progression is a repeating sequence of chords. A handful hold up much of popular music: I-V-vi-IV (pop), I-IV-V (rock, country, folk, ranchera), ii-V-I (jazz), vi-IV-I-V (ballads) and the Andalusian cadence i-bVII-bVI-V (flamenco and Latin rock).\n\nBecause they\'re written in degrees you can play them in any key: pick one that\'s comfortable to sing. Learn each progression in two or three keys and you\'ll start recognizing them everywhere.\n\nThe guided jam has all these progressions with backing, metronome, the strumming pattern and the recommended scale to improvise.',
          'theory.lessonBodies.caged' => 'The five open major chord shapes —C, A, G, E and D (C-A-G-E-D)— can move up the neck with a barre. Chained in that order they cover all twelve frets with the same chord.\n\nFor example, C major can be played as a C shape (open), an A shape (barre at fret 3), a G shape (fret 5), an E shape (fret 8) and a D shape (fret 10). Each shape shares notes with the next.\n\nEach CAGED shape matches a major pentatonic box. That\'s how chords and scales connect: you always know which solo notes surround the chord you\'re playing.',
          'theory.lessonPoints.notes' => '12 notes: 7 natural and 5 sharps/flats\n1 fret = 1 half step; 2 frets = 1 whole step\nE–F and B–C are a half step apart\nFret 12 = the same note an octave up\nLearn the notes on the 6th and 5th strings first: they are your barre-chord roots',
          'theory.lessonPoints.intervals' => 'Minor third = 3 half steps (sad)\nMajor third = 4 half steps (happy)\nPerfect fifth = 7 half steps (power chord)\nOctave = 12 half steps: the same note higher\nThe B string shifts shapes by one fret',
          'theory.lessonPoints.tonic' => 'Tonic = rest; moving away = tension\nKey = tonic + scale\nThe last chord is usually the tonic\nEvery major key has a relative minor with the same notes\nTransposing = moving everything by the same number of frets',
          'theory.lessonPoints.rhythm' => '4/4: count 1 and 2 and 3 and 4 and\n3/4: count 1 and 2 and 3 and\nThe hand never stops: down on the beat, up on the \'and\'\nStart slow with a metronome and raise the tempo gradually\nChange chords on the last stroke of the bar',
          'theory.lessonPoints.majorScale' => 'Formula: W W H W W W H (2-2-1-2-2-2-1 frets)\nSeven notes, one of each letter\nIts degrees are numbered 1 to 7\nThe key\'s chords come from it\nIt has 7 three-notes-per-string positions',
          'theory.lessonPoints.minorScales' => 'Natural minor: W H W W H W W\nRelative minor = 3 half steps below the major\nSame notes, different tonic\nHarmonic minor: raised seventh\nA major V in minor gives the flamenco cadence',
          'theory.lessonPoints.pentatonic' => 'Minor: 1 b3 4 5 b7\nMajor: 1 2 3 5 6\nTwo notes per string in each box\nA minor pentatonic = C major pentatonic (same notes)\nEnd your phrases on the tonic to sound resolved',
          'theory.lessonPoints.positions' => 'One box = 4-5 frets, one finger per fret\nPentatonic: 5 boxes; seven-note scales: 7 positions\nBoxes overlap and repeat every 12 frets\nAlways locate the tonics inside the box\nMoving the whole box = changing key',
          'theory.lessonPoints.blues' => 'Blues = minor pentatonic + b5\n12 bars: I7 – IV7 – I7 – V7 – IV7 – I7\nEvery chord is a seventh chord\nShuffle: long-short on each beat\nBends and vibrato give it character',
          'theory.lessonPoints.modes' => 'Ionian = major · Aeolian = natural minor\nDorian: minor with a major 6th\nPhrygian: minor with b2\nLydian: major with #4\nMixolydian: major with b7',
          'theory.lessonPoints.harmony' => 'Uppercase = major · lowercase = minor\nIn major: I ii iii IV V vi vii°\nIn minor: i ii° III iv v VI VII\nRoman numerals = progressions in any key\nV7 pulls toward I',
          'theory.lessonPoints.degrees' => 'I tonic: rest\nIV subdominant: motion\nV dominant: tension that returns to I\nvi and iii act as tonic; ii as subdominant\nV → I is the strongest cadence',
          'theory.lessonPoints.progressions' => 'Pop: I – V – vi – IV\nRock and country: I – IV – V\nJazz: ii – V – I\nBallad: vi – IV – I – V\nAndalusian: i – bVII – bVI – V',
          'theory.lessonPoints.caged' => 'Order: C → A → G → E → D → C…\nEach shape is a movable open chord\nTogether they cover the whole neck\nEach shape sits on a pentatonic box\nThe root is always inside the shape',
          'studio.sectionTitle' => 'Explore the guitar',
          'studio.theoryCard' => 'Theory',
          'studio.theoryCardBody' => 'Tonic, scales, pentatonics and harmony',
          'studio.scalesCard' => 'Scales',
          'studio.scalesCardBody' => 'Interactive fretboard with positions',
          'studio.genresCard' => 'Genres',
          'studio.genresCardBody' => 'Rhythms and chords of each style',
          'studio.jamCard' => 'Guided jam',
          'studio.jamCardBody' => 'Play along with backing and scoring',
          'studio.songsCard' => 'Songs',
          'studio.songsCardBody' => 'Chords and lyrics to play',
          'studio.historyCard' => 'History',
          'studio.historyCardBody' => 'Your recent chords',
          'studio.streakDays' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('en'))(
                  n,
                  one: '${n} day in a row',
                  other: '${n} days in a row',
                ),
          'studio.streakZero' => 'Play today to start your streak',
          'studio.streakToday' => 'You already practiced today!',
          'studio.recentTitle' => 'Recent chords',
          'studio.seeAll' => 'See all',
          'studio.clearHistory' => 'Clear history',
          'studio.historyTitle' => 'Chord history',
          'studio.historyEmptyTitle' => 'No history yet',
          'studio.historyEmptyBody' =>
            'Chords you open will show up here for quick review.',
          'studio.historyHint' => 'Most recent first',
          'jam.title' => 'Guided jam',
          'jam.subtitle' => 'Pick what to play, set the key and tempo, and play along with the app.',
          'jam.progressionsTab' => 'Progressions',
          'jam.songsTab' => 'Songs',
          'jam.customTab' => 'Yours',
          'jam.key' => 'Key',
          'jam.tempo' => 'Tempo',
          'jam.bpm' => ({required Object n}) => '${n} BPM',
          'jam.loops' => ({required Object n}) => 'Loops: ${n}',
          'jam.modeBacking' => 'Backing',
          'jam.modeBackingBody' =>
            'The app plays the chords with the style\'s strumming.',
          'jam.modeScore' => 'Score',
          'jam.modeScoreBody' => 'You play and the microphone scores every bar (the app stays silent).',
          'jam.metronome' => 'Metronome',
          'jam.start' => 'Let\'s play!',
          'jam.countIn' => 'Get ready…',
          'jam.now' => 'Now',
          'jam.next' => 'Next',
          'jam.end' => 'End',
          'jam.barOf' => ({
            required Object n,
            required Object total,
          }) => 'Bar ${n} of ${total}',
          'jam.pause' => 'Pause',
          'jam.resume' => 'Resume',
          _ => null,
        } ??
        switch (path) {
          'jam.stop' => 'Finish',
          'jam.points' => ({required Object n}) => '${n} pts',
          'jam.streak' => ({required Object n}) => 'Streak ${n}',
          'jam.gradePerfect' => 'Perfect!',
          'jam.gradeGood' => 'Good!',
          'jam.gradeMiss' => 'Miss',
          'jam.gradeSilent' => 'Can\'t hear you',
          'jam.resultTitle' => 'Session complete',
          'jam.accuracy' => ({required Object n}) => 'Accuracy: ${n}%',
          'jam.bestStreak' => ({required Object n}) => 'Best streak: ${n}',
          'jam.perfectBars' => ({required Object n}) => 'Perfect bars: ${n}',
          'jam.playAgain' => 'Again',
          'jam.slower' => 'Slower',
          'jam.faster' => 'Faster',
          'jam.back' => 'Pick another',
          'jam.newBest' => 'New record!',
          'jam.best' => ({required Object n}) => 'Record: ${n}',
          'jam.scaleHint' => ({
            required Object scale,
          }) => 'Improvise with: ${scale}',
          'jam.customHint' =>
            'Tap chords to add them to your progression (up to 8).',
          'jam.customEmpty' => 'Add at least one chord',
          'jam.customTitle' => 'My progression',
          'jam.clear' => 'Clear',
          'jam.removeLast' => 'Remove last',
          'jam.micProblem' =>
            'No microphone access: this session won\'t be scored.',
          'jam.headphonesTip' => 'Tip: in \'Score\' the app stays quiet to hear you; follow the visual metronome.',
          'jam.chooseTrack' => 'Pick what to play',
          'jam.strum' => 'Strumming',
          'jam.pickTrack' => 'Tap to choose',
          'songs.title' => 'Songbook',
          'songs.subtitle' =>
            'Traditional and public-domain songs with chords and lyrics.',
          'songs.searchHint' => 'Search for a song',
          'songs.all' => 'All',
          'songs.traditional' => 'Traditional',
          'songs.exercise' => 'Chords exercise',
          'songs.transpose' => 'Key',
          'songs.transposeReset' => 'Original key',
          'songs.level' => ({required Object n}) => 'Level ${n}',
          'songs.chordsUsed' => 'Chords in this song',
          'songs.playJam' => 'Play in the jam',
          'songs.empty' => 'No songs match',
          'songs.emptyBody' => 'Try another name or clear the genre filter.',
          'songs.notFound' => 'We couldn\'t find that song',
          'songs.exercises.bluesInA' => 'Blues in A · 12 bars',
          'songs.exercises.rockInE' => 'Power chords in E',
          'songs.exercises.popFourChords' => 'The four pop chords',
          'songs.exercises.metalGallop' => 'Metal gallop in E minor',
          'songs.exercises.funkVamp' => 'Funky vamp in E',
          'songs.parts.intro' => 'Intro',
          'songs.parts.verse' => 'Verse',
          'songs.parts.chorus' => 'Chorus',
          'songs.parts.bridge' => 'Bridge',
          'songs.parts.outro' => 'Outro',
          _ => null,
        };
  }
}
