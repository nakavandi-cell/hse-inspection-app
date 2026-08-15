import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/answer_model.dart';
import '../../../../core/models/checklist_model.dart';
import '../../../../core/models/checklist_question_model.dart';
import '../../../../core/models/inspection_model.dart';
import '../../../../core/models/inspection_status.dart';
import '../../../../core/providers/providers.dart';

const _yesNoOptions = <Map<String, String>>[
  {'v': 'yes', 'l': 'بله'},
  {'v': 'no', 'l': 'خیر'},
  {'v': 'na', 'l': 'بررسی نشده'},
];

const _yesPartialNoOptions = <Map<String, String>>[
  {'v': 'yes', 'l': 'بله'},
  {'v': 'partial', 'l': 'تا حدودی'},
  {'v': 'no', 'l': 'خیر'},
  {'v': 'na', 'l': 'بررسی نشده'},
];

class DynamicInspectionPage extends ConsumerStatefulWidget {
  final String sectionKey;
  final String sectionTitle;
  final int? inspectionId;

  const DynamicInspectionPage({
    super.key,
    required this.sectionKey,
    required this.sectionTitle,
    this.inspectionId,
  });

  @override
  ConsumerState<DynamicInspectionPage> createState() =>
      _DynamicInspectionPageState();
}

class _DynamicInspectionPageState extends ConsumerState<DynamicInspectionPage> {
  final Map<String, String> _answers = {};
  final Map<String, TextEditingController> _noteControllers = {};
  final Map<String, TextEditingController> _actionControllers = {};
  InspectionModel? _originalInspection;
  bool _loadingAnswers = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final id = widget.inspectionId;
    if (id != null) {
      _loadingAnswers = true;
      Future.microtask(() async {
        try {
          final inspection =
              await ref.read(inspectionProvider(id).future);
          final answers =
              await ref.read(inspectionAnswersProvider(id).future);
          if (!mounted) return;
          setState(() {
            _originalInspection = inspection;
            _applyAnswers(answers);
            _loadingAnswers = false;
          });
        } catch (_) {
          if (mounted) setState(() => _loadingAnswers = false);
        }
      });
    }
  }

  void _applyAnswers(List<AnswerModel> answers) {
    for (final a in answers) {
      _answers[a.questionId] = a.answer;
      _noteControllers.putIfAbsent(
        a.questionId,
        () => TextEditingController(text: a.note),
      );
      _actionControllers.putIfAbsent(
        a.questionId,
        () => TextEditingController(text: a.correctiveAction),
      );
    }
  }

  @override
  void dispose() {
    for (final c in _noteControllers.values) {
      c.dispose();
    }
    for (final c in _actionControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _noteControllerFor(ChecklistQuestionModel q) =>
      _noteControllers.putIfAbsent(q.id, () => TextEditingController());

  TextEditingController _actionControllerFor(ChecklistQuestionModel q) =>
      _actionControllers.putIfAbsent(q.id, () => TextEditingController());

  List<Map<String, String>> _optionsFor(String type) =>
      type == 'yes_partial_no' ? _yesPartialNoOptions : _yesNoOptions;

  Future<void> _save({required bool asDraft}) async {
    if (_loadingAnswers || _saving) return;

    final checklist =
        ref.read(checklistByKeyProvider(widget.sectionKey)).valueOrNull;
    if (checklist == null) return;

    final missing = checklist.questions
        .where((q) => q.requiredField && (_answers[q.id]?.isEmpty ?? true))
        .toList();

    if (missing.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${missing.length} سؤال الزامی بدون پاسخ مانده است.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    final now = DateTime.now();
    final inspection = InspectionModel(
      id: widget.inspectionId,
      checklistId: checklist.id,
      sectionKey: widget.sectionKey,
      title: widget.sectionTitle,
      status: asDraft
          ? (widget.inspectionId == null
              ? InspectionStatus.draft.dbValue
              : InspectionStatus.inProgress.dbValue)
          : InspectionStatus.completed.dbValue,
      startedAt: _originalInspection?.startedAt ?? now,
      completedAt: asDraft ? null : now,
    );

    final answers = checklist.questions.map((q) {
      return AnswerModel(
        inspectionId: 0,
        questionId: q.id,
        answer: _answers[q.id] ?? 'na',
        note: _cleanText(_noteControllers[q.id]?.text),
        correctiveAction: _cleanText(_actionControllers[q.id]?.text),
      );
    }).toList();

    try {
      final id = await ref.read(inspectionRepositoryProvider).saveInspection(
            inspection: inspection,
            answers: answers,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            asDraft ? 'پیش‌نویس با کد $id ذخیره شد.' : 'بازرسی با کد $id ثبت شد.',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ذخیره‌سازی: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _cleanText(String? value) {
    final t = value?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(checklistByKeyProvider(widget.sectionKey));

    return Scaffold(
      appBar: AppBar(title: Text(widget.sectionTitle)),
      body: asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          message: '$e',
          onRetry: () =>
              ref.invalidate(checklistByKeyProvider(widget.sectionKey)),
        ),
        data: (checklist) {
          if (checklist == null) return const _NotFoundView();
          return _buildForm(checklist);
        },
      ),
      bottomNavigationBar: asyncValue.maybeWhen(
        data: (c) => c != null ? _buildBottomBar() : null,
        orElse: () => null,
      ),
    );
  }

  Widget _buildForm(ChecklistModel checklist) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: checklist.questions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final q = checklist.questions[index];
        return _QuestionCard(
          index: index,
          question: q,
          options: _optionsFor(q.type),
          selected: _answers[q.id],
          onSelected: (v) => setState(() => _answers[q.id] = v),
          noteController: _noteControllerFor(q),
          actionController: _actionControllerFor(q),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: (_saving || _loadingAnswers)
                    ? null
                    : () => _save(asDraft: true),
                child: const Text('ذخیره پیش‌نویس'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: (_saving || _loadingAnswers)
                    ? null
                    : () => _save(asDraft: false),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('ثبت نهایی بازرسی'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final int index;
  final ChecklistQuestionModel question;
  final List<Map<String, String>> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  final TextEditingController noteController;
  final TextEditingController actionController;

  const _QuestionCard({
    required this.index,
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.noteController,
    required this.actionController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.requiredField
                        ? '${question.text} *'
                        : question.text,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((o) {
                final isSelected = selected == o['v'];
                return ChoiceChip(
                  label: Text(o['l']!),
                  selected: isSelected,
                  onSelected: (_) => onSelected(o['v']!),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              textAlign: TextAlign.right,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'توضیحات',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: actionController,
              textAlign: TextAlign.right,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'شماره / شرح اقدام اصلاحی',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

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

class _NotFoundView extends StatelessWidget {
  const _NotFoundView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('چک‌لیستی برای این بخش یافت نشد.'),
        ],
      ),
    );
  }
}
