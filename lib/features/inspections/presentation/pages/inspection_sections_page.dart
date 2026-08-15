import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/inspection_model.dart';
import '../../../../core/models/inspection_status.dart';
import '../../../../core/providers/providers.dart';

class InspectionsListPage extends ConsumerWidget {
  const InspectionsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(inspectionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('بازرسی‌ها')),
      body: asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ListError(
          message: '$e',
          onRetry: () => ref.invalidate(inspectionsProvider),
        ),
        data: (list) {
          if (list.isEmpty) return const _EmptyList();
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(inspectionsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _InspectionCard(inspection: list[index]),
            ),
          );
        },
      ),
    );
  }
}

class _InspectionCard extends StatelessWidget {
  final InspectionModel inspection;

  const _InspectionCard({required this.inspection});

  @override
  Widget build(BuildContext context) {
    final status = InspectionStatus.fromDb(inspection.status);
    final date = inspection.completedAt ?? inspection.startedAt;
    final dateText =
        date != null ? DateFormat('yyyy/MM/dd - HH:mm').format(date) : '—';

    return Card(
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          status == InspectionStatus.completed
              ? Icons.check_circle
              : Icons.edit_note,
          color: _statusColor(status),
          size: 32,
        ),
        title: Text(inspection.title),
        subtitle: Text('کد: ${inspection.id}  •  $dateText'),
        trailing: _StatusChip(status: status),
        onTap: () {
          context.push(
            '/inspection/${Uri.encodeComponent(inspection.sectionKey)}'
            '?title=${Uri.encodeComponent(inspection.title)}'
            '&inspectionId=${inspection.id}',
          );
        },
      ),
    );
  }

  Color _statusColor(InspectionStatus status) {
    switch (status) {
      case InspectionStatus.draft:
        return Colors.orange;
      case InspectionStatus.inProgress:
        return Colors.blue;
      case InspectionStatus.completed:
        return Colors.green;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final InspectionStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      InspectionStatus.draft => ('پیش‌نویس', Colors.orange),
      InspectionStatus.inProgress => ('در حال انجام', Colors.blue),
      InspectionStatus.completed => ('تکمیل‌شده', Colors.green),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          Icon(Icons.inbox, size: 56, color: Colors.grey),
          SizedBox(height: 12),
          Text('هنوز بازرسی‌ای ثبت نشده است.'),
        ],
      ),
    );
  }
}

class _ListError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ListError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('تلاش دوباره'),
            ),
          ],
        ),
      ),
    );
  }
}
