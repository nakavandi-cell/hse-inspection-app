import 'package:flutter/material.dart';
import '../core/db/app_database.dart';
import '../core/models/inspection_model.dart';
import '../core/models/answer_model.dart';

class ChecklistDetailPage extends StatefulWidget {
  final String checklistId;
  final String title;
  final String category;
  final String code;

  const ChecklistDetailPage({
    super.key,
    required this.checklistId,
    required this.title,
    required this.category,
    this.code = '',
  });

  @override
  State<ChecklistDetailPage> createState() => _ChecklistDetailPageState();
}

class _ChecklistDetailPageState extends State<ChecklistDetailPage> {
  final Map<String, String> _answers = {};
  final Map<String, String> _notes = {};
  bool _isSaving = false;

  Future<void> _saveInspection() async {
    setState(() => _isSaving = true);
    final db = await AppDatabase.instance.database;
    final String inspectionId = DateTime.now().millisecondsSinceEpoch.toString();
    final DateTime now = DateTime.now();

    final inspection = InspectionModel(
      id: inspectionId,
      checklistId: widget.checklistId,
      checklistTitle: widget.title,
      checklistCode: widget.code,
      checklistCategory: widget.category,
      status: InspectionStatus.completed,
      createdAt: now,
    );

    await db.insert(AppDatabase.instance.inspectionsTable, inspection.toDbMap());

    for (var entry in _answers.entries) {
      final answer = AnswerModel(
        id: '${inspectionId}_${entry.key}',
        inspectionId: inspectionId,
        questionId: entry.key,
        status: entry.value,
        note: _notes[entry.key] ?? '',
        answeredAt: now.toIso8601String(),
      );
      await db.insert(AppDatabase.instance.answersTable, answer.toDbMap());
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('بازرسی با موفقیت ذخیره شد')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Text('کد: ${widget.code} | دسته: ${widget.category}',
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 20),
                        const Text('ثبت وضعیت سوالات:'),
                        const SizedBox(height: 10),
                        // نمونه آیتم برای ثبت بازرسی
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('۱. وضعیت کلی و ایمنی تجهیز:'),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => setState(() => _answers['q1'] = 'انطباق'),
                                      child: const Text('انطباق'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => setState(() => _answers['q1'] = 'عدم انطباق'),
                                      child: const Text('عدم انطباق'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveInspection,
                      child: const Text('ذخیره نهایی بازرسی'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
