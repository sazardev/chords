import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/settings_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/formatters/console_log_formatter.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/sinks/memory_log_sink.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/logs/logs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Visor de diagnóstico que muestra el registro de la app en caliente.
///
/// Solo se ofrece en flavors con diagnóstico activo (dev/staging). Refleja los
/// eventos del sink en memoria, permite filtrar por severidad y vaciarlos.
class LogsPage extends StatefulWidget {
  /// Crea la pantalla de diagnóstico.
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  @override
  void initState() {
    super.initState();
    analytics.diagnosticsOpened();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<LogsViewModel>(
    create: (_) => LogsViewModel(appMemoryLogSink ?? MemoryLogSink()),
    child: const _LogsView(),
  );
}

class _LogsView extends StatelessWidget {
  const _LogsView();

  @override
  Widget build(BuildContext context) {
    final LogsViewModel model = context.watch<LogsViewModel>();
    final Translations t = context.t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.logs.title),
        actions: <Widget>[
          IconButton(
            tooltip: t.logs.clear,
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: model.clear,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _summaryRow(context, model),
          _filterRow(context, model),
          const Divider(height: 8),
          Expanded(child: _LogList(entries: model.entries)),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, LogsViewModel model) {
    final ThemeData theme = Theme.of(context);
    final Translations t = context.t;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: <Widget>[
          _SummaryChip(
            label: t.logs.total,
            value: model.total,
            icon: Icons.list_alt_rounded,
          ),
          const SizedBox(width: 8),
          _SummaryChip(
            label: t.logs.errors,
            value: model.errorCount,
            icon: Icons.error_outline_rounded,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 8),
          _SummaryChip(
            label: t.logs.warnings,
            value: model.warningCount,
            icon: Icons.warning_amber_rounded,
            color: theme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _filterRow(BuildContext context, LogsViewModel model) {
    final Translations t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          FilterChip(
            label: Text(t.logs.allLevels),
            selected: model.levelFilter == null,
            onSelected: (_) => model.setLevelFilter(null),
          ),
          for (final AppLogLevel level in AppLogLevel.values) ...<Widget>[
            const SizedBox(width: 8),
            FilterChip(
              label: Text(level.label),
              selected: model.levelFilter == level,
              onSelected: (_) => model.setLevelFilter(level),
            ),
          ],
        ],
      ),
    );
  }
}

class _LogList extends StatelessWidget {
  const _LogList({required this.entries});

  final List<LogEntry> entries;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final TextStyle? style = Theme.of(context).textTheme.bodySmall
        ?.copyWith(fontFamily: 'monospace');
    if (entries.isEmpty) {
      return Center(child: Text(t.logs.empty));
    }
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Text(consoleLogFormatter(entries[index]), style: style),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color tint = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 16, color: tint),
          const SizedBox(width: 6),
          Text('$label: $value'),
        ],
      ),
    );
  }
}
