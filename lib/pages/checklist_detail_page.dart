import 'package:flutter/material.dart';

import '../core/models/checklist_model.dart';

enum InspectionAnswerStatus {
  yes,
  no,
  notApplicable,
  needsAction,
}

extension InspectionAnswerStatusExtension on InspectionAnswerStatus {
  String get label {
    switch (this) {
      case InspectionAnswerStatus.yes:
        return 'بلی';
      case InspectionAnswerStatus.no:
        return 'خیر';
      case InspectionAnswerStatus.notApplicable:
        return 'نامشمول';
      case InspectionAnswerStatus.needsAction:
        return 'نیاز به اقدام';
    }
  }

  String get dbValue {
    switch (this) {
      case InspectionAnswerStatus.yes:
        return 'yes';
      case InspectionAnswerStatus.no:
        return 'no';
      case InspectionAnswerStatus.notApplicable:
        return 'not_applicable';
      case InspectionAnswerStatus.needsAction:
        return 'needs_action';
    }
  }
}

class ChecklistDetailPage extends StatefulWidget {
  const ChecklistDetailPage({
    super.key,
    required this.checklist,
  });

  final Checklist checklist;

  @override
  State<ChecklistDetailPage> createState() => _ChecklistDetailPageState();
}

class _ChecklistDetailPageState extends State<ChecklistDetailPage> {
  final Map<String, InspectionAnswerStatus?> _statuses = <String, InspectionAnswerStatus?>{};
  final Map<String, TextEditingController> _notesControllers = <String, TextEditingController>{};

  bool _submitted = false;

  @override
  void initState() {
    super.initState();

    for (final ChecklistQuestion question in widget.checklist.questions) {
      _statuses[question.id] = null;
      _notesControllers[question.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _notesControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int _answeredCount() {
    return _statuses.values.where((InspectionAnswerStatus? value) => value != null).length;
  }

  int _totalCount() {
    return widget.checklist.questions.length;
  }

  double _progressValue() {
    final int total = _totalCount();
    if (total == 0) return 0;
    return _answeredCount() / total;
  }

  Future<void> _submitInspection() async {
    final bool hasUnanswered = _statuses.values.any((InspectionAnswerStatus? value) => value == null);

    if (hasUnanswered) {
      final bool? continueAnyway = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ثبت ناقص'),
            content: const Text(
              'هنوز برای همه سوال‌ها پاسخ ثبت نشده است. آیا می‌خواهید با همین وضعیت ادامه دهید؟',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('خیر'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('بله'),
              ),
            ],
          );
        },
      );

      if (continueAnyway != true) return;
    }

    setState(() {
      _submitted = true;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('بازرسی با موفقیت ثبت شد.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int total = _totalCount();
    final int answered = _answeredCount();
    final double progress = _progressValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.checklist.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: 'ثبت نهایی',
            onPressed: _submitInspection,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: <Widget>[
                    _InfoChip(label: 'کد', value: widget.checklist.id),
                    _InfoChip(label: 'دسته‌بندی', value: widget.checklist.category),
                    _InfoChip(label: 'تعداد سوالات', value: total.toString()),
                    _InfoChip(label: 'پاسخ‌داده‌شده', value: answered.toString()),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 6),
                Text(
                  'پیشرفت: ${(progress * 100).toStringAsFixed(0)}٪',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              itemCount: widget.checklist.questions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                final ChecklistQuestion question = widget.checklist.questions[index];
                return _InspectionQuestionCard(
                  index: index + 1,
                  question: question,
                  status: _statuses[question.id],
                  noteController: _notesControllers[question.id]!,
                  onStatusChanged: (InspectionAnswerStatus? value) {
                    setState(() {
                      _statuses[question.id] = value;
                    });
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _submitInspection,
                      icon: const Icon(Icons.check),
                      label: Text(_submitted ? 'ثبت شد' : 'ثبت نهایی'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _InspectionQuestionCard extends StatelessWidget {
  const _InspectionQuestionCard({
    required this.index,
    required this.question,
    required this.status,
    required this.noteController,
    required this.onStatusChanged,
  });

  final int index;
  final ChecklistQuestion question;
  final InspectionAnswerStatus? status;
  final TextEditingController noteController;
  final ValueChanged<InspectionAnswerStatus?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.28),
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 14,
                child: Text(
                  index.toString(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: InspectionAnswerStatus.values.map((InspectionAnswerStatus option) {
              final bool selected = status == option;

              return ChoiceChip(
                label: Text(option.label),
                selected: selected,
                onSelected: (_) {
                  onStatusChanged(selected ? null : option);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: noteController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'توضیحات / اقدام اصلاحی',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
