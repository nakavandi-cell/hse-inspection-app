import 'package:flutter/material.dart';
import '../core/models/answer_model.dart';
import '../core/models/checklist_model.dart';
import '../core/models/inspection_model.dart';
import '../core/db/app_database.dart';
import '../services/excel_export_service.dart';

enum InspectionAnswerStatus { yes, no, notApplicable, needsAction }

extension StatusExt on InspectionAnswerStatus {
  String get label {
    switch (this) {
      case InspectionAnswerStatus.yes: return 'بلی';
      case InspectionAnswerStatus.no: return 'خیر';
      case InspectionAnswerStatus.notApplicable: return 'نامشمول';
      case InspectionAnswerStatus.needsAction: return 'نیاز به اقدام';
    }
  }
  String get dbValue {
    switch (this) {
      case InspectionAnswerStatus.yes: return 'yes';
      case InspectionAnswerStatus.no: return 'no';
      case InspectionAnswerStatus.notApplicable: return 'not_applicable';
      case InspectionAnswerStatus.needsAction: return 'needs_action';
    }
  }
}

class ChecklistDetailPage extends StatefulWidget {
  const ChecklistDetailPage({super.key, required this.checklist});
  final Checklist checklist;
  @override
  State<ChecklistDetailPage> createState() => _ChecklistDetailPageState();
}

class _ChecklistDetailPageState extends State<ChecklistDetailPage> {
  final Map<String, InspectionAnswerStatus?> _statuses = {};
  final Map<String, TextEditingController> _notes = {};
  bool _saving = false;
  InspectionModel? _lastSavedInspection;

  @override
  void initState() {
    super.initState();
    for (var q in widget.checklist.questions) {
      _statuses[q.id] = null;
      _notes[q.id] = TextEditingController();
    }
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      final String id = DateTime.now().millisecondsSinceEpoch.toString();
      final answers = widget.checklist.questions.map((q) => AnswerModel(
        questionId: q.id,
        status: _statuses[q.id]?.dbValue ?? '',
        note: _notes[q.id]!.text.trim(),
      )).toList();

      final inspection = InspectionModel(
        id: id,
        checklistId: widget.checklist.id,
        checklistTitle: widget.checklist.title,
        checklistCategory: widget.checklist.category,
        createdAt: DateTime.now(),
        status: 'submitted',
        answers: answers,
      );

      final db = await AppDatabase.instance.database;
      await db.insert(AppDatabase.inspectionsTable, inspection.toDbMap());
      for (var a in answers) {
        await db.insert(AppDatabase.answersTable, a.toDbMap(inspectionId: id));
      }

      setState(() => _lastSavedInspection = inspection);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ذخیره شد.')));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.checklist.title)),
      body: Column(
        children: [
          if (_lastSavedInspection != null)
            Container(
              color: Colors.green.shade50,
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('بازرسی با موفقیت ثبت شد.', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  FilledButton.icon(
                    onPressed: () => ExcelExportService.exportInspection(_lastSavedInspection!),
                    icon: const Icon(Icons.download),
                    label: const Text('خروجی اکسل'),
                    style: FilledButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.checklist.questions.length,
              itemBuilder: (ctx, i) {
                final q = widget.checklist.questions[i];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${i + 1}. ${q.text}'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: InspectionAnswerStatus.values.map((s) => ChoiceChip(
                            label: Text(s.label),
                            selected: _statuses[q.id] == s,
                            onSelected: (val) => setState(() => _statuses[q.id] = val ? s : null),
                          )).toList(),
                        ),
                        TextField(controller: _notes[q.id], decoration: const InputDecoration(hintText: 'توضیحات...')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _submit,
                child: Text(_saving ? 'در حال ذخیره...' : 'ثبت نهایی بازرسی'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
