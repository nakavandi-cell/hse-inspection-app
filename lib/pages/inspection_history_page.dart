import 'package:flutter/material.dart';

import '../core/db/app_database.dart';
import '../core/models/answer_model.dart';
import '../core/models/inspection_model.dart';
import '../services/excel_export_service.dart';

class InspectionHistoryPage extends StatefulWidget {
  const InspectionHistoryPage({super.key});

  @override
  State<InspectionHistoryPage> createState() => _InspectionHistoryPageState();
}

class _InspectionHistoryPageState extends State<InspectionHistoryPage> {
  final TextEditingController _searchController = TextEditingController();

  bool _loading = true;
  List<InspectionModel> _allInspections = <InspectionModel>[];
  List<InspectionModel> _filteredInspections = <InspectionModel>[];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadInspections();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInspections() async {
    setState(() => _loading = true);

    try {
      final db = await AppDatabase.instance.database;
      final inspectionsRows = await db.query(
        AppDatabase.inspectionsTable,
        orderBy: 'createdAt DESC',
      );
      final answersRows = await db.query(
        AppDatabase.answersTable,
        orderBy: 'id ASC',
      );

      final Map<String, List<AnswerModel>> answersByInspectionId = <String, List<AnswerModel>>{};
      for (final row in answersRows) {
        final answer = AnswerModel.fromDbMap(row);
        final inspectionId = row['inspectionId']?.toString() ?? '';
        if (inspectionId.isEmpty) continue;
        answersByInspectionId.putIfAbsent(inspectionId, () => <AnswerModel>[]).add(answer);
      }

      final inspections = inspectionsRows.map((row) {
        final inspectionId = row['id']?.toString() ?? '';
        final answers = answersByInspectionId[inspectionId] ?? <AnswerModel>[];
        return InspectionModel.fromDbMap(row, answers: answers);
      }).toList();

      setState(() {
        _allInspections = inspections;
        _applyFilter();
      });
    } catch (_) {
      setState(() {
        _allInspections = <InspectionModel>[];
        _filteredInspections = <InspectionModel>[];
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  void _applyFilter() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) {
      _filteredInspections = List<InspectionModel>.from(_allInspections);
      return;
    }

    _filteredInspections = _allInspections.where((inspection) {
      final idMatch = inspection.id.toLowerCase().contains(q);
      final titleMatch = inspection.checklistTitle.toLowerCase().contains(q);
      final categoryMatch = inspection.checklistCategory.toLowerCase().contains(q);
      final statusMatch = inspection.status.toLowerCase().contains(q);
      final dateMatch = inspection.createdAt.toString().toLowerCase().contains(q);
      return idMatch || titleMatch || categoryMatch || statusMatch || dateMatch;
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
      _applyFilter();
    });
  }

  Future<void> _deleteInspection(InspectionModel inspection) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف بازرسی'),
          content: const Text('آیا از حذف این بازرسی مطمئن هستید؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final db = await AppDatabase.instance.database;
    await db.delete(
      AppDatabase.answersTable,
      where: 'inspectionId = ?',
      whereArgs: [inspection.id],
    );
    await db.delete(
      AppDatabase.inspectionsTable,
      where: 'id = ?',
      whereArgs: [inspection.id],
    );

    if (!mounted) return;
    await _loadInspections();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('بازرسی حذف شد.')),
    );
  }

  void _openDetails(InspectionModel inspection) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'جزئیات بازرسی',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'شناسه', value: inspection.id),
                    _InfoRow(label: 'چک‌لیست', value: inspection.checklistTitle),
                    _InfoRow(label: 'دسته‌بندی', value: inspection.checklistCategory),
                    _InfoRow(label: 'تاریخ', value: _formatDateTime(inspection.createdAt)),
                    _InfoRow(label: 'وضعیت', value: inspection.status),
                    const SizedBox(height: 16),
                    Text(
                      'پاسخ‌ها',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        itemCount: inspection.answers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final answer = inspection.answers[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('سؤال ${index + 1}'),
                                const SizedBox(height: 6),
                                Text('شناسه سوال: ${answer.questionId}'),
                                Text('وضعیت: ${_translateStatus(answer.status)}'),
                                if (answer.note.trim().isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text('توضیحات: ${answer.note}'),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _exportInspection(InspectionModel inspection) async {
    await ExcelExportService.exportInspection(inspection);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('فایل اکسل آماده و دانلود شد.')),
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'yes':
        return 'بلی';
      case 'no':
        return 'خیر';
      case 'not_applicable':
        return 'نامشمول';
      case 'needs_action':
        return 'نیاز به اقدام';
      default:
        return 'نامشخص';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    final hh = dateTime.hour.toString().padLeft(2, '0');
    final mm = dateTime.minute.toString().padLeft(2, '0');
    return '$y/$m/$d  $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تاریخچه بازرسی‌ها'),
          actions: [
            IconButton(
              onPressed: _loadInspections,
              icon: const Icon(Icons.refresh),
              tooltip: 'بازخوانی',
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'جست‌وجو بر اساس عنوان، دسته‌بندی، شناسه یا وضعیت',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                          icon: const Icon(Icons.clear),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryTile(
                      title: 'کل بازرسی‌ها',
                      value: _allInspections.length.toString(),
                      icon: Icons.fact_check_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryTile(
                      title: 'نتایج فیلترشده',
                      value: _filteredInspections.length.toString(),
                      icon: Icons.filter_alt_outlined,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredInspections.isEmpty
                      ? const Center(
                          child: Text('هیچ بازرسی‌ای ثبت نشده یا موردی پیدا نشد.'),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadInspections,
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            itemCount: _filteredInspections.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final inspection = _filteredInspections[index];
                              final answeredCount = inspection.answers
                                  .where((a) => a.status.trim().isNotEmpty)
                                  .length;
                              final progress = inspection.answers.isEmpty
                                  ? 0.0
                                  : answeredCount / inspection.answers.length;

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  inspection.checklistTitle,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(fontWeight: FontWeight.w700),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  inspection.checklistCategory,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'detail') {
                                                _openDetails(inspection);
                                              } else if (value == 'export') {
                                                _exportInspection(inspection);
                                              } else if (value == 'delete') {
                                                _deleteInspection(inspection);
                                              }
                                            },
                                            itemBuilder: (context) => const [
                                              PopupMenuItem(
                                                value: 'detail',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.visibility_outlined, size: 20),
                                                    SizedBox(width: 8),
                                                    Text('جزئیات'),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'export',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.download_outlined, size: 20),
                                                    SizedBox(width: 8),
                                                    Text('خروجی اکسل'),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                                    SizedBox(width: 8),
                                                    Text('حذف'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'شناسه: ${inspection.id}',
                                              style: TextStyle(color: Colors.grey.shade800),
                                            ),
                                          ),
                                          Text(
                                            _formatDateTime(inspection.createdAt),
                                            style: TextStyle(color: Colors.grey.shade700),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(999),
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          minHeight: 8,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'تکمیل پاسخ‌ها: $answeredCount از ${inspection.answers.length}',
                                        style: TextStyle(color: Colors.grey.shade700),
                                      ),
                                      if (inspection.answers.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _SmallChip(
                                              label: 'بلی: ${inspection.answers.where((a) => a.status == 'yes').length}',
                                            ),
                                            _SmallChip(
                                              label: 'خیر: ${inspection.answers.where((a) => a.status == 'no').length}',
                                            ),
                                            _SmallChip(
                                              label: 'نامشمول: ${inspection.answers.where((a) => a.status == 'not_applicable').length}',
                                            ),
                                            _SmallChip(
                                              label: 'نیاز به اقدام: ${inspection.answers.where((a) => a.status == 'needs_action').length}',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  const _SmallChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Text(label),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
