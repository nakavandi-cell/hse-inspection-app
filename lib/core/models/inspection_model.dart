class InspectionModel {
  final int? id;
  final String title;
  final String date;
  final String status;
  final String checklistId;
  final String checklistTitle;
  final String checklistCode;

  InspectionModel({
    this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.checklistId,
    required this.checklistTitle,
    required this.checklistCode,
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
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'date': date,
      'status': status,
      'checklist_id': checklistId,
      'checklist_title': checklistTitle,
      'checklist_code': checklistCode,
    };
  }

  factory InspectionModel.fromMap(Map<String, dynamic> map) {
    return InspectionModel(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      date: map['date'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      checklistId: map['checklistId'] as String? ?? map['checklist_id'] as String? ?? '',
      checklistTitle: map['checklistTitle'] as String? ?? map['checklist_title'] as String? ?? '',
      checklistCode: map['checklistCode'] as String? ?? map['checklist_code'] as String? ?? '',
    );
  }

  factory InspectionModel.fromDbMap(Map<String, dynamic> map, {dynamic answers}) {
    return InspectionModel.fromMap(map);
  }

  InspectionModel copyWith({
    int? id,
    String? title,
    String? date,
    String? status,
    String? checklistId,
    String? checklistTitle,
    String? checklistCode,
  }) {
    return InspectionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      status: status ?? this.status,
      checklistId: checklistId ?? this.checklistId,
      checklistTitle: checklistTitle ?? this.checklistTitle,
      checklistCode: checklistCode ?? this.checklistCode,
    );
  }
}
