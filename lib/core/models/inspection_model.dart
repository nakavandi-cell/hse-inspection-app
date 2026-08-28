class InspectionModel {
  final int? id;
  final String title;
  final String date;
  final String status;
  final String checklistId;
  final String checklistTitle;
  final String checklistCode;
  final DateTime? createdAt;

  InspectionModel({
    this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.checklistId,
    required this.checklistTitle,
    required this.checklistCode,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'date': date,
      'status': status,
      'checklistId': checklistId,
      'checklistTitle': checklistTitle,
      'checklistCode': checklistCode,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  Map<String, dynamic> toDbMap() {
    return toMap();
  }

  factory InspectionModel.fromMap(Map<String, dynamic> map) {
    return InspectionModel(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      date: map['date'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      checklistId: map['checklistId'] as String? ?? '',
      checklistTitle: map['checklistTitle'] as String? ?? '',
      checklistCode: map['checklistCode'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  InspectionModel copyWith({
    int? id,
    AxisAlignment: CrossAxisAlignment.stretch,
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
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (code.isNotEmpty)
                        Text(
                          'کد مدرک: $code',
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
                          /inspections/presentation/pages/dynamic_inspection_page.dart';

class ChecklistDetailPage extends StatelessWidget {
  final dynamic checklist;
  final String? checklistId;

  const ChecklistDetailPage({
    super.key,
    this.checklist,
    this.checklistId,
  });

  @override
  Widget build(BuildContext context) {
    final String title = checklist is Checklist
        ? (checklist as Checklist).title
        : (checklist != null && checklist.title != null
            ? checklist.title.toString()
            : 'جزئیات چک‌لیست');

    final String code = checklist is Checklist
        ? (checklist as Checklist).code
        : (checklist != null && checklist.code != null
            ? checklist.code.toString()
            : '');

    final String cId = checklist is Checklist
        ? (checklist as Checklist).id
        : (checklistId ?? (checklist != null && checklist.id != null ? checklist.id.toString() : ''));

    final List<dynamic> sections = checklist is Checklist
        ? (checklist as Checklist).sections
        : (checklist != null && checklist.sections != null
            ? checklist.sections as List<dynamic>
            : []);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
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
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (code.isNotEmpty)
                        Text(
                          'کد مدرک: $code',
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
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DynamicInspectionPage(
                        checklist: checklist,
                        checklistId: cId,
                        checklistTitle: title,
                        checklistCode: code,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  'شروع بازرسی جدید',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                    final sectionTitle = section is Section
                        ? section.title
                        : (section.title?.toString() ?? 'بخش ${index + 1}');
                    final questionsCount = section is Section
                        ? section.questions.length
                        : (section.questions != null ? (section.questions as List).length : 0);

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
            ],
          ),
        ),
      ),
    );
  }
}
