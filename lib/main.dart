import 'package:flutter/material.dart';
import 'core/models/checklist_model.dart';
import 'core/models/checklist_question_model.dart';
import 'core/models/inspection_model.dart';
import 'services/seed_loader.dart';

void main() {
  runApp(const HseInspectionApp());
}

class HseInspectionApp extends StatelessWidget {
  const HseInspectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سامانه جامع بازرسی HSE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      ),
      home: const ChecklistHomePage(),
    );
  }
}

class ChecklistHomePage extends StatefulWidget {
  const ChecklistHomePage({super.key});

  @override
  State<ChecklistHomePage> createState() => _ChecklistHomePageState();
}

class _ChecklistHomePageState extends State<ChecklistHomePage> {
  late List<Checklist> _checklists;
  final List<InspectionModel> _savedInspections = [];

  @override
  void initState() {
    super.initState();
    _checklists = SeedLoader.getInitialChecklists();
  }

  void _addInspection(InspectionModel inspection) {
    setState(() {
      _savedInspections.insert(0, inspection);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Checklist>> grouped = {};
    for (var cl in _checklists) {
      grouped.putIfAbsent(cl.category, () => []).add(cl);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'چک‌لیست‌های بازرسی HSE',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user, color: Colors.teal, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'مجموعاً ${_checklists.length} چک‌لیست فعال و ۱۹۲ شاخص بازرسی آماده بهره‌برداری',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...grouped.entries.map((entry) {
              return Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.folder, color: Colors.teal),
                  title: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text('${entry.value.length} فرم بازرسی مجزا'),
                  children: entry.value.map((checklist) {
                    return ListTile(
                      leading: const Icon(Icons.fact_check_outlined, color: Colors.blueGrey),
                      title: Text(
                        checklist.title,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      subtitle: Text('${checklist.code} • ${checklist.questions.length} سؤال'),
                      trailing: const Icon(Icons.arrow_back_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InspectionExecutionPage(
                              checklist: checklist,
                              onSaved: _addInspection,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            }),
            if (_savedInspections.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(top: 20, right: 16, bottom: 8),
                child: Text(
                  'آخرین بازرسی‌های ثبت‌شده در این نشست:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              ..._savedInspections.map((insp) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(insp.title),
                    subtitle: Text('${insp.checklistCode} | تاریخ: ${insp.date}'),
                    trailing: Chip(
                      label: Text(
                        insp.status == 'completed' ? 'تکمیل‌شده' : 'پیش‌نویس',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class InspectionExecutionPage extends StatefulWidget {
  final Checklist checklist;
  final Function(InspectionModel) onSaved;

  const InspectionExecutionPage({
    super.key,
    required this.checklist,
    required this.onSaved,
  });

  @override
  State<InspectionExecutionPage> createState() => _InspectionExecutionPageState();
}

class _InspectionExecutionPageState extends State<InspectionExecutionPage> {
  final _titleController = TextEditingController();
  final Map<String, String> _answers = {};
  final Map<String, String> _notes = {};

  @override
  void initState() {
    super.initState();
    _titleController.text = 'بازرسی ${widget.checklist.title}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveInspection() {
    final newInspection = InspectionModel(
      title: _titleController.text.trim().isEmpty
          ? widget.checklist.title
          : _titleController.text.trim(),
      date: DateTime.now().toString().split(' ')[0],
      status: 'completed',
      checklistId: widget.checklist.id,
      checklistTitle: widget.checklist.title,
      checklistCode: widget.checklist.code,
    );

    widget.onSaved(newInspection);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('بازرسی با موفقیت ثبت گردید.'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.checklist.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'ذخیره بازرسی',
              onPressed: _saveInspection,
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'عنوان بازرسی / محل یا کد تجهیز',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.edit_note),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'کد فرم: ${widget.checklist.code}  |  دسته‌بندی: ${widget.checklist.category}',
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...widget.checklist.questions.map((q) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${q.order}. ${q.text}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildAnswerOptions(q),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(
                'تکمیل و ثبت بازرسی',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: _saveInspection,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(ChecklistQuestion q) {
    final current = _answers[q.id];

    if (q.answerType == 'yes_no_partial_na') {
      return Wrap(
        spacing: 8,
        children: [
          _optionChip(q.id, 'بله', Colors.green, current),
          _optionChip(q.id, 'تا حدودی', Colors.orange, current),
          _optionChip(q.id, 'خیر', Colors.red, current),
          _optionChip(q.id, 'نامشمول', Colors.grey, current),
        ],
      );
    } else if (q.answerType == 'yes_no_partial') {
      return Wrap(
        spacing: 8,
        children: [
          _optionChip(q.id, 'بله', Colors.green, current),
          _optionChip(q.id, 'تا حدودی', Colors.orange, current),
          _optionChip(q.id, 'خیر', Colors.red, current),
        ],
      );
    } else {
      return Wrap(
        spacing: 8,
        children: [
          _optionChip(q.id, 'بله', Colors.green, current),
          _optionChip(q.id, 'خیر', Colors.red, current),
        ],
      );
    }
  }

  Widget _optionChip(String qId, String label, Color color, String? current) {
    final isSelected = current == label;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: Colors.grey.shade100,
      onSelected: (val) {
        setState(() {
          if (val) {
            _answers[qId] = label;
          } else {
            children: [
          _optionChip(q.id, 'بله', Colors.green, current),
          _optionChip(q.id, 'خیر', Colors.red, current),
        ],
      );
    }
  }

  Widget _optionChip(String qId, String label, Color color, String? current) {
    final isSelected = current == label;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: Colors.grey.shade100,
      onSelected: (val) {
        setState(() {
          if (val) {
            _answers[qId] = label;
          } else {
            _answers.remove(qId);
          }
        });
      },
    );
  }
}
