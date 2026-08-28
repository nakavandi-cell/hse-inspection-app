import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/inspection_model.dart';
import '../../../../core/models/inspection_status.dart' as inspection_status;
import '../../../../core/providers/providers.dart';
import '../../../../core/services/excel_export_service.dart';
import '../../../../utils/file_saver_helper.dart';

class InspectionsListPage extends ConsumerWidget {
  const InspectionsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(inspectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('بازرسی‌ها'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'خروجی Excel',
            onPressed: () => _exportSummary(context, ref),
          ),
        ],
      ),
      body: asyncValue.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => _ListError(
          message: '$e',
          onRetry: () => ref.invalidate(inspectionsProvider),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const _EmptyList();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(inspectionsProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _InspectionCard(
                  inspection: list[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _exportSummary(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final list = await ref.read(inspectionsProvider.future);

      if (list.isEmpty) {
        _showSnack(
          context,
          'بازرسی‌ای برای خروجی وجود ندارد.',
        );
        return;
      }

      final bytes = const ExcelExportService().buildSummaryReport(list);

      if (bytes == null) {
        _showSnack(
          context,
          'خطا در ساخت فایل Excel.',
        );
        return;
      }

      await saveExcelBytes(
        fileName:
            'inspection_summary_${DateTime.now().millisecondsSinceEpoch}',
        bytes: bytes,
      );

      if (context.mounted) {
        _showSnack(
          context,
          'فایل Excel دانلود شد.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        _showSnack(
          context,
          'خطا در خروجی Excel.',
        );
      }
    }
  }

  void _showSnack(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

class _InspectionCard extends StatelessWidget {
  final InspectionModel inspection;

  const _InspectionCard({
    required this.inspection,
  });

  @override
  Widget build(BuildContext context) {
    final status = inspection_status.InspectionStatus.fromDb(
      inspection.status,
    );

    final date = inspection.completedAt ?? inspection.startedAt;

    final dateText = date != null
        ? DateFormat('yyyy/MM/dd - HH:mm').format(date)
        : '—';

    return Card(
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Icon(
          status == inspection_status.InspectionStatus.completed
              ? Icons.check_circle
              : Icons.edit_note,
          color: _statusColor(status),
          size: 32,
        ),
        title: Text(
          inspection.title,
        ),
        subtitle: Text(
          'کد: ${inspection.id}  •  $dateText',
        ),
        trailing: _StatusChip(
          status: status,
        ),
        onTap: () {
          context.push(
            '/inspection/${Uri.encodeComponent(inspection.sectionKey)}'
            '?title=${Uri.encodeComponent(inspection.title)}'
            '&inspectionId=${Uri.encodeComponent(inspection.id)}',
          );
        },
      ),
    );
  }

  Color _statusColor(
    inspection_status.InspectionStatus status,
  ) {
    switch (status) {
      case inspection_status.InspectionStatus.draft:
        return Colors.orange;
      case inspection_status.InspectionStatus.inProgress:
        return Colors.blue;
      case inspection_status.InspectionStatus.completed:
        return Colors.green;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final inspection_status.InspectionStatus status;

  const _StatusChip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color color;

    switch (status) {
      case inspection_status.InspectionStatus.draft:
        label = 'پیش‌نویس';
        color = Colors.orange;
        break;

      case inspection_status.InspectionStatus.inProgress:
        label = 'در حال انجام';
        color = Colors.blue;
        break;

      case inspection_status.InspectionStatus.completed:
        label = 'تکمیل‌شده';
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox,
            size: 56,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'هنوز بازرسی‌ای ثبت نشده است.',
          ),
        ],
      ),
    );
  }
}

class _ListError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ListError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            Text: Colors.red,
            ),
            const SizedBox(height: 12),
            TextBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(
                'تلاش دوباره',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
