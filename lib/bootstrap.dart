import 'dart:async' show unawaited;

import 'package:chords/app/app.dart';
import 'package:chords/config/app_config.dart';
import 'package:chords/di/app_dependencies.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Punto de entrada de arranque de la aplicación.
///
/// Compone las dependencias, registra los controladores y monta la app.
void bootstrap(AppConfig config) {
  WidgetsFlutterBinding.ensureInitialized();
  final AppDependencies dependencies = AppDependencies.create();
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<SettingsController>(
          create: (_) => SettingsController(),
        ),
        ChangeNotifierProvider<ChordsController>(
          create: (_) {
            final ChordsController controller = ChordsController(
              dependencies.getChordsUseCase,
              dependencies.searchChordsUseCase,
            );
            unawaited(controller.load());
            return controller;
          },
        ),
        ChangeNotifierProvider<ChordDetailController>(
          create: (_) => ChordDetailController(
            dependencies.getChordByIdUseCase,
            dependencies.audioRepository,
          ),
        ),
        ChangeNotifierProvider<LiveController>(
          create: (_) => LiveController(
            dependencies.audioRepository,
            dependencies.chordRepository,
            dependencies.matchChordsUseCase,
          ),
        ),
      ],
      child: ChordsApp(
        config: config,
        router: AppRouter(config: config).router,
      ),
    ),
  );
}
