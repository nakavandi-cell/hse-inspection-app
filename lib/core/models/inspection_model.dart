class InspectionModel {
  final int? id;
  final String title;
  final String date;
  final String status;
  final String checklistId;
  final String checklistTitle;
  final String checklistCode;
  final String? checklistCategory;
  final DateTime? createdAt;

  InspectionModel({
    this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.checklistId,
    required this.checklistTitle,
    required this.checklistCode,
    this.checklistCategory,
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
      if (checklistCategory != null) 'checklistCategory': checklistCategory,
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
      checklistCategory: map['checklistCategory'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  InspectionModel copyWith({
    int? id,
    String? title,
    String? date,
    String? status,
    String? checklistId,
    String? checklistTitle,
    String? checklistCode,
    String? checklistCategory,
    DateTime? createdAt,
  }) {
    return InspectionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      status: status ?? this.status,
      checklistId: checklistId ?? this.checklistId,
      checklistTitle: checklistTitle ?? this.checklistTitle,
      checklistCode: checklistCode ?? this.checklistCode,
      checklistCategory: checklistCategory ?? this.checklistCategory,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
