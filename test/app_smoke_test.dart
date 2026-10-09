import 'package:chords/app/app.dart';
import 'package:chords/config/app_config.dart';
import 'package:chords/data/audio/audio_repository_impl.dart';
import 'package:chords/data/chords/datasources/chord_asset_datasource.dart';
import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/get_chord_by_id_use_case.dart';
import 'package:chords/domain/chords/usecases/get_chords_use_case.dart';
import 'package:chords/domain/chords/usecases/match_chords_by_pitch_classes_use_case.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/router/app_router.dart';
import 'package:chords/presentation/router/route_paths.dart';
import 'package:chords/presentation/widgets/molecules/chord_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Smoke test de la aplicación completa (arranque, assets y navegación).
void main() {
  testWidgets('la app arranca, carga el banco y navega', (
    WidgetTester tester,
  ) async {
    final ChordRepository chords = ChordRepositoryImpl(
      dataSource: const ChordAssetDataSource(),
    );
    final AudioRepository audio = AudioRepositoryImpl();
    final ChordsController chordsController = ChordsController(
      GetChordsUseCase(chords),
      const SearchChordsUseCase(),
    );

    await tester.runAsync(() async {
      await chords.load();
      await chordsController.load();
    });

    final List<SingleChildWidget> providers = <SingleChildWidget>[
      ChangeNotifierProvider<SettingsController>(
        create: (_) => SettingsController(),
      ),
      ChangeNotifierProvider<ChordsController>.value(value: chordsController),
      ChangeNotifierProvider<ChordDetailController>(
        create: (_) =>
            ChordDetailController(GetChordByIdUseCase(chords), audio),
      ),
      ChangeNotifierProvider<LiveController>(
        create: (_) => LiveController(
          audio,
          chords,
          const MatchChordsByPitchClassesUseCase(),
        ),
      ),
    ];

    await tester.pumpWidget(
      MultiProvider(
        providers: providers,
        child: ChordsApp(
          config: const AppConfig.dev(),
          router: AppRouter(config: const AppConfig.dev()).router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chords'), findsOneWidget);
    expect(find.text('Todos los acordes de guitararra'), findsOneWidget);

    // Navegación al listado de acordes.
    await tester.tap(find.text('Acordes').last);
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);

    // Entrar al detalle de un acorde.
    final Chord chord = tester
        .widget<ChordCard>(find.byType(ChordCard).first)
        .chord;
    await tester.tap(find.byType(ChordCard).first);
    await tester.pumpAndSettle();
    expect(find.text('Posiciones'), findsOneWidget);
    expect(find.text(chord.name), findsWidgets);

    // Página en vivo sin micrófono activo.
    routerOf(tester).go(kLivePath);
    await tester.pumpAndSettle();
    expect(find.text('Afinación en vivo'), findsOneWidget);
    expect(find.text('Micrófono en espera'), findsOneWidget);

    // Deep link con parámetros de consulta: /chords?root=E&quality=min.
    routerOf(tester).go('$kChordsPath?root=E&quality=min');
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    expect(chordsController.visibleChords.isNotEmpty, isTrue);
    expect(
      chordsController.visibleChords.every(
        (Chord c) => c.root == ChordRoot.e && c.quality == ChordQuality.minor,
      ),
      isTrue,
    );
  });
}

/// Recupera el enrutador montado en la aplicación.
GoRouter routerOf(WidgetTester tester) {
  final MaterialApp app = tester.widget<MaterialApp>(find.byType(MaterialApp));
  return app.routerConfig! as GoRouter;
}
