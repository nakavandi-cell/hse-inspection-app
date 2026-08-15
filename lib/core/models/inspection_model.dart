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
}
