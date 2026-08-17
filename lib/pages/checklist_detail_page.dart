import 'package:flutter/material.dart';

import '../core/models/checklist_model.dart';

class ChecklistDetailPage extends StatelessWidget {
  const ChecklistDetailPage({
    super.key,
    required this.checklist,
  });

  final Checklist checklist;

  @override
  Widget build(BuildContext context) {
    final int questionCount = checklist.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(checklist.title),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          _ChecklistHeader(
            checklistId: checklist.id,
            category: checklist.category,
            questionCount: questionCount,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
              itemCount: checklist.questions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (BuildContext context, int index) {
                final ChecklistQuestion question = checklist.questions[index];

                return _QuestionCard(
                  index: index + 1,
                  question: question,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistHeader extends StatelessWidget {
  const _ChecklistHeader({
    required this.checklistId,
    required this.category,
    required this.questionCount,
  });

  final String checklistId;
  final String category;
  final int questionCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: <Widget>[
          _InfoChip(label: 'کد', value: checklistId),
          _InfoChip(label: 'دسته‌بندی', value: category),
          _InfoChip(label: 'تعداد سوالات', value: questionCount.toString()),
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

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
  });

  final int index;
  final ChecklistQuestion question;

  String _questionCode(ChecklistQuestion question) {
    return question.id.trim().isEmpty ? '-' : question.id;
  }

  @override
  Widget build(BuildContext context) {
    final String code = _questionCode(question);

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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 14,
                child: Text(
                  index.toString(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                'کد سوال: $code',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question.text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
