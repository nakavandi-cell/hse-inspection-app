import 'package:flutter/material.dart';

class DynamicInspectionPage extends StatefulWidget {
  final String sectionKey;
  final String sectionTitle;

  const DynamicInspectionPage({
    super.key,
    required this.sectionKey,
    required this.sectionTitle,
  });

  @override
  State<DynamicInspectionPage> createState() => _DynamicInspectionPageState();
}

class _DynamicInspectionPageState extends State<DynamicInspectionPage> {
  final Map<int, String> _answers = {};
  final Map<int, TextEditingController> _notesControllers = {};

  late final List<InspectionQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _questions = _buildSampleQuestions(widget.sectionKey);

    for (var i = 0; i < _questions.length; i++) {
      _notesControllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _notesControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<InspectionQuestion> _buildSampleQuestions(String sectionKey) {
    switch (sectionKey) {
      case 'electrical_general':
        return const [
          InspectionQuestion('سیم‌کشی‌ها در وضعیت ایمن قرار دارند.'),
          InspectionQuestion('از اتصالات غیرمجاز و موقت استفاده نشده است.'),
          InspectionQuestion('پوشش و عایق تجهیزات الکتریکی سالم است.'),
        ];
      case 'electrical_panels':
        return const [
          InspectionQuestion('درب تابلو برق سالم و قابل بسته شدن است.'),
          InspectionQuestion('روی تابلو برق علائم هشدار نصب شده است.'),
          InspectionQuestion('در مقابل تابلو برق مانع یا انسداد وجود ندارد.'),
        ];
      case 'electrical_substations':
        return const [
          InspectionQuestion('دسترسی به پست برق محدود و کنترل‌شده است.'),
          InspectionQuestion('تجهیزات پست برق دارای وضعیت ظاهری مناسب هستند.'),
          InspectionQuestion('نظافت و نظم محیط پست برق مناسب است.'),
        ];
      case 'portable_electrical_devices':
        return const [
          InspectionQuestion('کابل دستگاه سالم و بدون پارگی است.'),
          InspectionQuestion('دوشاخه و اتصالات دستگاه سالم هستند.'),
          InspectionQuestion('بدنه دستگاه فاقد آسیب‌دیدگی ظاهری است.'),
        ];
      default:
        return const [
          InspectionQuestion('سوال نمونه ۱'),
          InspectionQuestion('سوال نمونه ۲'),
          InspectionQuestion('سوال نمونه ۳'),
        ];
    }
  }

  void _submitForm() {
    final unanswered = _questions.asMap().entries.where((entry) {
      final index = entry.key;
      return _answers[index] == null;
    }).toList();

    if (unanswered.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لطفاً وضعیت همه سوالات را مشخص کنید.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'اطلاعات فرم با موفقیت ثبت شد. اتصال به دیتابیس در مرحله بعد انجام می‌شود.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sectionTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'فرم بازرسی',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'بخش انتخاب‌شده: ${widget.sectionTitle}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ${question.text}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _AnswerChoiceChip(
                              label: 'OK',
                              selected: _answers[index] == 'OK',
                              color: Colors.green,
                              onSelected: () {
                                setState(() {
                                  _answers[index] = 'OK';
                                });
                              },
                            ),
                            _AnswerChoiceChip(
                              label: 'NG',
                              selected: _answers[index] == 'NG',
                              color: Colors.red,
                              onSelected: () {
                                setState(() {
                                  _answers[index] = 'NG';
                                });
                              },
                            ),
                            _AnswerChoiceChip(
                              label: 'NA',
                              selected: _answers[index] == 'NA',
                              color: Colors.grey,
                              onSelected: () {
                                setState(() {
                                  _answers[index] = 'NA';
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _notesControllers[index],
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'توضیحات / اقدام اصلاحی',
                            hintText: 'در صورت نیاز توضیح یا اقدام اصلاحی را وارد کنید',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text(
                    'ثبت فرم بازرسی',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InspectionQuestion {
  final String text;

  const InspectionQuestion(this.text);
}

class _AnswerChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onSelected;

  const _AnswerChoiceChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: color.withOpacity(0.18),
      labelStyle: TextStyle(
        color: selected ? color : Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      side: BorderSide(
        color: selected ? color : Colors.grey.shade400,
      ),
    );
  }
}
