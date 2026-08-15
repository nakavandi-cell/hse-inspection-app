class InspectionModel {
  final int? id;
  final String checklistId;
  final String sectionKey;
  final String title;
  final String status;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const InspectionModel({
    this.id,
    required this.checklistId,
    required this.sectionKey,
    required this.title,
    required this.status,
    this.startedAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'checklist_id': checklistId,
        'section_key': sectionKey,
        'title': title,
        'status': status,
        'started_at': startedAt?.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
      };

  factory InspectionModel.fromMap(Map<String, dynamic> m) => InspectionModel(
        id: m['id'] as int?,
        checklistId: m['checklist_id'] as String,
        sectionKey: m['section_key'] as String,
        title: m['title'] as String,
        status: m['status'] as String,
        startedAt: m['started_at'] != null
            ? DateTime.tryParse(m['started_at'] as String)
            : null,
        completedAt: m['completed_at'] != null
            ? DateTime.tryParse(m['completed_at'] as String)
            : null,
      );
}
