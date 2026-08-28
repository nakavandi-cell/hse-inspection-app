import 'package:flutter/material.dart';
import '../core/models/inspection_model.dart';
import '../core/db/app_database.dart';
import '../features/inspections/presentation/pages/dynamic_inspection_page.dart';

class ChecklistDetailPage extends StatefulWidget {
  final dynamic checklist;
  final String? checklistId;
  final String? category;

  const ChecklistDetailPage({
    super.key,
    this.checklist,
    this.checklistId,
    this.category,
  });

  @override
  State<ChecklistDetailPage> createState() => _ChecklistDetailPageState();
}

class _ChecklistDetailPageState extends State<ChecklistDetailPage> {
  bool _isLoading = false;

  String get _title {
    try {
      if (widget.checklist != null && widget.checklist.title != null) {
        return widget.checklist.title.toString();
      }
    } catch (_) {}
    return 'جزئیات چک‌لیست';
  }

  String get _code {
    try {
      if (widget.checklist != null && widget.checklist.code != null) {
        return widget.checklist.code.toString();
      }
    } catch (_) {}
    return '';
  }

  String get _id {
    if (widget.checklistId != null && widget.checklistId!.isNotEmpty) {
      return widget.checklistId!;
    }
    try {
      if (widget.checklist != null && widget.checklist.id != null) {
        return widget.checklist.id.toString();
      }
    } catch (_) {}
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  List<dynamic> get _sections {
    try {
      if (widget.checklist != null && widget.checklist.sections != null) {
        return widget.checklist.sections as List<dynamic>;
      }
    } catch (_) {}
    return [];
  }

  Future<void> _startInspection() async {
    setState(() => _isLoading = true);
    try {
      final now = DateTime.now();
      final dateStr = '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';

      final newInspection = InspectionModel(
        title: 'بازرسی $_title',
        date: dateStr,
        status: 'in_progress',
        checklistId: _id,
        checklistTitle: _title,
        checklistCode: _code,
      );

      final id = await AppDatabase.instance.insertInspection(newInspection);
      final savedInspection = newInspection.copyWith(id: id);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DynamicInspectionPage(
            checklist: widget.checklist,
            checklistId: _id,
            checklistTitle: _title,
            checklistCode: _code,
            inspection: savedInspection,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در شروع بازرسی: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = _sections;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_code.isNotEmpty)
                        Text(
                          'کد مدرک: $_code',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'تعداد بخش‌ها: ${sections.length}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _startInspection,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.play_arrow),
                label: Text(
                  _isLoading ? 'در حال ایجاد...' : 'شروع بازرسی جدید',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (sections.isNotEmpty) ...[
                const Text(
                  'بخش‌های این چک‌لیست:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      String sectionTitle = 'بخش ${index + 1}';
                      int questionsCount = 0;

                      try {
                        if (section.title != null) {
                          sectionTitle = section.title.toString();
                        }
                        if (section.questions != null) {
                          questionsCount = (section.questions as List).length;
                        }
                      } catch (_) {}

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            child: Text('${index + 1}'),
                          ),
                          title: Text(sectionTitle),
                          subtitle: Text('$questionsCount سوال / آیتم کنترلی'),
                        ),
                      );
                    },
                  ),
                ),
              ] else
                const Expanded(
                  child: Center(
                    child: Text(
                      'آماده بازرسی مستقیم',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
