import 'inspection_status.dart';

class InspectionModel {
  final String id;
  final String title;
  final DateTime date;
  final InspectionStatus status;
  final String? checklistId;
  final String? checklistTitle;
  final String? checklistCode;

  const InspectionModel({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    this.checklistId,
    this.checklistTitle,
    this.checklistCode,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      date: json['date'] == null
          ? DateTime.now()
          : DateTime.tryParse(json['date'].toString()) ?? DateTime.now(),
      status: InspectionStatusX.fromValue(json['status']?.toString()),
      checklistId: json['checklistId']?.toString(),
      checklistTitle: json['checklistTitle']?.toString(),
      checklistCode: json['checklistCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'status': status.value,
      if (checklistId != null) 'checklistId': checklistId,
      if (checklistTitle != null) 'checklistTitle': checklistTitle,
      if (checklistCode != null) 'checklistCode': checklistCode,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'status': status.value,
      'checklist_id': checklistId,
      'checklist_title': checklistTitle,
      'checklist_code': checklistCode,
    };
  }

  factory InspectionModel.fromDbMap(Map<String, dynamic> map) {
    return InspectionModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      date: map['date'] == null
          ? DateTime.now()
          : DateTime.tryParse(map['date'].toString()) ?? DateTime.now(),
      status: InspectionStatusX.fromValue(map['status']?.toString()),
      checklistId: map['checklist_id']?.toString(),
      checklistTitle: map['checklist_title']?.toString(),
      checklistCode: map['checklist_code']?.toString(),
    );
  }

  InspectionModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    InspectionStatus? status,
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
