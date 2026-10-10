import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_sink.dart';
import 'package:chords/core/logging/sinks/memory_log_sink.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/logs/logs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests del visor de diagnóstico en la app.
void main() {
  tearDown(resetAppLogger);

  testWidgets('muestra eventos y reacciona a los nuevos', (
    WidgetTester tester,
  ) async {
    final MemoryLogSink sink = MemoryLogSink();
    configureAppLogger(AppLogger(sinks: <LogSink>[sink]));
    registerAppMemorySink(sink);
    appLogger.warning('primer aviso', channel: LogChannel.audio);

    await tester.pumpWidget(const _LogsHost());
    await tester.pumpAndSettle();

    expect(find.byType(LogsPage), findsOneWidget);
    expect(find.textContaining('primer aviso'), findsOneWidget);

    appLogger.error('nuevo error', channel: LogChannel.chords);
    await tester.pumpAndSettle();

    expect(find.textContaining('nuevo error'), findsOneWidget);
  });

  testWidgets('el filtro por severidad oculta el resto', (
    WidgetTester tester,
  ) async {
    final MemoryLogSink sink = MemoryLogSink();
    configureAppLogger(AppLogger(sinks: <LogSink>[sink]));
    registerAppMemorySink(sink);
    appLogger
      ..warning('aviso visible sin filtro')
      ..error('error siempre visible');

    await tester.pumpWidget(const _LogsHost());
    await tester.pumpAndSettle();
    expect(find.textContaining('aviso visible sin filtro'), findsOneWidget);

    await tester.tap(find.text('ERROR'));
    await tester.pumpAndSettle();

    expect(find.textContaining('error siempre visible'), findsOneWidget);
    expect(find.textContaining('aviso visible sin filtro'), findsNothing);
  });
}

/// Monta el visor con el proveedor de traducciones.
class _LogsHost extends StatelessWidget {
  const _LogsHost();

  @override
  Widget build(BuildContext context) =>
      TranslationProvider(child: const MaterialApp(home: LogsPage()));
}
