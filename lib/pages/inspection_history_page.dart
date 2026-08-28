import 'package:flutter/material.dart';
import '../core/db/app_database.dart';
import '../core/models/inspection_model.dart';
import '../services/excel_export_service.dart';

class InspectionHistoryPage extends StatefulWidget {
  const InspectionHistoryPage({super.key});

  @override
  State<InspectionHistoryPage> createState() => _InspectionHistoryPageState();
}

class _InspectionHistoryPageState extends State<InspectionHistoryPage> {
  List<InspectionModel> _inspections = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInspections();
  }

  Future<void> _loadInspections() async {
    setState(() => _isLoading = true);
    try {
      final data = await AppDatabase.instance.getAllInspections();
      if (!mounted) return;
      setState(() {
        _inspections = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در بارگذاری اطلاعات: $e')),
      );
    }
  }

  Future<void> _deleteInspection(String id) async {
    await AppDatabase.instance.deleteInspection(id);
    if (!mounted) return;
    await _loadInspections();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('بازرسی با موفقیت حذف شد')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = _inspections.where((item) {
      final title = (item.checklistTitle ?? item.title ?? '').toLowerCase();
      final category = item.checklistCategory.toLowerCase();
      final id = item.id.toLowerCase();
      return title.contains(query) || category.contains(query) || id.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('تاریخچه بازرسی‌ها'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'جستجو بر اساس عنوان، دسته یا شناسه...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(child: Text('موردی یافت نشد'))
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final dateStr = item.createdAt.toIso8601String().split('T').first;
                          final displayTitle = (item.checklistTitle != null && item.checklistTitle!.isNotEmpty)
                              ? item.checklistTitle!
                              : (item.title != null && item.title!.isNotEmpty ? item.title! : 'بدون عنوان');

                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.assignment_turned_in),
                            ),
                            title: Text(
                              displayTitle,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('دسته: ${item.checklistCategory} | تاریخ: $dateStr\nتعداد پاسخ‌ها: ${item.answers.length} | وضعیت: ${item.status.name}'),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.file_download, color: Colors.green),
                                  tooltip: 'خروجی اکسل',
                                  onPressed: () => ExcelExportService.exportInspection(item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'حذف',
                                  onPressed: () => _deleteInspection(item.id),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
